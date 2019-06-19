import UIKit

public class PanSlip<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol PanSlipCompatible: class {
    associatedtype PanSlipCompatibleType
    var ps: PanSlipCompatibleType { get }
}
public extension PanSlipCompatible {
    var ps: PanSlip<Self> {
        return PanSlip(self)
    }
}

extension UIView: PanSlipCompatible {}
extension UIViewController: PanSlipCompatible {}
