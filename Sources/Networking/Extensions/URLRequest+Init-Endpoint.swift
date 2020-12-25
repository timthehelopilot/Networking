//
//  URLRequest+Init-Endpoint.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

public extension URLRequest {
   init(endpoint: APIEndpoint) {
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
