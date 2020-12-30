//
//  URLRequest+Init-Endpoint.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

public extension URLRequest {
   /// Creates an Instance of an `URLRequest` from any `Endpoint` passed in
   /// - Parameter endpoint: Accepts any object that conforms to the `Endpoint` protocol.
   init(endpoint: Endpoint) {
      self.init(url: endpoint.url,
                cachePolicy:endpoint.cachePolicy,
                timeoutInterval: endpoint.timeoutInterval)

      self.allowsConstrainedNetworkAccess = endpoint.allowsConstrainedNetworkAccess
      self.allowsExpensiveNetworkAccess = endpoint.allowsExpensiveNetworkAccess
      self.allowsCellularAccess = endpoint.allowsCellularAccess
      self.allHTTPHeaderFields = endpoint.httpHeaderFields
      self.httpMethod = endpoint.httpMethod.rawValue
      self.httpBody = endpoint.httpBody
   }
}
