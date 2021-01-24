//
//  URLSession+EndpointDataTaskPublisher.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//

import Combine
import Foundation

extension URLSession: OAuthSession {
   public typealias DataTaskHTTPResponse = (data: Data, response: HTTPURLResponse)
   public typealias DataTaskResponse = (data: Data, response: URLResponse)

   public func dataTaskPublisher(for endpoint: Endpoint)
                                 -> AnyPublisher<DataTaskResponse, URLError> {

      dataTaskPublisher(for: endpoint.request)
         .eraseToAnyPublisher()
   }
}
