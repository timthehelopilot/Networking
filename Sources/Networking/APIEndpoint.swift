//
//  APIEndpoint.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

public protocol APIEndpoint {

   /// The scheme subcomponent of the URL.
   var scheme: String { get }

   /// 
   var host: String { get }

   /// 
   var path: String { get }

   /// 
   var queryItems: [URLQueryItem]? { get }

   /// 
   var httpMethod: HTTPMethod { get }

   /// 
   var httpHeaderFields: [String: String]? { get }

   /// 
   var httpBody: Data? { get }

   /// 
   var cachePolicy: URLRequest.CachePolicy { get }

   /// 
   var timeoutInterval: TimeInterval { get }

   /// 
   var allowsCellularAccess: Bool { get }

   /// 
   var allowsExpensiveNetworkAccess: Bool { get }

   /// 
   var allowsConstrainedNetworkAccess: Bool { get }

   /// A URL load request that is independent of protocol or URL scheme.
   var request: URLRequest { get }

   /// 
   var url: URL { get }
}

public extension APIEndpoint {
   typealias CachePolicy = URLRequest.CachePolicy

   /// The scheme subcomponent of the URL. Sets this subcomponent to the default value of: `https`
   var scheme: String {
      "https"
   }

   ///
   var queryItems: [URLQueryItem]? {
      nil
   }

   ///
   var httpMethod: HTTPMethod {
      .get
   }

   ///
   var httpHeaderFields: [String: String]? {
      nil
   }

   ///
   var httpBody: Data? {
      nil
   }

   ///
   var cachePolicy: CachePolicy {
      .useProtocolCachePolicy
   }

   ///
   var timeoutInterval: TimeInterval {
      60.0
   }

   ///
   var allowsCellularAccess: Bool {
      true
   }

   ///
   var allowsExpensiveNetworkAccess: Bool {
      true
   }

   ///
   var allowsConstrainedNetworkAccess: Bool {
      true
   }

   /// Returns a `URL` created from the `APIEndpoint` properties.
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

   /// A URL load request that is independent of protocol or URL scheme.
   var request: URLRequest {
      URLRequest(endpoint: self)
   }
}
