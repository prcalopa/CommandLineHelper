
public class Option {
  let name: String
  let shortName: String
  let longName: String
  let mandatory: Bool
  public var value: String?
  
  public init(name: String, shortName: String, mandatory: Bool = false) {
    self.name = name
    self.shortName = shortName.singleHyphen()
    self.longName = name.doubleHyphen()
    self.mandatory = mandatory
  }
}

public class CommandLineHelper {
  private var options: [Option] = []
  
  public init() {}
  
  public func addOptions(_ options: [Option]) {
    self.options = options
  }
  
  public func reset() {
    options = []
  }
  
  public func parse(arguments: [String]) throws -> Void {
    
    // 1. Check if all mandatory options are present
    for option in options where option.mandatory == true {
      if !(arguments.contains(option.shortName) || arguments.contains(option.longName)) {
        throw CommandLineError.mandatoryArgumentNotFound
      }
    }
    
    // 2. Check for unknown options
    var optionsCopy = arguments
    optionsCopy.remove(at: 0)
    
    for option in options {
      // remove executable name
      if let index = optionsCopy.firstIndex(of: option.shortName) {
        optionsCopy.remove(at: index)
        optionsCopy.remove(at: index)
      }
      if let index = optionsCopy.firstIndex(of: option.longName) {
        optionsCopy.remove(at: index)
        optionsCopy.remove(at: index)
      }
    }
    guard optionsCopy.isEmpty else {
      throw CommandLineError.unknownOptionFound
    }
    
    // 3. Here we ensured all mandatory options are present and there are no unknown options
    for option in options {
      // Check for duplicated arguments
      if arguments.contains(option.shortName) && arguments.contains(option.longName) {
        throw CommandLineError.duplicatedArgument(option.name)
      }
      // Check if args contains short name
      else if arguments.contains(option.shortName) {
        // Find index and retrieve argument
        guard let index = arguments.firstIndex(of: option.shortName) else {
          throw CommandLineError.optionIndexNotFound
        }
        //optionsWithArguments.append((option.name, arguments[index+1]))
        option.value = arguments[index+1]
      }
      // Check if args contains long name
      else if arguments.contains(option.longName) {
        // Find index and retrieve argument
        guard let index = arguments.firstIndex(of: option.longName) else {
          throw CommandLineError.optionIndexNotFound
        }
        //optionsWithArguments.append((option.name, arguments[index+1]))
        option.value = arguments[index+1]
      }
    }
    
  }
}

internal extension String {
  func doubleHyphen() -> String {
    return "--" + self
  }
  
  func singleHyphen() -> String {
    return "-" + self
  }
}

public enum CommandLineError: Error {
  case mandatoryArgumentNotFound
  case unknownOptionFound
  case optionIndexNotFound
  case duplicatedArgument(String)
}
