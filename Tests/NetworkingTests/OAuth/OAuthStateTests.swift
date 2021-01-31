//
//  OAuthStateTests.swift
//
//
//  Created by Timothy Barrett on 1/5/21.
//

import XCTest
@testable import Networking

final class OAuthStateTests: XCTestCase {

   // MARK: - Properties

   private var comparableOAuthState: OAuthState!

   // MARK: - Setup

   override func setUp() {
      super.setUp()

      let expirationDate = Date(timeIntervalSinceNow: 20000)

      comparableOAuthState = OAuthState(accessToken: "e78ebd6cf51777sedn21ea53640d81f67be",
                                        refreshToken: "g18ebd6cf51454ugh21ea53640d81f67be",
                                        expirationDate: expirationDate)
   }

   // MARK: - Tear Down

   override func tearDown() {
      comparableOAuthState = nil

      super.tearDown()
   }

   // MARK: Unit Tests

   func test_Initialization_ReturnsValidInstance() {
      // Given
      let expiredDate = Date(timeIntervalSinceNow: 19367)
      let token = OAuthState(accessToken: "d98ebd6cf51777sedn21ea53640d81f67be",
                             refreshToken: "d98ebd6cf51454ugh21ea53640d81f67be",
                             expirationDate: expiredDate)

      // Then
      XCTAssertEqual(token.isValid, true)
      XCTAssertTrue(token < comparableOAuthState)
      XCTAssertEqual(token.expirationDate, expiredDate)
      XCTAssertEqual(token.accessToken, "d98ebd6cf51777sedn21ea53640d81f67be")
      XCTAssertEqual(token.refreshToken, "d98ebd6cf51454ugh21ea53640d81f67be")
   }

   func test_DecodingJSON_ReturnsValidInstance() throws {
      // Given
      let decoder = JSONDecoder.oAuthStateJSONDecoder
      let responseData = """
      {
         "access_token":"2YotnFZFEjr1zCsicMWpAA",
         "expires_in":10800,
         "refresh_token":"b3Gzv3JOkF0XG5Qx2TlKWIA",
      }
      """.data(using: .utf8)!

      // When
      let token = try decoder.decode(OAuthState.self, from: responseData)
      let testDescription = """
      AccessToken: 2YotnFZFEjr1zCsicMWpAA,
      RefreshToken: b3Gzv3JOkF0XG5Qx2TlKWIA,
      ExpirationDate: \(token.expirationDate)
      """

      // Then
      XCTAssertEqual(token.isValid, true)
      XCTAssertTrue(token < comparableOAuthState)
      XCTAssertEqual(token.description, testDescription)
      XCTAssertEqual(token.accessToken, "2YotnFZFEjr1zCsicMWpAA")
      XCTAssertEqual(token.refreshToken, "b3Gzv3JOkF0XG5Qx2TlKWIA")
   }

   func test_DecodingJSON_ReturnsExpiredValidInstance() throws {
      // Given
      let decoder = JSONDecoder.oAuthStateJSONDecoder
      let responseData = """
      {
         "access_token":"2YotnFZFEjr341zCsicMWpAA",
         "expires_in":0,
         "refresh_token":"0atGzv3JOkF024XG5Qx2TlKWIA",
      }
      """.data(using: .utf8)!

      // When
      let token = try decoder.decode(OAuthState.self, from: responseData)

      // Then
      XCTAssertEqual(token.isValid, false)
      XCTAssertTrue(token < comparableOAuthState)
      XCTAssertEqual(token.accessToken, "2YotnFZFEjr341zCsicMWpAA")
      XCTAssertEqual(token.refreshToken, "0atGzv3JOkF024XG5Qx2TlKWIA")
   }

   func test_EncodingOAuthObject_ThenDecoding_ReturnsValidInstance() throws {
      // Given
      let encoder = JSONEncoder()
      let decoder = JSONDecoder()
      let expiredDate = Date(timeIntervalSinceNow: 17987)
      let token = OAuthState(accessToken: "d98ebd6cf51777sedn2ssha53640d81f67be",
                             refreshToken: "d98ebd6cf51454ugh21llslsnwa40d81f67be",
                             expirationDate: expiredDate)

      // When
      let data = try encoder.encode(token)
      let decodedDataToken = try decoder.decode(OAuthState.self, from: data)

      // Then
      XCTAssertEqual(token.isValid, decodedDataToken.isValid)
      XCTAssertEqual(token.accessToken, decodedDataToken.accessToken)
      XCTAssertEqual(token.refreshToken, decodedDataToken.refreshToken)
      XCTAssertEqual(token.expirationDate, decodedDataToken.expirationDate)
   }
}
