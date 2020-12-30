//
//  URLSessionTests.swift
//  
//
//  Created by Timothy Barrett on 12/30/20.
//

import XCTest
@testable import Networking

final class URLSessionTests: XCTestCase {
   func test_URLSessionEndpointPublisherMethod_ReturnsValidPublisher() {
      // Given
      let endpoint = MockEndpoint()
      let publisher = URLSession.shared.dataTaskPublisher(for: endpoint)

      // Then
      XCTAssertEqual(publisher.request, endpoint.request)
   }
}

// MARK: - Mock Data

fileprivate struct MockEndpoint: Endpoint {
   var host: String {
      "www.testing.com"
   }

   var path: String {
      "/weather"
   }
}
