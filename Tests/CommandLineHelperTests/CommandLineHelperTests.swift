import XCTest
@testable import CommandLineHelper

final class CommandLineHelperTests: XCTestCase {
  
  func testParseArguments() {
    
    CommandLineOptions.addOption("-test", mandatory: true)
    CommandLineOptions.addOption("-notMandatory", mandatory: true)
    
    let input = ["executable", "-test", "arg1", "-unknown", "arg2"]
    
    do {
      let result = try parseArguments(input)
      XCTAssertEqual(result.count, 1)
      XCTAssertEqual(result[0].1, "arg1")
    } catch CommandLineError.mandatoryArgumentNotFound {
      XCTAssert(true, "Mandatory argument not found")
    } catch CommandLineError.wrongArgumentsFound {
      XCTAssert(true, "Wrong arguments found")
    } catch {
      XCTFail()
    }
    
  }
  
  static var allTests = [
    ("testParseArguments", testParseArguments)
  ]
}
