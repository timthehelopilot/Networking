//
//  Publisher+ResponseData.swift
//  
//
//  Created by Timothy Barrett on 1/23/21.
//

import Combine
import Foundation

public extension Publisher
                 where Output == URLSession.DataTaskHTTPResponse, Failure == HTTPError {

   /// Takes the output from upstream and validates the result with the given valid status codes
   /// - Parameter validStatusCodes: The codes accepted as valid for a given `HTTPURLResponse`.
   /// - Returns: A publisher that validates the given valid status codes  and publishes the result.
   func responseData(validStatusCodes: [Int]) -> AnyPublisher<Data, HTTPError> {
      tryMap { (data, response) in
         if validStatusCodes.contains(response.statusCode) {
            return data
         } else {
            let statusCode = response.statusCode

            throw HTTPError.unacceptableStatusCode(statusCode: statusCode, data: data)
         }
      }
      .mapError { $0 as! HTTPError }
      .eraseToAnyPublisher()
   }
}
