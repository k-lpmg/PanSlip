import UIKit

public protocol PanSlipBehavior: class {
    var percentThreshold: CGFloat? { get }
}

extension PanSlipBehavior {
    var percentThreshold: CGFloat? {
        return nil
    }
}

extension PanSlipBehavior where Self: UIView {
    var slipDuration: TimeInterval? {
        return nil
    }
    var rollbackDuration: TimeInterval? {
        return nil
    }
}
