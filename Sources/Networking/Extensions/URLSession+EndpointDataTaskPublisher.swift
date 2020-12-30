//
//  URLSession+EndpointDataTaskPublisher.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

public extension URLSession {
   /// Creates a Combine `DataTaskPublisher` from an `Endpoint`
   /// - Parameter endpoint: Accepts any object that conforms to the `Endpoint` protocol.
   /// - Returns: `DataTaskPublisher`
   func dataTaskPublisher(for endpoint: Endpoint) -> DataTaskPublisher {
      dataTaskPublisher(for: endpoint.request)
   }
}
