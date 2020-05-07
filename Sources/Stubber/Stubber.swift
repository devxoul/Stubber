import Foundation

private typealias FunctionAddress = Int
private typealias Function = Any

private final class Store {
  var stubs: [FunctionAddress: Function] = [:]
  var executions: [FunctionAddress: [AnyExecution]] = [:]
}

private let store = Store()
private let lock = NSLock()


// MARK: Stub

public func register<A, R>(_ f: @escaping (A) throws -> R, with closure: @escaping (A) -> R) {
  let address = functionAddress(of: f)
  lock.lock()
  store.stubs[address] = closure
  store.executions[address]?.removeAll()
  lock.unlock()
}

@available(*, deprecated, renamed: "register(_:with:)")
public func stub<A, R>(_ f: @escaping (A) throws -> R, with closure: @escaping (A) -> R) {
  register(f, with: closure)
}


// MARK: Stubbed

public func invoke<A, R>(_ f: @escaping (A) throws -> R, args: A, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) rethrows -> R {
  let address = functionAddress(of: f)
  let closure = store.stubs[address] as? (A) -> R
  guard let result = closure?(args) else {
    preconditionFailure("⚠️ '\(function)' is not stubbed.", file: file, line: line)
  }

  lock.lock()
  store.executions[address] = (store.executions[address] ?? []) + [Execution<A, R>(arguments: args, result: result)]
  lock.unlock()

  return result
}

public func invoke<A, R>(_ f: @escaping (A) throws -> R, args: A, default: @autoclosure () -> R, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) rethrows -> R {
  let address = functionAddress(of: f)
  let closure = store.stubs[address] as? (A) -> R
  let result = closure?(args) ?? `default`()

  lock.lock()
  store.executions[address] = (store.executions[address] ?? []) + [Execution<A, R>(arguments: args, result: result)]
  lock.unlock()

  return result
}

@available(*, deprecated, renamed: "invoke(_:args:)")
public func stubbed<A, R>(_ f: @escaping (A) throws -> R, args: A, default: @autoclosure () -> R = (nil as R?)!, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) rethrows -> R {
  return try invoke(f, args: args)
}


// MARK: Escaping support

public func invoke<A, R>(_ f: @escaping (A) throws -> R, args: A!, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) rethrows -> R {
  return try invoke(f, args: args as A, file: file, line: line, function: function)
}

public func invoke<A, R>(_ f: @escaping (A) throws -> R, args: A!, default: @autoclosure () -> R, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) rethrows -> R {
  return try invoke(f, args: args as A, default: `default`(), file: file, line: line, function: function)
}


// MARK: Executions

public func executions<A, R>(_ f: @escaping (A) throws -> R) -> [Execution<A, R>] {
  return _executions(f)
}

private func _executions<A, R>(_ f: @escaping (A) throws -> R) -> [Execution<A, R>] {
  let address = functionAddress(of: f)
  return (store.executions[address] as? [Execution<A, R>]) ?? []
}


// MARK: Clear

public func clear() {
  lock.lock()
  store.stubs.removeAll()
  store.executions.removeAll()
  lock.unlock()
}


// MARK: Utils

private func functionAddress<A, R>(of f: @escaping (A) throws -> R) -> Int {
  let (_, lo) = unsafeBitCast(f, to: (Int, Int).self)
  let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
  let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
  return pointer.pointee
}
