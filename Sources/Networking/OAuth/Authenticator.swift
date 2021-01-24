//
//  Authenticator.swift
//  
//
//  Created by Timothy Barrett on 1/12/21.
//

import Foundation
import Combine

/// A class that takes care of storing and retrieving an OAuth token for the given endpoint when initialized.
final public class Authenticator {

   // MARK: - Properties

   /// The queue that all methods for this class will run on. Prefixed with the Authenticator label.
   private let authenticationQueue = DispatchQueue(label: "Authenticator" + UUID().uuidString)

   /// An instance of `URLSession` that is used for OAuth requests in retrieving the token.
   private let session: OAuthSession

   /// The current state of the OAuth state. This will be nil if the user is not logged in.
   private var currentState: OAuthState?

   /// The initial endpoint to retrieve the first token used for all OAuth requests.
   private var initialTokenEndpoint: Endpoint

   /// The refresh endpoint to retrieve a refreshed token for all OAuth requests.
   private var refreshTokenEndpoint: Endpoint

   /// The publisher responsible for emitting the OAuth token if multiple token requests are initiated.
   private var refreshPublisher: AnyPublisher<OAuthState, HTTPError>?

   // MARK: - Initialization

   /// Creates and Authenticator instance that manages the OAuth token and refreshes when needed.
   /// - Parameters:
   ///   - session: A configured `URLSession` instance used for all OAuth requests.
   ///   - currentState: The current OAuth token for all authentication requests.
   ///   - initialTokenEndpoint: The endpoint that is needed to retrieve the initial token.
   ///   - refreshTokenEndpoint: The endpoint needed for all token refresh requests.
   public init(session: OAuthSession,
               currentState: OAuthState?,
               initialTokenEndpoint: Endpoint,
               refreshTokenEndpoint: Endpoint) {

      self.session = session
      self.currentState = currentState
      self.initialTokenEndpoint = initialTokenEndpoint
      self.refreshTokenEndpoint = refreshTokenEndpoint
   }

   // MARK: - API

   /// TA publisher that will emit the current valid OAuth token is user is authenticated.
   /// - Parameters:
   ///   - forceRefresh: Wether to force a refresh token call regardless of the current expiration date. Default is `false`.
   ///   - initialToken: Determines if this is the first time retrieving an OAuth token. Default is  `false`.
   /// - Returns: A publisher that retrieves a OAuth token and publishes the result.
   public func validOAuthState(forceRefresh: Bool = false, initialToken: Bool = false)
                               -> AnyPublisher<OAuthState, HTTPError> {

      authenticationQueue.sync { [unowned self] in
         // Scenario 1: We are already in the process of refreshing the OAuthState so return
         // the existing refresh publisher
         if let refreshPublisher = refreshPublisher {
            return refreshPublisher
         }

         // Scenario 2: We don't have an OAuthState at all, The user is required to log in.
         guard let currentState = currentState, !initialToken else {
            return Fail(error: HTTPError.logInRequired)
               .eraseToAnyPublisher()
         }

         // Scenario 3: We already have a valid OAuthState and don't want to force a refresh.
         if currentState.isValid, !forceRefresh {
            return Just(currentState)
               .setFailureType(to: HTTPError.self)
               .eraseToAnyPublisher()
         }

         // Scenario 4: We need a new OAuthState
         let endpoint = initialToken ? initialTokenEndpoint : refreshTokenEndpoint
         let publisher = session.dataTaskPublisher(for: endpoint)
            .share()
            .mapToHTTPResponse()
            .responseData(validStatusCodes: endpoint.validStatusCodes)
            .decoding(type: OAuthState.self, decoder: JSONDecoder.oAuthStateJSONDecoder)
            .handleEvents(receiveOutput: { newState in
               self.currentState = newState
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
}
