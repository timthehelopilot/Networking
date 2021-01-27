//
//  DecodingPublisherTests.swift
//  
//
//  Created by Timothy Barrett on 1/25/21.
//

import Combine
import XCTest
@testable import Networking

final class DecodingPublisherTests: XCTestCase {

   var cancelables: Set<AnyCancellable> = []

   func test_DecodingPublisher_EmitsDecodedObject() throws {
      // Given
      let subject = PassthroughSubject<Data, HTTPError>()
      let state = OAuthState(accessToken: "test", refreshToken: "token", expirationDate: Date())
      let data = try JSONEncoder().encode(state)
      var completion: Subscribers.Completion<HTTPError>?
      var result: OAuthState?

      subject
         .decoding(type: OAuthState.self, decoder: JSONDecoder())
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)


      // When
      subject.send(data)
      subject.send(completion: .finished)

      // Then
      XCTAssertNotNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .finished)
      XCTAssertEqual(result, state)
   }

   func test_DecodingPublisher_EmitsHTTPError() {
      // Given
      let subject = PassthroughSubject<Data, HTTPError>()
      var completion: Subscribers.Completion<HTTPError>?
      var result: OAuthState?

      subject
         .decoding(type: OAuthState.self, decoder: JSONDecoder())
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // When
      subject.send(completion: .failure(HTTPError.logInRequired))

      // Then
      XCTAssertNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .failure(HTTPError.logInRequired))
   }

   func test_DecodingPublisher_EmitsDecoderError() throws {
      // Given
      let data = """
      {
         "access_token":"2YotnFZFEjr1zCsicMWpAA",
         "expires_in":10800,
      }
      """.data(using: .utf8)!
      let subject = PassthroughSubject<Data, HTTPError>()
      var completion: Subscribers.Completion<HTTPError>?
      var result: OAuthState?

      subject
         .decoding(type: OAuthState.self, decoder: JSONDecoder.oAuthStateJSONDecoder)
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)


      // When
      subject.send(data)

      // Then
      XCTAssertNil(result)
      XCTAssertNotNil(completion)
   }
}
