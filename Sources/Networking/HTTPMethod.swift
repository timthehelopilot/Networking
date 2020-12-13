//
//  HTTPMethod.swift
//  
//
//  Created by Timothy Barrett on 12/12/20.
//


import Foundation

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

extension HTTPMethod: CustomStringConvertible {
   public var description: String {
      rawValue
   }
}
