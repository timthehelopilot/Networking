//
//  APIEndpoint.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

public protocol APIEndpoint {
   var scheme: String { get }
   var host: String { get }
   var path: String { get }
   var queryItems: [URLQueryItem]? { get }
   var httpMethod: HTTPMethod { get }
   var httpHeaderFields: [String: String]? { get }
   var httpBody: Data? { get }
   var cachePolicy: URLRequest.CachePolicy { get }
   var timeoutInterval: TimeInterval { get }
   var allowsCellularAccess: Bool { get }
   var allowsExpensiveNetworkAccess: Bool { get }
   var allowsConstrainedNetworkAccess: Bool { get }
   var request: URLRequest { get }
   var url: URL { get }
}

public extension APIEndpoint {
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
   
   var cachePolicy: URLRequest.CachePolicy {
      .useProtocolCachePolicy
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
   
   var request: URLRequest {
      URLRequest(endpoint: self)
   }
}
