import UIKit

public protocol PanSlip: class {
    var panSlipDirection: PanSlipDirection? { get }
    var percentThreshold: CGFloat { get }
    var panSlipCompletion: (() -> Void)? { get }
    
    func enablePanSlip(direction: PanSlipDirection,
                       percentThreshold: CGFloat?,
                       completion: (() -> Void)?)
    func disablePanSlip()
}

public extension PanSlip {
    var panSlipDirection: PanSlipDirection? {
        get {
            return objc_getAssociatedObject(self, &panSlipDirectionContext, defaultValue: nil)
        }
    }
    var percentThreshold: CGFloat {
        get {
            return objc_getAssociatedObject(self, &percentThresholdContext, defaultValue: 0.3)
        }
    }
    var panSlipCompletion: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &panSlipCompletionContext, defaultValue: nil)
        }
    }
}

extension PanSlip {
    var panGesture: UIGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &panGestureContext, defaultValue: nil)
        }
        set {
            objc_setAssociatedObject(self, &panGestureContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
