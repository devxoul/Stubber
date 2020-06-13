public protocol AnyExecution {
}

public struct Execution<A, R>: AnyExecution {
  private let _arguments: A
  public var arguments: A {
    return self._arguments
  }

  public let result: R

  init(arguments: A, result: R) {
    self._arguments = arguments
    self.result = result
  }
}
