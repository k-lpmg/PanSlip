import UIKit

extension UIView: PanSlip {
    
    // MARK: - Public methods
    
    public func slip(animated: Bool, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        guard animated else {
            self.removeFromSuperview()
            self.panSlipCompletion?()
            completion?()
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.dismissUseDirection()
            self.layoutIfNeeded()
        }) { (isFinished) in
            guard isFinished else {return}
            self.removeFromSuperview()
            self.panSlipCompletion?()
            completion?()
        }
    }
    
    public func enablePanSlip(direction: PanSlipDirection,
                              percentThreshold: CGFloat? = nil,
                              completion: (() -> Void)? = nil) {
        setPanSlipDirection(with: direction)
        if let percentThreshold = percentThreshold {
            setPercentThreshold(with: percentThreshold)
        }
        setPanSlipCompletion(with: completion)
        
        guard panGesture == nil else {return}
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        addGestureRecognizer(panGesture!)
    }
    
    public func disablePanSlip() {
        if let panGesture = panGesture {
            removeGestureRecognizer(panGesture)
        }
        panGesture = nil
    }
    
    // MARK: - Private methods
    
    private func dismissUseDirection() {
        guard let dismissDirection = panSlipDirection else {return}
        switch dismissDirection {
        case .leftToRight:
            frame.origin.x = bounds.width
        case .righTotLeft:
            frame.origin.x = -bounds.width
        case .topToBottom:
            frame.origin.y = bounds.height
        case .bottomToTop:
            frame.origin.y = -bounds.height
        }
    }
    
    private func rollback(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin = CGPoint.zero
            self.layoutIfNeeded()
        })
    }
    
    // MARK: - Private selector
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        guard let dismissDirection = panSlipDirection else {return}
        
        let translation = sender.translation(in: self)
        var movementPercent: CGFloat?
        switch dismissDirection {
        case .leftToRight:
            movementPercent = translation.x / bounds.width
        case .righTotLeft:
            movementPercent = -(translation.x / bounds.width)
        case .topToBottom:
            movementPercent = translation.y / bounds.height
        case .bottomToTop:
            movementPercent = -(translation.y / bounds.height)
        }
        
        guard let movement = movementPercent else {return}
        let downwardMovementPercent = fminf(fmaxf(Float(movement), 0.0), 1.0)
        let progress = CGFloat(fminf(downwardMovementPercent, 1.0))
        switch sender.state {
        case .changed:
            guard progress > 0 else {return}
            switch dismissDirection {
            case .leftToRight, .righTotLeft:
                frame.origin.x = translation.x
            case .topToBottom, .bottomToTop:
                frame.origin.y = translation.y
            }
        case .cancelled:
            rollback()
        case .ended:
            guard progress > percentThreshold else {
                rollback()
                return
            }
            
            slip(animated: true)
        default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func setPanSlipDirection(with direction: PanSlipDirection) {
        objc_setAssociatedObject(self, &panSlipDirectionContext, direction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func setPercentThreshold(with percentThreshold: CGFloat) {
        objc_setAssociatedObject(self, &percentThresholdContext, percentThreshold, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func setPanSlipCompletion(with completion: (() -> Void)?) {
        objc_setAssociatedObject(self, &panSlipCompletionContext, completion, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
