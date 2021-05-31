//
//  UserHealthProfile.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/05/24.
//

import HealthKit

class UserHealthProfile {
  
  var age: Int?
  var biologicalSex: HKBiologicalSex?
  var bloodType: HKBloodType?
  var heightInMeters: Double?
  var weightInKilograms: Double?
  
  var bodyMassIndex: Double? {
    
    guard let weightInKilograms = weightInKilograms,
      let heightInMeters = heightInMeters,
      heightInMeters > 0 else {
        return nil
    }
    
    return (weightInKilograms/(heightInMeters*heightInMeters))
  }
    
    
}

extension HKBloodType {
  
  var stringRepresentation: String {
    switch self {
    case .notSet: return "Unknown"
    case .aPositive: return "A+"
    case .aNegative: return "A-"
    case .bPositive: return "B+"
    case .bNegative: return "B-"
    case .abPositive: return "AB+"
    case .abNegative: return "AB-"
    case .oPositive: return "O+"
    case .oNegative: return "O-"
    }
  }
}

extension HKBiologicalSex {
  
  var stringRepresentation: String {
    switch self {
    case .notSet: return "Unknown"
    case .female: return "Female"
    case .male: return "Male"
    case .other: return "Other"
    }
  }
}

