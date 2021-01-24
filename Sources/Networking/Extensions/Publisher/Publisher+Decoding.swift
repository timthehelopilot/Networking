//
//  Publisher+Decoding.swift
//  
//
//  Created by Timothy Barrett on 1/23/21.
//

import Combine
import Foundation

public extension Publisher where Output == Data, Failure == HTTPError {

   /// Decodes the output from  upstream  using a specified  type and decoder.
   /// - Parameters:
   ///   - type: The encoded data to decode into a struct that conforms to the `Decodable` protocol.
   ///   - decoder: A decoder that implements the `TopLevelDecoder` protocol.
   /// - Returns: A publisher that decodes a given type using a specified decoder and publishes the result.
   func decoding<Item, Coder>(type: Item.Type, decoder: Coder)
                              -> AnyPublisher<Item, HTTPError>
                              where Item: Decodable, Coder: TopLevelDecoder,
                                    Self.Output == Coder.Input {

      decode(type: type, decoder: decoder)
         .mapError { error in
            if let error = error as? DecodingError {
               return HTTPError.decodingError(error)
            } else {
               return error as! HTTPError
            }
         }
         .eraseToAnyPublisher()
   }
}
