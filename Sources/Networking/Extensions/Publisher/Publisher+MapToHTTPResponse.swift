//
//  Publisher+MapToHTTPResponse.swift
//  
//
//  Created by Timothy Barrett on 1/23/21.
//

import Combine
import Foundation

public extension Publisher where Output == URLSession.DataTaskResponse, Failure == URLError {

   /// Takes the output from upstream and maps the result to a `HTTPURLResponse`
   /// - Returns: A publisher that maps the `URLResponse` to a `HTTPURLResponse` and publishes the result.
   func mapToHTTPResponse() -> AnyPublisher<URLSession.DataTaskHTTPResponse, HTTPError> {
      tryMap { (data, response) in
         guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.nonHTTPResponse
         }

         return (data, httpResponse)
      }
      .mapError { error in
         if let error = error as? HTTPError {
            return error
         } else {
            return HTTPError.networkError(error as! URLError)
         }
      }
      .eraseToAnyPublisher()
   }
}
