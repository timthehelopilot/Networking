//
//  OAuthState.swift
//
//
//  Created by Timothy Barrett on 1/4/21.
//

import Foundation

/// Used for storing the credentials to access all Netatmo endpoints.
public struct OAuthState {

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
}

// MARK: - Equatable Conformance

extension OAuthState: Equatable { }

// MARK: - Hashable Conformance

extension OAuthState: Hashable { }

// MARK: - Codable Conformance

extension OAuthState: Codable {
   private enum CodingKeys: String, CodingKey {
      case accessToken = "access_token"
      case refreshToken = "refresh_token"
      case expirationDate = "expires_in"
   }
}

// MARK: - Comparable Conformance

extension OAuthState: Comparable {
   public static func < (lhs: OAuthState, rhs: OAuthState) -> Bool {
      lhs.accessToken < rhs.accessToken &&
      lhs.refreshToken < rhs.refreshToken &&
      lhs.expirationDate < rhs.expirationDate
   }
}

// MARK: - CustomStringConvertible Conformance

extension OAuthState: CustomStringConvertible {
   public var description: String {
      """
      AccessToken: \(accessToken),
      RefreshToken: \(refreshToken),
      ExpirationDate: \(expirationDate)
      """
   }
}
