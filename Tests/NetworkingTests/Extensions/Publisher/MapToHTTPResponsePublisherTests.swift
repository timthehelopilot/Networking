//
//  MapToHTTPResponsePublisherTests.swift
//  
//
//  Created by Timothy Barrett on 1/25/21.
//

import Combine
import XCTest
@testable import Networking

final class MapToHTTPResponsePublisherTests: BasePublisherTestCase {
   private typealias DataTaskResponse = URLSession.DataTaskResponse
   private typealias DataTaskHTTPResponse = URLSession.DataTaskHTTPResponse

   // MARK: - Unit Tests

   func test_MapToHTTPResponsePublisher_EmitsResponseObject() {
      // Given
      let subject = PassthroughSubject<DataTaskResponse, URLError>()
      let urlResponse = HTTPURLResponse(url: URL(string: "www.testing.com")!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)!
      let dataTaskResponse: DataTaskResponse = (data: Data(), response: urlResponse)
      var completion: Subscribers.Completion<HTTPError>?
      var result: DataTaskHTTPResponse?

      subject
         .mapToHTTPResponse()
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // When
      subject.send(dataTaskResponse)
      subject.send(completion: .finished)

      // Then
      XCTAssertNotNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .finished)
      XCTAssertEqual(result?.data, dataTaskResponse.data)
      XCTAssertEqual(result?.response, dataTaskResponse.response)
   }

   func test_MapToHTTPResponsePublisher_EmitsNonHTTPResponseError() {
      // Given
      let subject = PassthroughSubject<DataTaskResponse, URLError>()
      let urlResponse = URLResponse(url: URL(string: "www.testing.com")!,
                                    mimeType: nil,
                                    expectedContentLength: 24,
                                    textEncodingName: nil)
      let dataTaskResponse: DataTaskResponse = (data: Data(), response: urlResponse)
      var completion: Subscribers.Completion<HTTPError>?
      var result: DataTaskHTTPResponse?

      subject
         .mapToHTTPResponse()
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // When
      subject.send(dataTaskResponse)

      // Then
      XCTAssertNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .failure(HTTPError.nonHTTPResponse))
   }

   func test_MapToHTTPResponsePublisher_EmitsNetworkError() {
      // Given
      let subject = PassthroughSubject<DataTaskResponse, URLError>()
      let error = URLError(.notConnectedToInternet)
      var completion: Subscribers.Completion<HTTPError>?
      var result: DataTaskResponse?

      subject
         .mapToHTTPResponse()
         .sink(receiveCompletion: { completion = $0 },
               receiveValue: { result = $0 })
         .store(in: &cancelables)

      // When
      subject.send(completion: .failure(error))

      // Then
      XCTAssertNil(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(completion, .failure(HTTPError.networkError(error)))
   }
}
