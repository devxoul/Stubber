import ObjectiveC.runtime

private var stubsKey: Void?
private var executionsKey: Void?

public protocol Stub: class {
}

public extension Stub {

  // MARK: Associated Objects

  private func associatedObject<T>(for key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(self, key) as? T
  }

  private func setAssociatedObject<T>(_ value: T?, for key: UnsafeRawPointer) {
    objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }


  // MARK: Properties

  private typealias TypeName = String
  private typealias FunctionAddress = Int
  private typealias Function = Any

  private var stubs: [TypeName: [FunctionAddress: Function]] {
    get { return self.associatedObject(for: &stubsKey) ?? [:] }
    set { self.setAssociatedObject(newValue, for: &stubsKey) }
  }
  private var executions: [TypeName: [FunctionAddress: [AnyExecution]]] {
    get { return self.associatedObject(for: &executionsKey) ?? [:] }
    set { self.setAssociatedObject(newValue, for: &executionsKey) }
  }


  // MARK: Stub

  public func stub<R>(_ f: () -> R, with closure: @escaping () -> R) {
    self._stub(f, with: closure)
  }

  public func stub<A, R>(_ f: (A) -> R, with closure: @escaping (A) -> R) {
    self._stub(f, with: closure)
  }

  private func _stub<A, R>(_ f: (A) -> R, with closure: @escaping (A) -> R) {
    var stubs = self.stubs[self.typeName] ?? [:]
    let address = self.address(of: f)
    stubs[address] = closure
    self.stubs[typeName] = stubs
  }


  // MARK: Stubbed

  public func stubbed<R>(_ f: (() -> R), file: StaticString = #file, line: UInt = #line) -> R {
    guard let result = self._stubbed(f, args: (), file: file, line: line) else {
      preconditionFailure("⚠️ Method not stubbed. Check the last call stack.", file: file, line: line)
    }
    return result
  }

  public func stubbed<A, R>(_ f: (A) -> R, args: A, file: StaticString = #file, line: UInt = #line) -> R {
    guard let result = self._stubbed(f, args: args, file: file, line: line) else {
      preconditionFailure("⚠️ Method not stubbed. Check the last call stack.", file: file, line: line)
    }
    return result
  }

  private func _stubbed<A, R>(_ f: (A) -> R, args: A, file: StaticString = #file, line: UInt = #line) -> R? {
    let address = self.address(of: f)
    guard let closure = self.stubs[self.typeName]?[address] as? (A) -> R else {
      return nil
    }
    let result = closure(args)
    var executions = self.executions[self.typeName] ?? [:]
    executions[address] = (executions[address] ?? []) + [Execution<A, R>(arguments: args, result: result)]
    self.executions[self.typeName] = executions
    return result
  }


  // MARK: Executions

  public func executions<R>(_ f: () -> R) -> [Execution<Void, R>] {
    return self._executions(f)
  }

  public func executions<A, R>(_ f: (A) -> R) -> [Execution<A, R>] {
    return self._executions(f)
  }

  private func _executions<A, R>(_ f: (A) -> R) -> [Execution<A, R>] {
    let address = self.address(of: f)
    guard let executions = self.executions[self.typeName] else { return [] }
    return (executions[address] as? [Execution<A, R>]) ?? []
  }


  // MARK: Clear

  public func clearStubs() {
    self.stubs.removeValue(forKey: self.typeName)
    self.executions.removeValue(forKey: self.typeName)
  }


  // MARK: Utils

  private static var typeName: String {
    return String(describing: self)
  }

  private var typeName: String {
    return String(describing: type(of: self))
  }

  private func address<A, R>(of f: (A) -> R) -> Int {
    let (_, lo) = unsafeBitCast(f, to: (Int, Int).self)
    let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
    let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
    return pointer.pointee
  }
}
