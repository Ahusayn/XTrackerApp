//
//  ProfileModel.swift
//  XTracker
//
//  Created by HSSN on 16/01/2025.
//

import Foundation
import SwiftData

@Model
class ProfileModel: Identifiable {
    
    var firstName: String 
    var lastName: String
    var email: String
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
}
