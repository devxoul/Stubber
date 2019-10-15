import Stubber
import Foundation

final class StubClass {
  func argument0_returnVoid_defaultNo() {
    return Stubber.invoke(argument0_returnVoid_defaultNo, args: ())
  }
  func argument0_returnVoid_defaultVoid() {
    return Stubber.invoke(argument0_returnVoid_defaultVoid, args: (), default: Void())
  }

  func argument1_returnInt_defaultNo(_ value: String) -> Int {
    return Stubber.invoke(argument1_returnInt_defaultNo, args: value)
  }
  func argument1_returnInt_defaultInt(_ value: String) -> Int {
    return Stubber.invoke(argument1_returnInt_defaultInt, args: value, default: 0)
  }

  func argument1_parameterOptional_returnBool_defaultNo(_ value: String?) -> Bool {
    return Stubber.invoke(argument1_parameterOptional_returnBool_defaultNo, args: value)
  }
  func argument1_parameterOptional_returnBool_defaultBool(_ value: String?) -> Bool {
    return Stubber.invoke(argument1_parameterOptional_returnBool_defaultBool, args: value, default: false)
  }

  func argument2_parameterOptional_returnBool_defaultNo(_ value1: String?, _ value2: String) -> Bool {
    return Stubber.invoke(argument2_parameterOptional_returnBool_defaultNo, args: (value1, value2))
  }
  func argument2_parameterOptional_returnBool_defaultBool(_ value1: String?, _ value2: String) -> Bool {
    return Stubber.invoke(argument2_parameterOptional_returnBool_defaultBool, args: (value1, value2), default: false)
  }

  func argument3_returnOptionalString_defaultNo(_ value1: String, _ value2: Int, _ value3: Float) -> String? {
    return Stubber.invoke(argument3_returnOptionalString_defaultNo, args: (value1, value2, value3))
  }
  func argument3_returnOptionalString_defaultString(_ value1: String, _ value2: Int, _ value3: Float) -> String? {
    return Stubber.invoke(argument3_returnOptionalString_defaultString, args: (value1, value2, value3), default: "default")
  }

  func argument0_returnOptionalInt_defaultNil() -> Int? {
    return Stubber.invoke(argument0_returnOptionalInt_defaultNil, args: (), default: nil)
  }

  func argument2_returnString_defaultNo_throws(_ value1: String, _ value2: Int) throws -> String {
    return try Stubber.invoke(argument2_returnString_defaultNo_throws, args: (value1, value2))
  }

  func argument_escapeClosure(_ value1: String, _ value2: @escaping (Bool) -> String) -> Void {
    return Stubber.invoke(argument_escapeClosure, args: escaping(value1, value2), default: Void())
  }

  func argument_1_generic<T>(_ value: T) -> T {
    return Stubber.invoke(argument_1_generic, args: value, default: value)
  }

  func sleep() {
    Stubber.invoke(self.sleep, args: (), default: { Foundation.sleep(1) }())
  }
}
