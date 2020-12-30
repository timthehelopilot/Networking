//
//  HTTPMethodTests.swift
//  
//
//  Created by Timothy Barrett on 12/22/20.
//

import XCTest
@testable import Networking

final class HTTPMethodTests: XCTestCase {

   // MARK: - Unit Tests

   func test_InitializationFromRawValueOf_GET_ReturnsValidInstance() throws {
      // Given
      let rawValue = "GET"
      let getMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                    unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(getMethod, .get)
      XCTAssertEqual(getMethod.description, rawValue)
   }

   func test_InitializationFromRawValueOf_POST_ReturnsValidInstance() throws {
      // Given
      let rawValue = "POST"
      let postMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                     unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(postMethod, .post)
      XCTAssertEqual(postMethod.description, rawValue)
   }

   func test_InitializationFromRawValueOf_PUT_ReturnsValidInstance() throws {
      // Given
      let rawValue = "PUT"
      let putMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                    unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(putMethod, .put)
      XCTAssertEqual(putMethod.description, rawValue)
   }

   func test_InitializationFromRawValueOf_DELETE_ReturnsValidInstance() throws {
      // Given
      let rawValue = "DELETE"
      let deleteMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                       unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(deleteMethod, .delete)
      XCTAssertEqual(deleteMethod.description, rawValue)
   }

   func test_InitializationFromRawValueOf_CONNECT_ReturnsValidInstance() throws {
      // Given
      let rawValue = "CONNECT"
      let connectMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                        unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(connectMethod, .connect)
      XCTAssertEqual(connectMethod.description, rawValue)
   }

   func test_InitializationFromRawValueOf_OPTIONS_ReturnsValidInstance() throws {
      // Given
      let rawValue = "OPTIONS"
      let optionsMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                        unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(optionsMethod, .options)
      XCTAssertEqual(optionsMethod.description, rawValue)
   }

   func test_InitializationFromRawValueOf_TRACE_ReturnsValidInstance() throws {
      // Given
      let rawValue = "TRACE"
      let traceMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                      unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(traceMethod, .trace)
      XCTAssertEqual(traceMethod.description, rawValue)
   }

   func test_InitializationFromRawValueOf_PATCH_ReturnsValidInstance() throws {
      // Given
      let rawValue = "PATCH"
      let patchMethod = try XCTUnwrap(HTTPMethod(rawValue: rawValue),
                                      unwrapErrorMessage(for: rawValue))

      // Then
      XCTAssertEqual(patchMethod, .patch)
      XCTAssertEqual(patchMethod.description, rawValue)
   }

   // MARK: - Helper Methods

   private func unwrapErrorMessage(for rawValue: String) -> String {
      "Unable to create instance from the given raw value: \(rawValue)"
   }
}
