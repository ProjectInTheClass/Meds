//
//  ProfileViewController.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/05/24.
//

import UIKit
import HealthKit


class ProfileViewController: UITableViewController {
    private enum ProfileSection: Int {
      case userInfo
      case readHealthKitData
      case saveBMI
    }
    
    private enum ProfileDataError: Error {
      
      case missingBodyMassIndex
      
      var localizedDescription: String {
        switch self {
        case .missingBodyMassIndex:
          return "Unable to calculate body mass index with available profile data."
        }
      }
    }
    
    @IBOutlet private var ageLabel:UILabel!
    @IBOutlet private var bloodTypeLabel:UILabel!
    @IBOutlet private var biologicalSexLabel:UILabel!
    @IBOutlet private var weightLabel:UILabel!
    @IBOutlet private var heightLabel:UILabel!
    @IBOutlet private var bodyMassIndexLabel:UILabel!
    
    private let userHealthProfile = UserHealthProfile()//model 폴더에 있는 userHealthProfile 객체를 생성.
    
    private func updateHealthInfo() {

      loadAndDisplayAgeSexAndBloodType()
      loadAndDisplayMostRecentWeight()
      loadAndDisplayMostRecentHeight()
    }
    
    //profileDataStore.swift 에서 Age, Sex BloodType 읽어옴.
    private func loadAndDisplayAgeSexAndBloodType() {
          do {
            let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
            userHealthProfile.age = userAgeSexAndBloodType.age
            userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
            userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
            updateLabels()
          } catch let error {
            self.displayAlert(for: error)
          }
    }
    
    private func updateLabels() {
      if let age = userHealthProfile.age {
        ageLabel.text = "\(age)"
      }

      if let biologicalSex = userHealthProfile.biologicalSex {
        biologicalSexLabel.text = biologicalSex.stringRepresentation
      }

      if let bloodType = userHealthProfile.bloodType {
        bloodTypeLabel.text = bloodType.stringRepresentation
      }
      
      if let weight = userHealthProfile.weightInKilograms {
        
        let weightFormatter = MassFormatter()
        weightFormatter.isForPersonMassUse = true
//        print(" weightFormatter : \(weightFormatter) weight : \(weight)")
//        print(" \(weightFormatter.string(fromKilograms: weight))")
//        weightFormatter.string(fromValue: weight, unit: MassFormatter.Unit)
        weightLabel.text = weightFormatter.string(fromValue: weight, unit: .kilogram)
      }
          
      if let height = userHealthProfile.heightInMeters {
        let heightFormatter = LengthFormatter()
        heightFormatter.isForPersonHeightUse = true
        print(" heightFormatter : \(heightFormatter) height : \(height)")
        print(" \(heightFormatter.string(fromMeters: height))")
        heightLabel.text = heightFormatter.string(fromValue: height, unit: .meter)
            
//            heightFormatter.string(fromMeters: height)
      }
         
      if let bodyMassIndex = userHealthProfile.bodyMassIndex {
        bodyMassIndexLabel.text = String(format: "%.02f", bodyMassIndex)
      }
      
      

    }
    
    private func loadAndDisplayMostRecentHeight() {
      //1. Use HealthKit to create the Height Sample Type
      guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
        print("Height Sample Type is no longer available in HealthKit")
        return
      }//sample유형 만들기.
          
      ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
            //여기서 만든 샘플 유형을 전달하면 HealthKit에 기록 된 가장 최근의 높이 샘플이 반환. .
        guard let sample = sample else {
            
          if let error = error {
            self.displayAlert(for: error)
          }
              
          return
        }
            
        //2. Convert the height sample to meters, save to the profile model,
        //   and update the user interface.
        let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
        self.userHealthProfile.heightInMeters = heightInMeters
        self.updateLabels()
      }

    }
    
    private func loadAndDisplayMostRecentWeight() {
      guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
        print("Body Mass Sample Type is no longer available in HealthKit")
        return
      }
          
      ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
            
        guard let sample = sample else {
              
          if let error = error {
            self.displayAlert(for: error)
          }
          return
        }
            
        let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
        self.userHealthProfile.weightInKilograms = weightInKilograms
        self.updateLabels()
      }

    }
    
    private func saveBodyMassIndexToHealthKit() {
        
//        authorizeHealthKit()
      guard let bodyMassIndex = userHealthProfile.bodyMassIndex else {
        displayAlert(for: ProfileDataError.missingBodyMassIndex)
        return
      }
          
      ProfileDataStore.saveBodyMassIndexSample(bodyMassIndex: bodyMassIndex,
                                               date: Date())

    }
    
    private func displayAlert(for error: Error) {
      
      let alert = UIAlertController(title: nil,
                                    message: error.localizedDescription,
                                    preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "O.K.",
                                    style: .default,
                                    handler: nil))
      
      present(alert, animated: true, completion: nil)
    }
    
    
    private func authorizeHealthKit() {
          HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in//authorized라는게 그냥 내장 변수인듯?
                
            guard authorized else {
                  
              let baseMessage = "HealthKit Authorization Failed"
                  
              if let error = error {
                print("\(baseMessage). Reason: \(error.localizedDescription)")
              } else {
                print(baseMessage)
              }
                  
              return
            }
            print("HealthKit Successfully Authorized.")
          }

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      guard let section = ProfileSection(rawValue: indexPath.section) else {
        fatalError("A ProfileSection should map to the index path's section")
      }
     authorizeHealthKit()

      switch section {
      case .saveBMI:
        saveBodyMassIndexToHealthKit()
      case .readHealthKitData:
        updateHealthInfo()
      default:
        break
      }
    }

}
