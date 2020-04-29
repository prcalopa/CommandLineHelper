import XCTest
@testable import CommandLineHelper

final class CommandLineHelperTests: XCTestCase {
  
  var commandLineHelper: CommandLineHelper!
  
  override func setUp() {
    super.setUp()
    commandLineHelper = CommandLineHelper()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testParseValidOptionArguments() {
    // Given
    let shortOption = Option(name: "short", shortName: "s")
    let longOption = Option(name: "long", shortName: "l")
    
    commandLineHelper.addOptions([shortOption, longOption])
    
    let input = ["executable", "-s", "arg1", "--long", "arg2"]
    
    do {
      // When
      try commandLineHelper.parse(arguments: input)
      
      XCTAssertEqual(shortOption.value!, "arg1")
      XCTAssertEqual(longOption.value!, "arg2")
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
    let option = Option(name: "test", shortName: "t", mandatory: true)
    
    commandLineHelper.addOptions([option])
    
    let input = ["executable", "-best", "arg1", "--b", "arg2"]

    do {
      // When
      try commandLineHelper.parse(arguments: input)
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
    let option = Option(name: "test", shortName: "t")
    commandLineHelper.addOptions([option])
    
    let input = ["executable", "-t", "arg1", "--test", "arg2"]

    do {
      // When
      try commandLineHelper.parse(arguments: input)
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
    let option = Option(name: "test", shortName: "t", mandatory: true)
    commandLineHelper.addOptions([option])

    let input = ["executable", "-t", "arg1", "--unknown", "arg2"]

    do {
      // When
      try commandLineHelper.parse(arguments: input)
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
