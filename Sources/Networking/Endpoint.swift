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

   /// Returns the timeout interval of the receiver.
   var timeoutInterval: TimeInterval { get }

   /// `true` if the receiver is allowed to use the built in cellular radios to satisfy the request, `false` otherwise.
   var allowsCellularAccess: Bool { get }

   /// `true` if the receiver is allowed to use an interface marked as expensive to satisfy the request, `false` otherwise.
   var allowsExpensiveNetworkAccess: Bool { get }

   /// `true` if the receiver is allowed to use an interface marked as constrained to satisfy the request, `false` otherwise.
   var allowsConstrainedNetworkAccess: Bool { get }

   /// A `URL` load request that is independent of protocol or `URL` scheme.
   var request: URLRequest { get }

   /// The URL of the receiver.
   var url: URL { get }
}

// MARK: - Endpoint Common Values

public extension Endpoint {

   /// The scheme subcomponent of the URL. Default value: `https`.
   var scheme: String {
      "https"
   }

   /// An array of `URLQueryItems`. Will be appended in the order they are listed in the `Array`. Default value: `nil`.
   var queryItems: [URLQueryItem]? {
      nil
   }

   /// The HTTP request method of the receiver. Default value: GET
   var httpMethod: HTTPMethod {
      .get
   }

   /// A dictionary containing all the HTTP header fields of the receiver. Default value: `nil`.
   var httpHeaderFields: [String: String]? {
      nil
   }

   /// This data is sent as the message body of the request, as in done in an HTTP POST request. Default value: `nil`.
   var httpBody: Data? {
      nil
   }

   /// The cache policy of the receiver. Default value: `.useProtocolCachePolicy`.
   var cachePolicy: CachePolicy {
      .useProtocolCachePolicy
   }

   /// Returns the timeout interval of the receiver. Default value: 60 seconds.
   var timeoutInterval: TimeInterval {
      60.0
   }

   /// `true` if the receiver is allowed to use the built in cellular radios to satisfy the request, `false` otherwise.
   /// Default value: `true`
   var allowsCellularAccess: Bool {
      true
   }

   /// `true` if the receiver is allowed to use an interface marked as expensive to satisfy the request, `false` otherwise.
   /// Default value: `true`
   var allowsExpensiveNetworkAccess: Bool {
      true
   }

   /// `true` if the receiver is allowed to use an interface marked as constrained to satisfy the request, `false` otherwise.
   /// Default value: `true`
   var allowsConstrainedNetworkAccess: Bool {
      true
   }

   /// Returns a `URL` created from the `Endpoint` instance.
   var url: URL {
      var components = URLComponents()

      components.scheme = scheme
      components.host = host
      components.path = path
      components.queryItems = queryItems

      guard let url = components.url else {
         preconditionFailure("Invalid URL components: \(components)")
      }

      return url
   }

   /// A URL load request that is independent of protocol or URL scheme. Created from the `Endpoint` instance.
   var request: URLRequest {
      URLRequest(endpoint: self)
   }
}
