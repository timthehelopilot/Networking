//
//  URLSession+EndpointDataTaskPublisher.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

public extension URLSession {
   func dataTaskPublisher(for endpoint: APIEndpoint) -> DataTaskPublisher {
      dataTaskPublisher(for: endpoint.request)
   }
}
