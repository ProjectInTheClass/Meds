//
//  HealthkitSetupAssistant.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/05/24.
//

import HealthKit

class HealthKitSetupAssistant {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HealthkitSetupError.notAvailableOnDevice)
      return
    }
    print("???")
    print(HealthkitSetupError.notAvailableOnDevice)
    print("???")
    //2. Prepare the data types that will interact with HealthKit
    guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
//            let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
//            let totalEner = HKObjectType.quantityType(forIdentifier: .)
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
    }
    
    //3. Prepare a list of types you want HealthKit to read and write
    let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                    activeEnergy,
                                                    HKObjectType.workoutType()]
        
    let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                   bloodType,
                                                   biologicalSex,
                                                   bodyMassIndex,
                                                   height,
                                                   bodyMass,
                                                   HKObjectType.workoutType()]
    
    //4. Request Authorization
    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
      completion(success, error)//request?????? completion ?????????.
    }
    
  }
    
    
    
}
