//
//  TestsFactories.swift
//  DataTests
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 25/04/23.
//

import Foundation
import Domain

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeAccount() -> Account {
    return Account(name: "any-name",
                   email: "any-email",
                   password: "any-password",
                   passwordConfirm: "any-passwordConfirm")
}

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "any-id",
                        name: "any-name",
                        email: "any-email",
                        password: "any-password")
}

func makeInvalidData() -> Data {
    return Data("invalid-data".utf8)
}

func makeValidData() -> Data {
    return Data("{\"name\":\"Rafael\"}".utf8)
}

func makeError() -> Error {
        return NSError(domain: "Any-Error", code: -1)
}
