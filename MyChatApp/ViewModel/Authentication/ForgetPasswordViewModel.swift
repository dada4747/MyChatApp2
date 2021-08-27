//
//  ForgetPasswordViewModel.swift
//  MyChatApp
//
//  Created by gadgetzone on 18/08/21.
//

import Foundation
struct ForgetPasswordViewModel: AuthenticationProtocol {
   
    var email   : String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
    }
}
