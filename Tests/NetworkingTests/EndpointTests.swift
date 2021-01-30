//
//  EndpointTests.swift
//  
//
//  Created by Timothy Barrett on 12/13/20.
//

import XCTest
@testable import Networking

final class EndpointTests: XCTestCase {

   func test_EndpointDefaults_ReturnCorrectValues() {
      // Given
      let defaultEndpoint = MockEndpointDefaultConfiguration()

      // Then

      XCTAssertEqual(defaultEndpoint.httpBody, nil)
      XCTAssertEqual(defaultEndpoint.scheme, "https")
      XCTAssertEqual(defaultEndpoint.queryItems, nil)
      XCTAssertEqual(defaultEndpoint.httpMethod, .get)
      XCTAssertEqual(defaultEndpoint.httpHeaderFields, nil)
      XCTAssertEqual(defaultEndpoint.timeoutInterval, 60.0)
      XCTAssertEqual(defaultEndpoint.path, "/testing/unit")
      XCTAssertEqual(defaultEndpoint.validStatusCodes, Array(200...299))
      XCTAssertEqual(defaultEndpoint.host, "www.testing.com")
      XCTAssertEqual(defaultEndpoint.allowsCellularAccess, true)
      XCTAssertEqual(defaultEndpoint.allowsExpensiveNetworkAccess, true)
      XCTAssertEqual(defaultEndpoint.allowsConstrainedNetworkAccess, true)
      XCTAssertEqual(defaultEndpoint.cachePolicy, .useProtocolCachePolicy)
      XCTAssertEqual(defaultEndpoint.request(), URLRequest(endpoint: defaultEndpoint))
      XCTAssertEqual(defaultEndpoint.url(), MockEndpointDefaultConfiguration.validationUrl)
   }

   func test_CustomEndpoint_ReturnsCorrectValues() {
      // Given
      let customEndpoint = MockEndpointCustomConfiguration()

      // Then

      XCTAssertEqual(customEndpoint.scheme, "http")
      XCTAssertEqual(customEndpoint.httpMethod, .post)
      XCTAssertEqual(customEndpoint.timeoutInterval, 30.0)
      XCTAssertEqual(customEndpoint.path, "/weather/local")
      XCTAssertEqual(customEndpoint.host, "www.testing.com")
      XCTAssertEqual(customEndpoint.validStatusCodes, [200])
      XCTAssertEqual(customEndpoint.allowsCellularAccess, true)
      XCTAssertEqual(customEndpoint.allowsExpensiveNetworkAccess, false)
      XCTAssertEqual(customEndpoint.allowsConstrainedNetworkAccess, false)
      XCTAssertEqual(customEndpoint.cachePolicy, .returnCacheDataElseLoad)
      XCTAssertEqual(customEndpoint.request(), URLRequest(endpoint: customEndpoint))
      XCTAssertEqual(customEndpoint.url(), MockEndpointCustomConfiguration.validationUrl)
      XCTAssertEqual(customEndpoint.httpHeaderFields, ["Content-Type": "application/json"])
      XCTAssertEqual(customEndpoint.queryItems, [URLQueryItem(name: "city", value: "76102")])
      XCTAssertEqual(customEndpoint.httpBody, MockEndpointCustomConfiguration.validationBody)
   }
}

// MARK: - Mock Test Data

fileprivate struct MockEndpointDefaultConfiguration: Endpoint {
   static var validationUrl: URL {
      URL(string: "https://www.testing.com/testing/unit")!
   }

   var host: String {
      "www.testing.com"
   }

   var path: String {
      "/testing/unit"
   }
}

fileprivate struct MockEndpointCustomConfiguration: Endpoint {
   static var validationUrl: URL {
      URL(string: "http://www.testing.com/weather/local?city=76102")!
   }

   static var validationBody: Data {
      "d04yghfck[wd0g0uhtbouht8u9i40o3plembhuouifo348hrbinvbohgu4ifenc".data(using: .utf8)!
   }

   var scheme: String {
      "http"
   }
   
   var host: String {
      "www.testing.com"
   }
   
   var path: String {
      "/weather/local"
   }
   
   var queryItems: [URLQueryItem]? {
      [URLQueryItem(name: "city", value: "76102")]
   }
   
   var httpMethod: HTTPMethod {
      .post
   }
   
   var httpHeaderFields: [String : String]? {
      ["Content-Type": "application/json"]
   }
   
   var httpBody: Data? {
      "d04yghfck[wd0g0uhtbouht8u9i40o3plembhuouifo348hrbinvbohgu4ifenc".data(using: .utf8)
   }
   
   var cachePolicy: CachePolicy {
      .returnCacheDataElseLoad
   }

   var validStatusCodes: [Int] {
      [200]
   }
   
   var timeoutInterval: TimeInterval {
      30.0
   }
   
   var allowsCellularAccess: Bool {
      true
   }
   
   var allowsExpensiveNetworkAccess: Bool {
      false
   }
   
   var allowsConstrainedNetworkAccess: Bool {
      false
   }
}
