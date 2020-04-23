import XCTest
@testable import CommandLineHelper

final class CommandLineHelperTests: XCTestCase {
  
  override func tearDown() {
    CommandLineOptions.reset()
  }
  
  func testParseValidOptionArguments() {
    // Given
    CommandLineOptions.addOption(name: "short", shortName: "s")
    CommandLineOptions.addOption(name: "long", shortName: "l")
    let input = ["executable", "-s", "arg1", "--long", "arg2"]
    
    do {
      // When
      let parsedArguments = try CommandLineOptions.parse(arguments: input)
      
      // Then: Check if option arguments are parsed corretly
      guard let arg1 = parsedArguments.first(where:{ $0.name == "short" })
        else { XCTFail(); return }
      guard let arg2 = parsedArguments.first(where:{ $0.name == "long" })
        else { XCTFail(); return }
      
      XCTAssertEqual(arg1.value, "arg1")
      XCTAssertEqual(arg2.value, "arg2")
    } catch CommandLineError.duplicatedArgument(_){
      XCTFail()
    } catch CommandLineError.mandatoryArgumentNotFound {
      XCTFail()
    } catch CommandLineError.optionIndexNotFound {
      XCTFail()
    } catch CommandLineError.unknownOptionFound {
      XCTFail()
    } catch {
      XCTFail()
    }
  }
  
  func testParseMandatoryOptionsError() {
    // Given: The input do **not** include the mandatory parameter `test` (i.e. neither `-t` or `--test`)
    CommandLineOptions.addOption(name: "test", shortName: "t", mandatory: true)
    let input = ["executable", "-best", "arg1", "--b", "arg2"]

    do {
      // When
      let _ = try CommandLineOptions.parse(arguments: input)
      // Then
    } catch CommandLineError.mandatoryArgumentNotFound {
      XCTAssert(true)
      return
    } catch {
      XCTFail()
      return
    }
    XCTFail()
  }
  
  func testParseDuplicatedOptionError() {
    // Given: input has duplicated option named test
    CommandLineOptions.addOption(name: "test", shortName: "t")
    let input = ["executable", "-t", "arg1", "--test", "arg2"]
    
    do {
      // When
      let _ = try CommandLineOptions.parse(arguments: input)
      // Then
    } catch CommandLineError.duplicatedArgument(let duplicatedOption){
      XCTAssertEqual(duplicatedOption, "test")
      return
    } catch {
      XCTFail()
      return
    }
    XCTFail()
  }
  
  func testParseUnknownOptionError() {
    // Given: input has an unknown option
    CommandLineOptions.addOption(name: "test", shortName: "t")
    let input = ["executable", "-t", "arg1", "--unknown", "arg2"]
    
    do {
      // When
      let _ = try CommandLineOptions.parse(arguments: input)
      // Then
    } catch CommandLineError.unknownOptionFound{
      XCTAssert(true)
      return
    } catch {
      XCTFail()
      return
    }
    XCTFail()
  }
  
  static var allTests = [
    ("testParseValidOptionArguments", testParseValidOptionArguments),
    ("testParseDuplicatedOptionError", testParseDuplicatedOptionError),
    ("testParseMandatoryOptionsError", testParseMandatoryOptionsError),
    ("testParseUnknownOptionError", testParseUnknownOptionError)
  ]
}
