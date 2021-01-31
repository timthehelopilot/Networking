//
//  ResponseDataPublisherTests.swift
//  
//
//  Created by Timothy Barrett on 1/25/21.
//

import Combine
import XCTest
@testable import Networking

final class ResponseDataPublisherTests: BasePublisherTestCase {
   private typealias DataTaskResponse = URLSession.DataTaskHTTPResponse

   // MARK: Unit Tests

   func test_ResponseDataPublisher_EmitsResponseForValidStatusCodes() {
      // Given
      let subject = PassthroughSubject<DataTaskResponse, HTTPError>()
      let response = HTTPURLResponse(url: URL(string: "www.testing.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)!
      let dataResponse: DataTaskResponse = (data: Data(), response: response)
      var completion: Subscribers.Completion<HTTPError>?
      var result: Data?

      subject
         .responseData(validStatusCodes: [200])
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // When
      subject.send(dataResponse)
      subject.send(completion: .finished)

      // Then
      XCTAssertNotNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .finished)
      XCTAssertEqual(result, dataResponse.data)
   }

   func test_ResponseDataPublisher_EmitsHTTPErrorForInvalidStatusCodes() {
      // Given
      let error: HTTPError = .unacceptableStatusCode(statusCode: 401, data: Data())
      let subject = PassthroughSubject<DataTaskResponse, HTTPError>()
      let response = HTTPURLResponse(url: URL(string: "www.testing.com")!,
                                     statusCode: 401,
                                     httpVersion: nil,
                                     headerFields: nil)!
      let dataResponse: DataTaskResponse = (data: Data(), response: response)
      var completion: Subscribers.Completion<HTTPError>?
      var result: Data?

      subject
         .responseData(validStatusCodes: [201])
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // When
      subject.send(dataResponse)

      // Then
      XCTAssertNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .failure(error))
   }
}
