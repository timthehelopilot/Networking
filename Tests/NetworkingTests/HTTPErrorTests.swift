//
//  HTTPErrorTests.swift
//  
//
//  Created by Timothy Barrett on 1/24/21.
//

import XCTest
@testable import Networking

final class HTTPErrorTests: XCTestCase {

   func test_LogInRequired_ShouldRetryReturnsFalse() {
      // Given
      let loginRequired: HTTPError = .logInRequired

      // Then
      XCTAssertEqual(loginRequired.shouldRetry, false)
   }

   func test_NonHTTPResponse_ShouldRetryReturnsTrue() {
      // Given
      let nonHTTPResponse: HTTPError = .nonHTTPResponse

      // Then
      XCTAssertEqual(nonHTTPResponse.shouldRetry, true)
   }

   func test_NetworkError_ShouldRetryReturnsTrue() {
      // Given
      let networkError: HTTPError = .networkError(URLError(.cancelled))

      // Then
      XCTAssertEqual(networkError.shouldRetry, true)
   }

   func test_DecodingError_ShouldRetryReturnsFalse() {
      // Given
      let decodingContext = DecodingError.Context(codingPath: [CodingKey](), debugDescription: "")
      let decodingErrorContext = DecodingError.valueNotFound(String.self, decodingContext)
      let decodingError: HTTPError = .decodingError(decodingErrorContext)

      // Then
      XCTAssertEqual(decodingError.shouldRetry, false)
   }

   func test_UnacceptableStatusCode408_ShouldRetryReturnsTrue() {
      // Given
      let timeoutError: HTTPError = .unacceptableStatusCode(statusCode: 408, data: Data())

      // Then
      XCTAssertEqual(timeoutError.shouldRetry, true)
   }

   func test_unacceptableStatusCode429_ShouldRetryReturnsTrue() {
      // Given
      let rateLimitError: HTTPError = .unacceptableStatusCode(statusCode: 429, data: Data())

      // Then
      XCTAssertEqual(rateLimitError.shouldRetry, true)
   }

   func test_unacceptableStatusCode401_ShouldRetryReturnsFalse() {
      // Given
      let unauthorizedError: HTTPError = .unacceptableStatusCode(statusCode: 401, data: Data())

      // Then
      XCTAssertEqual(unauthorizedError.shouldRetry, false)
   }
}
