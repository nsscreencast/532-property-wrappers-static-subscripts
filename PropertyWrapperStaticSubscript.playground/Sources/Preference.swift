import Foundation

public protocol UserDefaultsProvider {
    var defaults: UserDefaults { get }
}

//extension UserDefaultsProvider {
//    var defaults: UserDefaults { .standard }
//}

@propertyWrapper
public struct Preference<Value: UserDefaultsSerializable> {
    public let key: UserDefaultsKey
    public let `default`: Value

    @available(*, unavailable, message: "The enclosing type must be a class")
    public var wrappedValue: Value {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    public init(wrappedValue: Value, key: UserDefaultsKey) {
        self.key = key
        self.default = wrappedValue
    }

    public init<T>(key: UserDefaultsKey) where Value == Optional<T> {
        self.key = key
        self.default = nil
    }

    public static subscript<EnclosingInstance: UserDefaultsProvider>(
        _enclosingInstance instance: EnclosingInstance,
        wrapped wrappedKeyPath: KeyPath<EnclosingInstance, Value>,
        storage storageKeyPath: KeyPath<EnclosingInstance, Self>
    ) -> Value {
        get {
            let defaults = instance.defaults
            let wrapper = instance[keyPath: storageKeyPath]

            if let value = defaults.object(forKey: wrapper.key.stringValue) as? Value {
                return value
            }
            return wrapper.default
        }
        set {
            let defaults = instance.defaults
            let wrapper = instance[keyPath: storageKeyPath]

            defaults.set(newValue, forKey: wrapper.key.stringValue)
        }
    }
}
