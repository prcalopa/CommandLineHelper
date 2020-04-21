public struct CommandLineHelper {
    public var text = "Hello, World!"
}

public struct CommandLineOptions {
  public static var options: [(String, Bool)] = []
  
  public static func addOption(_ name: String, mandatory: Bool = false) {
    options.append((name, mandatory))
  }
}

public typealias Options = (String, String)
public func parseArguments(_ args:[String]) throws -> [Options] {
  
  let count = (args.count - 1) / 2
  guard count != CommandLineOptions.options.count else {
      throw CommandLineError.wrongArgumentsFound
  }
  
  var options: [Options] = []
  for (name, mandatory) in CommandLineOptions.options {
    if let index = args.firstIndex(of: name) {
      options.append((name, args[index+1]))
    }
    else {
      if mandatory { throw CommandLineError.mandatoryArgumentNotFound }
    }
  }
  
  
  
  return options
}

public enum CommandLineError: Error {
  case mandatoryArgumentNotFound
  case wrongArgumentsFound
}
