//
//  AlamofireAdapterTests.swift
//  InfraTests
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 25/04/23.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL) {
        session.request(url).resume()
    }
}

final class AlamofireAdapterTests: XCTestCase {
    func test_() {
        let url = makeUrl()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
        let expectation = expectation(description: "Waiting Async Method")
        UrlProtocolStub.observerRequest(completion: { request in
            XCTAssertEqual(url, request.url)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        UrlProtocolStub.emit?(request)
    }
    
    override open func stopLoading() {
        
    }
}
