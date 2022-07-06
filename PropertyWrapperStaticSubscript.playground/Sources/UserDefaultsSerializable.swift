import Foundation

public protocol UserDefaultsSerializable {}

extension String: UserDefaultsSerializable {}
extension Int: UserDefaultsSerializable {}
extension Bool: UserDefaultsSerializable {}
extension Double: UserDefaultsSerializable {}
extension URL: UserDefaultsSerializable {}
extension Array: UserDefaultsSerializable where Element: UserDefaultsSerializable {}
extension Dictionary: UserDefaultsSerializable where Value: UserDefaultsSerializable {}
extension Optional: UserDefaultsSerializable where Wrapped: UserDefaultsSerializable {}
