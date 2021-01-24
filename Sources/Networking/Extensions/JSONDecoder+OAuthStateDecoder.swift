//
//  JSONDecoder+OAuthStateDecoder.swift
//  
//
//  Created by Timothy Barrett on 1/9/21.
//

import Foundation

public extension JSONDecoder {
   /// A JSONDecoder that has a custom date decoding strategy. Turns expiration in seconds into a future expiration `Date`.
   static var oAuthStateJSONDecoder: JSONDecoder {
      let decoder = JSONDecoder()

      decoder.dateDecodingStrategy = .custom({ decoder -> Date in
         let container = try decoder.singleValueContainer()
         let secondsUntilExpiration = try container.decode(Int.self)

         return Date(timeIntervalSinceNow: TimeInterval(secondsUntilExpiration))
      })

      return decoder
   }
}
