//
//  URLRequestTests.swift
//  
//
//  Created by Timothy Barrett on 12/25/20.
//

import XCTest
@testable import Networking

final class URLRequestTests: XCTestCase {

   func test_InitializationFromEndpoint_ReturnsValidInstance() {
      // Given
      let endpoint = MockEndpoint()
      let urlRequest = URLRequest(endpoint: endpoint)

      // Then

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

   func test_APIEndpointRequestProperty_ReturnsValidURLRequestInstance() {
      // Given
      let endpoint = MockEndpoint()
      let urlRequest = endpoint.request

      // Then
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
}

// MARK: - Mock Test Data

fileprivate struct MockEndpoint: APIEndpoint {
   static var validationUrl: URL {
      URL(string: "https://www.test.com/testing?filter=music")!
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
