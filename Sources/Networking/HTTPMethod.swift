//
//  HTTPMethod.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//


import Foundation

/// A set of request method cases to indicate the desired action to be performed for a given endpoint.
public enum HTTPMethod: String {
   case get = "GET"
   case post = "POST"
   case put = "PUT"
   case delete = "DELETE"
   case connect = "CONNECT"
   case options = "OPTIONS"
   case trace = "TRACE"
   case patch = "PATCH"
}

// MARK: - CustomStringConvertible Conformance

extension HTTPMethod: CustomStringConvertible {

   /// A textual representation of this instance.
   public var description: String {
      rawValue
   }
}
