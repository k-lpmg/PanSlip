import UIKit

public protocol PanSlipBehavior: class {
    var percentThreshold: CGFloat? { get }
}

extension PanSlipBehavior {
    var percentThreshold: CGFloat? {
        return nil
    }
}
