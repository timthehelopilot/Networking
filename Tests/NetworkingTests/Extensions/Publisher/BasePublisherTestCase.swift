//
//  BasePublisherTestCase.swift
//  
//
//  Created by Timothy Barrett on 1/30/21.
//

import Combine
import XCTest
@testable import Networking

class BasePublisherTestCase: XCTestCase {

   // MARK: - Properties

   var cancelables: Set<AnyCancellable> = []

   // MARK: - Setup

   override func setUp() {
      super.setUp()
   }

   // MARK: - Tear Down

   override func tearDown() {
      cancelables = []

      super.tearDown()
   }
}
