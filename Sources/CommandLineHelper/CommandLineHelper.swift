struct CommandLineHelper {
    var text = "Hello, World!"
}

struct CommandLineOptions {
  static var options: [String] = []
  
  static func addOption(_ name: String) {
    options.append(name)
  }
}

typealias Options = (String, String)
func parseArguments(_ args:[String]) -> [Options] {
  var options: [Options] = []
  for option in CommandLineOptions.options {
    if let index = args.firstIndex(of: option) {
      options.append((option, args[index+1]))
    }
  }
  
  return options
}
