//
//  Endpoint.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

/// This creates an instance of all the items needed to send info to an API.
public protocol Endpoint {
   typealias CachePolicy = URLRequest.CachePolicy

   /// The scheme subcomponent of the `URL`.
   var scheme: String { get }

   /// The host subcomponent.
   var host: String { get }

   /// The path subcomponent.
   var path: String { get }

   /// An array of `URLQueryItems`. Will be appended in the order they are listed in the `Array`.
   var queryItems: [URLQueryItem]? { get }

   /// The HTTP request method of the receiver.
   var httpMethod: HTTPMethod { get }

   /// A dictionary containing all the HTTP header fields of the receiver.
   var httpHeaderFields: [String: String]? { get }

   /// This data is sent as the message body of the request, as in done in an HTTP POST request.
   var httpBody: Data? { get }

   /// The cache policy of the receiver.
   var cachePolicy: CachePolicy { get }

   /// Status codes to indicate whether a specific HTTP request has been successfully completed
   var validStatusCodes: [Int] { get }

   /// Returns the timeout interval of the receiver.
   var timeoutInterval: TimeInterval { get }

   /// `true` if the receiver is allowed to use the built in cellular radios to satisfy the request, `false` otherwise.
   var allowsCellularAccess: Bool { get }

   /// `true` if the receiver is allowed to use an interface marked as expensive to satisfy the request, `false` otherwise.
   var allowsExpensiveNetworkAccess: Bool { get }

   /// `true` if the receiver is allowed to use an interface marked as constrained to satisfy the request, `false` otherwise.
   var allowsConstrainedNetworkAccess: Bool { get }

   /// The URL of the receiver.
   /// - Parameter refreshToken: This is the OAuth token for the given `Endpoint`
   func url(refreshToken: String?) -> URL

   /// A `URL` load request that is independent of protocol or `URL` scheme.
   /// - Parameter refreshToken: This is the OAuth token for the given `Endpoint`
   func request(refreshToken: String?) -> URLRequest
}

// MARK: - Endpoint Default Property Implementations

public extension Endpoint {

   var scheme: String {
      "https"
   }

   var queryItems: [URLQueryItem]? {
      nil
   }

   var httpMethod: HTTPMethod {
      .get
   }

   var httpHeaderFields: [String: String]? {
      nil
   }

   var httpBody: Data? {
      nil
   }

   var cachePolicy: CachePolicy {
      .useProtocolCachePolicy
   }

   var validStatusCodes: [Int] {
      Array(200...299)
   }

   var timeoutInterval: TimeInterval {
      60.0
   }

   var allowsCellularAccess: Bool {
      true
   }

   var allowsExpensiveNetworkAccess: Bool {
      true
   }

   var allowsConstrainedNetworkAccess: Bool {
      true
   }

   func url(refreshToken: String? = nil) -> URL {
      var components = URLComponents()

      if let refreshToken = refreshToken {
         var queryItems = [URLQueryItem(name: "refresh_token", value: refreshToken)]

         queryItems.append(contentsOf: self.queryItems ?? [])

         components.queryItems = queryItems
      } else {
         components.queryItems = queryItems
      }

      components.scheme = scheme
      components.host = host
      components.path = path

      guard let url = components.url else {
         preconditionFailure("Invalid URL components: \(components)")
      }

      return url
   }

   func request(refreshToken: String? = nil) -> URLRequest {
      URLRequest(endpoint: self, refreshToken: refreshToken)
   }
}
