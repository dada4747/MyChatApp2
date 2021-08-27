//
//  LogInViewModel.swift
//  MyChatApp
//
//  Created by gadgetzone on 10/08/21.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LogInViewModel: AuthenticationProtocol {
    var email   : String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty    == false
            && password?.isEmpty == false
    }
}
