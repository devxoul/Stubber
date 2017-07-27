public protocol AnyExecution {
}

public struct Execution<A, R>: AnyExecution {
  public let arguments: A
  public let result: R
}
