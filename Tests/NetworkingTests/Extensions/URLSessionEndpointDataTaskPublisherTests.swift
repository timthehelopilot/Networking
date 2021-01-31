//
//  URLSessionEndpointDataTaskPublisherTests.swift
//  
//
//  Created by Timothy Barrett on 1/30/21.
//

import Combine
import XCTest
@testable import Networking

final class URLSessionEndpointDataTaskPublisherTests: BasePublisherTestCase {

   // MARK: Unit Tests

   func test_URLSessionEndpointDataTaskPublisher_EmitsResponse() {
      // Given
      let publisherExpectation = expectation(description: "Publisher Finished")
      let endpoint = TestEndpoint()
      let post = TestPost(id: 1,
                          userId: 1,
                          title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                          body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
      let publisher = URLSession.shared.dataTaskPublisher(for: endpoint)
      var completion: Subscribers.Completion<HTTPError>?
      var result: TestPost?

      // When
      publisher
         .mapToHTTPResponse()
         .responseData(validStatusCodes: [200])
         .decoding(type: TestPost.self, decoder: JSONDecoder())
         .sink(receiveCompletion:{ comp in
            completion = comp
            publisherExpectation.fulfill()
         },
         receiveValue: { result = $0 })
         .store(in: &cancelables)

      // Then
      waitForExpectations(timeout: 2, handler: nil)

      XCTAssertNotNil(result)
      dump(result)
      XCTAssertNotNil(completion)
      XCTAssertEqual(result, post)
      XCTAssertEqual(completion, .finished)
   }
}

// MARK: - Test Endpoint

fileprivate struct TestEndpoint: Endpoint {
   var host: String {
      "jsonplaceholder.typicode.com"
   }

   var path: String {
      "/posts/1"
   }
}

// MARK: - Test Post

fileprivate struct TestPost: Codable, Equatable {
   var id: Int
   var userId: Int
   var title: String
   var body: String
}
