//
//  AuthenticatorTests.swift
//  
//
//  Created by Timothy Barrett on 1/24/21.
//

import XCTest
import Combine
@testable import Networking

final class AuthenticatorTests: BasePublisherTestCase {
   typealias KeychainConfiguration = Authenticator.KeychainConfiguration

   // MARK: Properties

   var authenticator: Authenticator!
   var testKeychainConfiguration: KeychainConfiguration {
      KeychainConfiguration(service: "testService",
                            account: "testAccount",
                            accessGroup: "testGroup")
   }
   var failureData: Data {
      """
      {
         "error": "invalid_request",
         "error_description": "Request was missing the 'redirect_uri' parameter.",
         "error_uri": "See the full API docs at https://authorization-server.com/token"
      }
      """.data(using: .utf8)!
   }

   override func setUp() {
      super.setUp()

      authenticator = Authenticator(session: MockSession(),
                                    keychain: testKeychainConfiguration)
   }

   override func tearDown() {
      authenticator
         .clearOAuthState()
         .sink(receiveCompletion: { _ in
            self.authenticator = nil
            super.tearDown()
         }, receiveValue: { })
         .store(in: &cancelables)
   }

   // MARK: Unit Tests

   func test_OAuthState_ReturnsHTTPErrorLoginRequired() {
      // Given
      let endpoint = SuccessEndpoint()
      let publisher = authenticator.validOAuthState(endpoint: endpoint)
      var result: OAuthState?
      var completion: Subscribers.Completion<HTTPError>?

      // When
      publisher
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // Then
      XCTAssertNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .failure(HTTPError.logInRequired))
   }

   func test_OAuthSate_ReturnsValidOAuthState() {
      // Given
      let endpoint = SuccessEndpoint()
      let publisher = authenticator.validOAuthState(endpoint: endpoint, initialRequest: true)
      var result: OAuthState?
      var completion: Subscribers.Completion<HTTPError>?

      // When
      publisher
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // Then
      XCTAssertNotNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .finished)
      XCTAssertEqual(result?.isValid, true)
      XCTAssertEqual(result?.accessToken, "2YotnFZFEjr341zCsicMWpAA")
      XCTAssertEqual(result?.refreshToken, "0atGzv3JOkF024XG5Qx2TlKWIA")
   }

   func test_OAuthState_ReturnsAlreadyFetchedOAuthState() {
      // Given
      let endpoint = SuccessEndpoint()
      let publisher = authenticator.validOAuthState(endpoint: endpoint, initialRequest: true)
      var result: OAuthState?
      var completion: Subscribers.Completion<HTTPError>?

      // When
      publisher
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      let secondPublisher = authenticator.validOAuthState(endpoint: endpoint)
      var secondResult: OAuthState?
      var secondCompletion: Subscribers.Completion<HTTPError>?

      secondPublisher
         .sink(receiveCompletion: { secondCompletion = $0 },
               receiveValue: { secondResult = $0 })
         .store(in: &cancelables)

      // Then
      XCTAssertNotNil(result)
      XCTAssertNotNil(secondResult)
      XCTAssertNotNil(completion)
      XCTAssertNotNil(secondCompletion)
      XCTAssertEqual(result, secondResult)
      XCTAssertEqual(completion, .finished)
      XCTAssertEqual(secondCompletion, .finished)
   }

   func test_OAuthState_ReturnsHTTPUnacceptableStatus() {
      // Given
      let endpoint = FailureEndpoint()
      let publisher = authenticator.validOAuthState(endpoint: endpoint, initialRequest: true)
      var result: OAuthState?
      var completion: Subscribers.Completion<HTTPError>?

      // When
      publisher
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // Then
      XCTAssertNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion,
                     .failure(HTTPError.unacceptableStatusCode(statusCode: 401,
                                                               data: failureData)))
   }

   func test_OAuthState_ReturnsSamePublisherForMultipleRequests() {
      // Given
      let publisherExpectation = expectation(description: "Testing Delay")
      let authenticator = Authenticator(session: MockDelaySession(),
                                        keychain: testKeychainConfiguration)
      let endpoint = SuccessEndpoint()
      let publisher = authenticator.validOAuthState(endpoint: endpoint, initialRequest: true)
      let secondPublisher = authenticator.validOAuthState(endpoint: endpoint)
      var result: OAuthState?
      var secondResult: OAuthState?
      var completion: Subscribers.Completion<HTTPError>?
      var secondCompletion: Subscribers.Completion<HTTPError>?

      // When
      publisher
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      secondPublisher
         .sink(receiveCompletion: { completion in
            secondCompletion = completion
            publisherExpectation.fulfill()
         },
         receiveValue: { secondResult = $0 })
         .store(in: &cancelables)

      waitForExpectations(timeout: 3, handler: nil)

      // Then
      XCTAssertNotNil(result)
      XCTAssertNotNil(secondResult)
      XCTAssertNotNil(completion)
      XCTAssertNotNil(secondCompletion)
      XCTAssertEqual(completion, .finished)
      XCTAssertEqual(secondCompletion, .finished)
      XCTAssertEqual(result?.isValid, secondResult?.isValid)
      XCTAssertEqual(result?.accessToken, secondResult?.accessToken)
      XCTAssertEqual(result?.refreshToken, secondResult?.refreshToken)
   }
}

// MARK: - MockSession

fileprivate class MockSession: OAuthSession {
   func dataTaskPublisher(for endpoint: Endpoint,
                          refreshToken: String?)
                          -> AnyPublisher<(data: Data, response: URLResponse), URLError> {

      let statusCode: Int
      let data: Data

      if endpoint is SuccessEndpoint {
         statusCode = 200
         data = """
         {
            "access_token":"2YotnFZFEjr341zCsicMWpAA",
            "expires_in":10800,
            "refresh_token":"0atGzv3JOkF024XG5Qx2TlKWIA",
         }
         """.data(using: .utf8)!
      } else {
         statusCode = 401
         data = """
         {
            "error": "invalid_request",
            "error_description": "Request was missing the 'redirect_uri' parameter.",
            "error_uri": "See the full API docs at https://authorization-server.com/token"
         }
         """.data(using: .utf8)!
      }

      let response = HTTPURLResponse(url: endpoint.url(refreshToken: refreshToken),
                                     statusCode: statusCode,
                                     httpVersion: nil,
                                     headerFields: nil)!

      return Deferred {
         Future { promise in
            promise(.success((data: data, response: response)))
         }
      }
      .eraseToAnyPublisher()
   }
}

fileprivate class MockDelaySession: OAuthSession {
   func dataTaskPublisher(for endpoint: Endpoint,
                          refreshToken: String?)
                           -> AnyPublisher<(data: Data, response: URLResponse), URLError> {

      let statusCode: Int
      let data: Data

      if endpoint is SuccessEndpoint {
         statusCode = 200
         data = """
         {
            "access_token":"2YotnFZFEjr341zCsicMWpAA",
            "expires_in":10800,
            "refresh_token":"0atGzv3JOkF024XG5Qx2TlKWIA",
         }
         """.data(using: .utf8)!
      } else {
         statusCode = 401
         data = """
         {
            "error": "invalid_request",
            "error_description": "Request was missing the 'redirect_uri' parameter.",
            "error_uri": "See the full API docs at https://authorization-server.com/token"
         }
         """.data(using: .utf8)!
      }

      let response = HTTPURLResponse(url: endpoint.url(refreshToken: refreshToken),
                                     statusCode: statusCode,
                                     httpVersion: nil,
                                     headerFields: nil)!

      return Deferred {
         Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               promise(.success((data: data, response: response)))
            }
         }
      }
      .eraseToAnyPublisher()
   }
}

// MARK: - Test Endpoints

fileprivate struct FailureEndpoint: Endpoint {
   var host: String {
      "www.testing.com"
   }

   var path: String {
      "/failure"
   }
}

fileprivate struct SuccessEndpoint: Endpoint {
   var host: String {
      "www.testing.com"
   }

   var path: String {
      "/success"
   }
}
