public struct CommandLineHelper {
    public var text = "Hello, World!"
}

public struct CommandLineOptions {
  public static var options: [String] = []
  
  public static func addOption(_ name: String) {
    options.append(name)
  }
}

public typealias Options = (String, String)
public func parseArguments(_ args:[String]) -> [Options] {
  var options: [Options] = []
  for option in CommandLineOptions.options {
    if let index = args.firstIndex(of: option) {
      options.append((option, args[index+1]))
    }
  }
  
  return options
}
