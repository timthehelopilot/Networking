//
//  OAuthSession.swift
//  
//
//  Created by Timothy Barrett on 1/10/21.
//

import Combine
import Foundation

public protocol OAuthSession: AnyObject {
   /// Creates an `AnyPublisher<(data: Data, response: URLResponse), URLError>` from an `Endpoint`
   /// - Parameter endpoint: Accepts any object that conforms to the `Endpoint` protocol.
   /// - Returns: `AnyPublisher<(data: Data, response: URLResponse), URLError>`
   func dataTaskPublisher(for endpoint: Endpoint)
                          -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}
