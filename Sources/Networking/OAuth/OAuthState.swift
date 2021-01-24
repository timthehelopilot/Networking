//
//  OAuthState.swift
//
//
//  Created by Timothy Barrett on 1/4/21.
//

import Foundation

/// Used for storing the credentials to access all Netatmo endpoints.
public struct OAuthState: Codable {

   // MARK: - Properties

   /// The token for your user to access the Netatmo endpoints.
   public var accessToken: String

   /// The token needed to get a new access token once it expires.
   public var refreshToken: String

   /// The date when the access token will expire and need to be refreshed
   public var expirationDate: Date

   /// Returns if the access token is still valid for Netatmo endpoint calls.
   public var isValid: Bool {
      let currentDate = Date()

      return currentDate < expirationDate
   }

   private enum CodingKeys: String, CodingKey {
      case accessToken = "access_token"
      case refreshToken = "refresh_token"
      case expirationDate = "expires_in"
   }
}
