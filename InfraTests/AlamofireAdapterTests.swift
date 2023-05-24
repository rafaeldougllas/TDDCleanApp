//
//  AlamofireAdapterTests.swift
//  InfraTests
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 25/04/23.
//

import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        session.request(url,
                        method: .post,
                        parameters: data?.toJson(),
                        encoding: JSONEncoding.default).responseData { dataResponse in
            switch dataResponse.result {
            case .failure: completion(.failure(.noConnectivity))
            case .success: break
            }
        }
    }
}

final class AlamofireAdapterTests: XCTestCase {
    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeUrl()
        testRequestFor(url: url, with: makeValidData()) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_make_request_with_no_data() {
        testRequestFor(with: nil, action: { request in
            XCTAssertNil(request.httpBodyStream)
        })
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_error() {
        let sut = makeSut()
        UrlProtocolStub.simulateR(data: nil, response: nil, error: makeError())
        let expectation = expectation(description: "waiting async function")
        sut.post(to: makeUrl(), with: makeValidData()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .noConnectivity)
            case .success: XCTFail("Expected error got \(result) instead")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

extension AlamofireAdapterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequestFor(url: URL = makeUrl(), with data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        sut.post(to: url, with: data) { _ in }
        let expectation = expectation(description: "Waiting Async Method")
        UrlProtocolStub.observerRequest(completion: { request in
            action(request)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    static func simulateR(data: Data?,
                          response: HTTPURLResponse?,
                          error: Error) {
        UrlProtocolStub.data = data
        UrlProtocolStub.response = response
        UrlProtocolStub.error = error
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        UrlProtocolStub.emit?(request)
        if let data = UrlProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = UrlProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = UrlProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self) // Need to know is finished settings
    }
    
    override open func stopLoading() {
        
    }
}
