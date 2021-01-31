//
//  URLRequestTests.swift
//  
//
//  Created by Timothy Barrett on 12/25/20.
//

import XCTest
@testable import Networking

final class URLRequestTests: XCTestCase {

   // MARK: Properties

   private var endpoint: Endpoint!

   // MARK: Overrides

   override func setUp() {
      super.setUp()

      endpoint = MockEndpoint()
   }

   override func tearDown() {
      endpoint = nil

      super.tearDown()
   }

   // MARK: Unit Tests

   func test_InitializationFromEndpoint_ReturnsConfiguredURLRequestInstance() {
      // Given
      let urlRequest = URLRequest(endpoint: endpoint)

      // Then
      validateCommonAsserts(for: urlRequest)
   }

   func test_APIEndpointRequestProperty_ReturnsConfiguredURLRequestInstance() {
      // Given
      let urlRequest = endpoint.request()

      // Then
      validateCommonAsserts(for: urlRequest)
   }

   func test_InitializationFromEndpointWithToken_ReturnsConfiguredURLRequestInstance() {
      // Given
      let urlRequest = URLRequest(endpoint: endpoint, refreshToken: "uvnciod0o39847ygfhejdk")

      // Then
      validateWithTokenCommonAsserts(for: urlRequest)
   }

   func test_APIEndpointRequestWithTokenProperty_ReturnsConfiguredURLRequestInstance() {
      // Given
      let urlRequest = endpoint.request(refreshToken: "uvnciod0o39847ygfhejdk")

      // Then
      validateWithTokenCommonAsserts(for: urlRequest)
   }

   private func validateCommonAsserts(for urlRequest: URLRequest) {
      XCTAssertEqual(urlRequest.httpBody, nil)
      XCTAssertEqual(urlRequest.httpMethod, "GET")
      XCTAssertEqual(urlRequest.timeoutInterval, 60.0)
      XCTAssertEqual(urlRequest.allowsCellularAccess, true)
      XCTAssertEqual(urlRequest.url, MockEndpoint.validationUrl)
      XCTAssertEqual(urlRequest.allowsExpensiveNetworkAccess, false)
      XCTAssertEqual(urlRequest.allowsConstrainedNetworkAccess, true)
      XCTAssertEqual(urlRequest.cachePolicy, .useProtocolCachePolicy)
      XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
   }

   private func validateWithTokenCommonAsserts(for urlRequest: URLRequest) {
      XCTAssertEqual(urlRequest.httpBody, nil)
      XCTAssertEqual(urlRequest.httpMethod, "GET")
      XCTAssertEqual(urlRequest.timeoutInterval, 60.0)
      XCTAssertEqual(urlRequest.allowsCellularAccess, true)
      XCTAssertEqual(urlRequest.url, MockEndpoint.validationUrlWithToken)
      XCTAssertEqual(urlRequest.allowsExpensiveNetworkAccess, false)
      XCTAssertEqual(urlRequest.allowsConstrainedNetworkAccess, true)
      XCTAssertEqual(urlRequest.cachePolicy, .useProtocolCachePolicy)
      XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
   }
}

// MARK: - Mock Test Data

fileprivate struct MockEndpoint: Endpoint {
   static var validationUrl: URL {
      URL(string: "https://www.test.com/testing?filter=music")!
   }

   static var validationUrlWithToken: URL {
      URL(string: "https://www.test.com/testing?refresh_token=uvnciod0o39847ygfhejdk&filter=music")!
   }

   var scheme: String {
      "https"
   }

   var host: String {
      "www.test.com"
   }

   var path: String {
      "/testing"
   }

   var queryItems: [URLQueryItem]? {
      [URLQueryItem(name: "filter", value: "music")]
   }

   var httpMethod: HTTPMethod {
      .get
   }

   var httpHeaderFields: [String : String]? {
      ["Content-Type": "application/json"]
   }

   var httpBody: Data? {
      nil
   }

   var cachePolicy: URLRequest.CachePolicy {
      .useProtocolCachePolicy
   }

   var timeoutInterval: TimeInterval {
      60.0
   }

   var allowsCellularAccess: Bool {
      true
   }

   var allowsExpensiveNetworkAccess: Bool {
      false
   }

   var allowsConstrainedNetworkAccess: Bool {
      true
   }
}
