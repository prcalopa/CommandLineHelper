# CommandLineHelper

Simple tool to help build command line interfaces for Swift

## Basics
We can create options to our CLI by defining their flag names. Moreover, we can set the options as mandatory (by default they will be created as not mandatory unless you specify it).

Let's create an option:
`let option = Option(name: "name", shortName: "n", mandatory: true)`

When we call our executable, to set the option argument (e.g. `someName`) we will use `--name someName` or `-n someName`.

## Usage example
We want to create a CLI with options to set a directory and a filename. The executable call will look like:
`someExecutable --dir path/to/dir/ --file someFile`
or
`someExecutable -d path/to/dir/ -f someFile`

To parse the option arguments with CommandLineHelper is as simple as the code below:
```
import CommandLineHelper

// Add command line options
let commandLineHelper = CommandLineHelper()

let directoryOption = Option(name: "dir", shortName: "d", mandatory: true)
let filenameOption = Option(name: "file", shortName: "f", mandatory: true)

commandLineHelper.addOptions([directoryOption, filenameOption])

// Parse command line option
do {
  try commandLineHelper.parse(arguments: CommandLine.arguments)
} catch {
...
}

// Get the option values
let directory = directoryOption.value! // this will be "path/to/dir/"
let filename = filenameOption.value! // this will be "someFile"
```

