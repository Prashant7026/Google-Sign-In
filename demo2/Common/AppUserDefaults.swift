//
//  AppUserDefaults.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation

class AppUserDefaults {
    @UserDefault(key: #keyPath(isApiCalled), defaultValue: false)
    @objc static var isApiCalled: Bool
    
    @UserDefault(key: #keyPath(isLoggedIn), defaultValue: false)
    @objc static var isLoggedIn: Bool
}

typealias NudgesUserDefaultsPropertyWrapper = AppUserDefaults
extension NudgesUserDefaultsPropertyWrapper {
    
    @propertyWrapper
    public struct UserDefault<T> {
        public let key: String
        public let defaultValue: T
        public var wrappedValue: T {
            get {
                if let _udValue = UserDefaults(suiteName: StringConstants.userDefaultsSuiteName)?.object(forKey: key), let udValue = _udValue as? T {
                    switch udValue as Any {
                    // swiftlint:disable:next syntactic_sugar
                    case Optional<Any>.some(let value):
                        guard let unwrappedValue = value as? T else { return defaultValue }
                        return unwrappedValue
                    case Optional<Any>.none:
                        return defaultValue
                    default:
                        return udValue
                    }
                }
                return defaultValue
            }
            set {
                switch newValue as Any {
                // swiftlint:disable:next syntactic_sugar
                case Optional<Any>.some(let value):
                    UserDefaults(suiteName: StringConstants.userDefaultsSuiteName)?.set(value, forKey: key)
                case Optional<Any>.none:
                    UserDefaults(suiteName: StringConstants.userDefaultsSuiteName)?.removeObject(forKey: key)
                default:
                    UserDefaults(suiteName: StringConstants.userDefaultsSuiteName)?.set(newValue, forKey: key)
                }
            }
        }
    }
}
