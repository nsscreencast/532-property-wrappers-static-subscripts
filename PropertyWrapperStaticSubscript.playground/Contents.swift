import Foundation
import UIKit

extension UserDefaultsKey {
    static let theme: Self = .init("app.theme")
    static let notificationsEnabled: Self = .init("notifications.enabled")
}

class AppSettings: UserDefaultsProvider {

    let defaults: UserDefaults

    init(defaults: UserDefaults = .init(suiteName: "com.foo.bar")!) {
        self.defaults = defaults
    }

    @Preference(key: .theme) var theme: String?
    @Preference(key: .notificationsEnabled) var notificationsEnabled: Bool = true
}

var settings = AppSettings()
//settings.theme = "custom"
//settings.notificationsEnabled = false
print("theme: \(settings.theme ?? "<?>")")
print("notifications?: \(settings.notificationsEnabled)")


@propertyWrapper
struct AnyProxy<EnclosingInstance, Value> {
    let keyPath: ReferenceWritableKeyPath<EnclosingInstance, Value>

    init(_ keyPath: ReferenceWritableKeyPath<EnclosingInstance, Value>) {
        self.keyPath = keyPath
    }

    @available(*, unavailable, message: "The enclosing type must be a class")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    static subscript(
        _enclosingInstance instance: EnclosingInstance,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingInstance, Value>,
        storage storageKeyPath: KeyPath<EnclosingInstance, Self>
    ) -> Value {
        get {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            return instance[keyPath: keyPath]
        }
        set {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            instance[keyPath: keyPath] = newValue
        }
    }
}

protocol ProxyContainer {
    typealias Proxy<T> = AnyProxy<Self, T>
}

@available(iOS 15, *)
extension NSObject: ProxyContainer {}

class HeaderView: UIView {
    private var titleLabel = UILabel()
    private var imageView = UIImageView()

    @Proxy(\.titleLabel.text) var title: String?
    @Proxy(\.imageView.image) var image: UIImage?
}

let headerView = HeaderView()
headerView.title = "Property Wrappers"
dump(headerView)
