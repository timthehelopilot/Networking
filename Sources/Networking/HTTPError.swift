//
//  HTTPError.swift
//  
//
//  Created by Timothy Barrett on 1/23/21.
//

import Foundation

/// Describes errors in the HTTP error domain.
public enum HTTPError: Error {
   case logInRequired
   case nonHTTPResponse
   case networkError(URLError)
   case decodingError(DecodingError)
   case unacceptableStatusCode(statusCode: Int, data: Data)

   /// Given the error will determine if the request should be retried.
   public var shouldRetry: Bool {
      switch self {
      case .decodingError, .logInRequired:
         return false

      case let .unacceptableStatusCode(statusCode, _):
         let timeoutStatus = 408
         let rateLimitStatus = 429

         return [timeoutStatus, rateLimitStatus].contains(statusCode)

      case .networkError, .nonHTTPResponse:
         return true
      }
   }
}

// MARK: - Equatable Conformance // check if it all works correctly

extension HTTPError: Equatable {
   public static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
      switch (lhs, rhs) {
      case (let .networkError(lhsError), let .networkError(rhsError)):
         return lhsError == rhsError

      case (let .decodingError(lhsError), let .decodingError(rhsError)):
         return lhsError.localizedDescription == rhsError.localizedDescription

      case (let .unacceptableStatusCode(lhsCode, lhsData),
            let .unacceptableStatusCode(rhsCode, rhsData)):
         return lhsCode == rhsCode && lhsData == rhsData

      case (logInRequired, logInRequired):
         return true

      case (nonHTTPResponse, nonHTTPResponse):
         return true

      default:
         return false
      }
   }
}
