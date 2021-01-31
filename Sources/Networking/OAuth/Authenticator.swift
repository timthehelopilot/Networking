//
//  Authenticator.swift
//  
//
//  Created by Timothy Barrett on 1/12/21.
//

import Combine
import Foundation

/// A class that takes care of storing and retrieving an OAuth token for the given endpoint when initialized.
final public class Authenticator {

   // MARK: - Types

   /// A struct for the configuration of an item to save to keychain.
   public struct KeychainConfiguration {
      public var service: String
      public var account: String
      public var accessGroup: String?
   }

   // MARK: - Properties

   /// The queue that all methods for this class will run on. Prefixed with the Authenticator label.
   private let authenticationQueue = DispatchQueue(label: "Authenticator" + UUID().uuidString)

   /// An instance of `URLSession` that is used for OAuth requests in retrieving the token.
   private let session: OAuthSession

   /// The current state of the OAuth state. This will be nil if the user is not logged in.
   private var currentState: OAuthState?

   /// The publisher responsible for emitting the OAuth token if multiple token requests are initiated.
   private var refreshPublisher: AnyPublisher<OAuthState, HTTPError>?

   /// The configuration for saving the OAuthState to keychain
   private var keychain: KeychainConfiguration

   /// The password item used to save or retrieve the OAuthState for OAuth 2 requests.
   private var keychainOAuthItem: KeychainPasswordItem {
      KeychainPasswordItem(service: keychain.service,
                           account: keychain.account,
                           accessGroup: keychain.accessGroup)
   }

   // MARK: - Initialization

   /// Creates and Authenticator instance that manages the OAuth token and refreshes when needed.
   /// - Parameters:
   ///   - session: A configured `URLSession` instance used for all OAuth requests.
   ///   - keychainAccount: The keychain info on where to store the OAuth state.
   public init(session: OAuthSession, keychain: KeychainConfiguration) {
      self.session = session
      self.keychain = keychain
      self.currentState = loadOAuthState()
   }

   // MARK: - API

   /// TA publisher that will emit the current valid OAuth token is user is authenticated.
   /// - Parameters:
   ///   - endpoint: The endpoint to retrieve the required OAuth token.
   ///   - forceRefresh: Wether to force a refresh token call regardless of the current expiration date. Default is `false`.
   /// - Returns: A publisher that retrieves a OAuth token and publishes the result.
   public func validOAuthState(endpoint: Endpoint,
                               initialRequest: Bool = false,
                               forceRefresh: Bool = false)
                               -> AnyPublisher<OAuthState, HTTPError> {

      authenticationQueue.sync { [unowned self] in
         // Scenario 1: We are already in the process of refreshing the OAuthState so return
         // the existing refresh publisher
         if let refreshPublisher = refreshPublisher {
            return refreshPublisher
         }

         // Scenario 2: We don't have an OAuthState at all, The user is required to log in
         // or if initialRequest is true then continue to get an initial OAuth state.
         guard currentState != nil || initialRequest else {
            return Fail(error: HTTPError.logInRequired)
               .eraseToAnyPublisher()
         }

         // Scenario 3: We already have a valid OAuthState and don't want to force a refresh.
         if let currentState = currentState, currentState.isValid, !forceRefresh {
            return Just(currentState)
               .setFailureType(to: HTTPError.self)
               .eraseToAnyPublisher()
         }

         // Scenario 4: We need a new OAuthState
         let publisher = session.dataTaskPublisher(for: endpoint,
                                                   refreshToken: currentState?.refreshToken)
            .share()
            .mapToHTTPResponse()
            .responseData(validStatusCodes: endpoint.validStatusCodes)
            .decoding(type: OAuthState.self, decoder: JSONDecoder.oAuthStateJSONDecoder)
            .handleEvents(receiveOutput: { newState in
               self.currentState = newState
               saveOAuthState(newState)
            }, receiveCompletion: { _ in
               authenticationQueue.sync {
                  refreshPublisher = nil
               }
            })
            .eraseToAnyPublisher()

         refreshPublisher = publisher

         return publisher
      }
   }

   private func loadOAuthState() -> OAuthState? {
      try? keychainOAuthItem.readObject()
   }

   private func saveOAuthState(_ state: OAuthState) {
      try? keychainOAuthItem.saveJSON(state)
   }

   public func clearOAuthState() -> AnyPublisher<Void, Error> {
      Deferred {
         Future { promise in
            do {
               try self.keychainOAuthItem.deleteItem()
               promise(.success(()))
            } catch {
               promise(.failure(error))
            }
         }
      }
      .eraseToAnyPublisher()
   }
}
