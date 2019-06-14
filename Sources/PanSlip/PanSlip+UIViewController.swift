import UIKit

private var interactiveTransitionContext: UInt8 = 0

extension UIViewController: PanSlip {
    
    // MARK: - Properties
    
    private var interactiveTransition: InteractiveTransition? {
        get {
            return objc_getAssociatedObject(self, &interactiveTransitionContext, defaultValue: nil)
        }
        set {
            objc_setAssociatedObject(self, &interactiveTransitionContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Public methods
    
    public func slip(animated: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }
    
    public func enablePanSlip(direction: PanSlipDirection,
                              percentThreshold: CGFloat? = nil,
                              completion: (() -> Void)? = nil) {
        setPanSlipDirection(with: direction)
        if let percentThreshold = percentThreshold {
            setPercentThreshold(with: percentThreshold)
        }
        setPanSlipCompletion(with: completion)
        
        transitioningDelegate = self
        interactiveTransition = InteractiveTransition()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        view.addGestureRecognizer(panGesture!)
    }
    
    public func disablePanSlip() {
        transitioningDelegate = nil
        interactiveTransition = nil
        if let gestureRecognizer = panGesture {
            view.removeGestureRecognizer(gestureRecognizer)
        }
        panGesture = nil
    }
    
    // MARK: - Private selector
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        guard let dismissDirection = panSlipDirection, let interactiveTransition = interactiveTransition else { return }
        
        let translation = sender.translation(in: view)
        var movementPercent: CGFloat?
        switch dismissDirection {
        case .leftToRight:
            movementPercent = translation.x / view.bounds.width
        case .righTotLeft:
            movementPercent = -(translation.x / view.bounds.width)
        case .topToBottom:
            movementPercent = translation.y / view.bounds.height
        case .bottomToTop:
            movementPercent = -(translation.y / view.bounds.height)
        }
        
        guard let movement = movementPercent else {return}
        let downwardMovementPercent = fminf(fmaxf(Float(movement), 0.0), 1.0)
        let progress = CGFloat(fminf(downwardMovementPercent, 1.0))
        switch sender.state {
        case .began:
            interactiveTransition.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactiveTransition.shouldFinish = progress > percentThreshold
            interactiveTransition.update(progress)
        case .cancelled:
            interactiveTransition.hasStarted = false
            interactiveTransition.cancel()
        case .ended:
            interactiveTransition.hasStarted = false
            interactiveTransition.shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
            if interactiveTransition.shouldFinish {
                panSlipCompletion?()
            }
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

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let dismissDirection = panSlipDirection, interactiveTransition?.hasStarted == true else {return nil}
        return PanSlipAnimator(direction: dismissDirection)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactiveTransition = interactiveTransition else {return nil}
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
}
