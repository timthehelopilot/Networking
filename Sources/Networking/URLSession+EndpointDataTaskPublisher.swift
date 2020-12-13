//
//  URLSession+EndpointDataTaskPublisher.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Foundation

public extension URLSession {
   func dataTaskPublisher(for endpoint: APIEndpoint) ->  URLSession.DataTaskPublisher {
      dataTaskPublisher(for: endpoint.request)
   }
}
