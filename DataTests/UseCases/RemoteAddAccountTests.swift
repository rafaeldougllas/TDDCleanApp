//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 24/04/23.
//

import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_httpClient_with_correct_url() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAccount()) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccount()
        sut.add(addAccountModel: account) { _ in }
        XCTAssertEqual(httpClientSpy.data, account.toData())
    }
    
    func test_add_should_complete_with_error_if_client_fails() {
        let (sut, httpClientSpy) = makeSut()
        expec(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func test_add_should_complete_with_data_if_client_complete_with_valid_data() {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expec(sut, completeWith: .success(account), when: {
            httpClientSpy.completeWithData(account.toData()!)
        })
    }
    
    func test_add_should_complete_with_data_if_client_complete_with_invalid_data() {
        let (sut, httpClientSpy) = makeSut()
        expec(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func test_add_should_not_complete_if_sut_has_been_deallocated() {
        let httpClientSpy = HttpPostClientSpy()
        var sut: RemoteAddAccountUseCase? = RemoteAddAccountUseCase(url: makeUrl(), httpClient: httpClientSpy)
        var result: RemoteAddAccountUseCase.Result?
        sut?.add(addAccountModel: makeAccount(), completion: { result = $0 })
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: RemoteAddAccountUseCase, httpClientSpy: HttpPostClientSpy) {
        let httpClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccountUseCase(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }
    
    func expec(_ sut: RemoteAddAccountUseCase,
               completeWith expectedResult: AddAccount.Result,
               when action: () -> Void,
               file: StaticString = #filePath,
               line: UInt = #line) {
        let expectation = expectation(description: "Waiting Async Function")
        sut.add(addAccountModel: makeAccount()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) receive \(receivedResult) instead", file: file, line: line)
            }
            expectation.fulfill()
        }
        action()
        wait(for: [expectation], timeout: 1)
    }
}
