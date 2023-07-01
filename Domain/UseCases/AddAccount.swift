//
//  AddAccountUseCase.swift
//  Domain
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 27/01/23.
//

import Foundation

public protocol AddAccount {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func add(addAccountModel: AddAccountModel,
             completion: @escaping (AddAccount.Result) -> Void)
}

public struct AddAccountModel: Model {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
    
    public init(name: String, email: String, password: String, passwordConfirmation: String) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
