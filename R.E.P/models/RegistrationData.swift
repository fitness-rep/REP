//
//  UserRegistration.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import Foundation

class RegistrationData: ObservableObject {
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var gender: Gender = Gender.male
    @Published var email: String = ""
    @Published var fitnessGoal: String = ""
    @Published var age: Int = 0
    @Published var height: Double = 0.0
    @Published var weight: Double = 0.0
    
    init() {
        
    }
    
//    init(name: String, phoneNumber: String, gender: Gender, email: String, fitnessGoal: String, age: Int, height: Double, weight: Double) {
//        self.name = name
//        self.phoneNumber = phoneNumber
//        self.gender = gender
//        self.email = email
//        self.fitnessGoal = fitnessGoal
//        self.age = age
//        self.height = height
//        self.weight = weight
//    }
}

enum Gender {
    case male
    case female
}
