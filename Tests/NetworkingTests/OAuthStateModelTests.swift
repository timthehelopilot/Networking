//
//  OAuthStateModelTests.swift
//
//
//  Created by Timothy Barrett on 1/5/21.
//

import XCTest
@testable import Networking

final class OAuthStateModelTests: XCTestCase {

   // MARK: - Tests

   func test_Initialization_ReturnsValidInstance() {
      // Given
      let expiredDate = Date(timeIntervalSinceNow: 19367)
      let token = OAuthState(accessToken: "d98ebd6cf51777sedn21ea53640d81f67be",
                             refreshToken: "d98ebd6cf51454ugh21ea53640d81f67be",
                             expirationDate: expiredDate)

      // Then
      XCTAssertEqual(token.isValid, true)
      XCTAssertEqual(token.expirationDate, expiredDate)
      XCTAssertEqual(token.accessToken, "d98ebd6cf51777sedn21ea53640d81f67be")
      XCTAssertEqual(token.refreshToken, "d98ebd6cf51454ugh21ea53640d81f67be")
   }

   func test_decodingJSON_ReturnsValidInstance() throws {
      // Given
      let decoder = JSONDecoder.oAuthStateJSONDecoder
      let responseData = """
      {
         "access_token":"2YotnFZFEjr1zCsicMWpAA",
         "expires_in":10800,
         "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
      }
      """.data(using: .utf8)!

      // When
      let token = try XCTUnwrap(decoder.decode(OAuthState.self, from: responseData))

      // Then
      XCTAssertEqual(token.isValid, true)
      XCTAssertEqual(token.accessToken, "2YotnFZFEjr1zCsicMWpAA")
      XCTAssertEqual(token.refreshToken, "tGzv3JOkF0XG5Qx2TlKWIA")
   }

   func test_decodingJSON_ReturnsExpiredValidInstance() throws {
      // Given
      let decoder = JSONDecoder.oAuthStateJSONDecoder
      let responseData = """
      {
         "access_token":"2YotnFZFEjr341zCsicMWpAA",
         "expires_in":0,
         "refresh_token":"tGzv3JOkF024XG5Qx2TlKWIA",
      }
      """.data(using: .utf8)!

      // When
      let token = try XCTUnwrap(decoder.decode(OAuthState.self, from: responseData))

      // Then
      XCTAssertEqual(token.isValid, false)
      XCTAssertEqual(token.accessToken, "2YotnFZFEjr341zCsicMWpAA")
      XCTAssertEqual(token.refreshToken, "tGzv3JOkF024XG5Qx2TlKWIA")
   }
}
