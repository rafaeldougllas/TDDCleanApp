//
//  TestsFactories.swift
//  DataTests
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 25/04/23.
//

import Foundation
import Domain

func makeUrl() -> URL {
    return URL(string: "https://any-url.com")!
}

func makeAccount() -> AddAccountModel {
    return AddAccountModel(name: "any-name",
                           email: "any-email",
                           password: "any-password",
                           passwordConfirmation: "any-passwordConfirmation")
}

func makeInvalidData() -> Data {
    return Data("invalid-data".utf8)
}

func makeValidData() -> Data {
    return Data("{\"name\":\"Rafael\"}".utf8)
}

func makeEmptyData() -> Data {
    return Data()
}

func makeError() -> Error {
    return NSError(domain: "Any-Error", code: -1)
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(url: makeUrl(),
                           statusCode: statusCode,
                           httpVersion: nil,
                           headerFields: nil)!
}
