import Foundation

@objc public class Tooti: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
