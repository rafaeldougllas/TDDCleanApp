//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by rafael douglas on 27/06/23.
//

import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "any-id",
                        name: "any-name",
                        email: "any-email",
                        password: "any-password")
}

func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(name: "any_name",
                           email: "any_email@mail.com",
                           password: "any_password",
                           passwordConfirmation: "any_password")
}
