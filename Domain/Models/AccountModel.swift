//
//  AccountModel.swift
//  Domain
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 27/01/23.
//

import Foundation

public struct AccountModel: Model {
    var id: String
    var name: String
    var email: String
    var password: String
    
    public init(id: String,
                name: String,
                email: String,
                password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
