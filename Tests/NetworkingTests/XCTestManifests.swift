import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
   return [
      testCase(APIEndpointTests.allTests),
      testCase(HTTPMethodTests.allTests)
   ]
}
#endif
