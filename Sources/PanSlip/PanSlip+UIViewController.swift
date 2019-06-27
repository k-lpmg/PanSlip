import UIKit

private var slipDirectionContext: UInt8 = 0
private var slipCompletionContext: UInt8 = 0

private var panSlipViewControllerProxyContext: UInt8 = 0

extension PanSlip where Base: UIViewController {
    
    // MARK: - Properties
    
    private(set) var slipDirection: PanSlipDirection? {
        get {
            return objc_getAssociatedObject(base, &slipDirectionContext, defaultValue: nil)
        }
        set {
            objc_setAssociatedObject(base, &slipDirectionContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private(set) var slipCompletion: (() -> Void)? {
        get {
            return objc_getAssociatedObject(base, &slipCompletionContext, defaultValue: nil)
        }
        set {
            objc_setAssociatedObject(base, &slipCompletionContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var viewControllerProxy: PanSlipViewControllerProxy? {
        get {
            return objc_getAssociatedObject(base, &panSlipViewControllerProxyContext, defaultValue: nil)
        }
        set {
            objc_setAssociatedObject(base, &panSlipViewControllerProxyContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Public methods
    
    public func enable(slipDirection: PanSlipDirection, slipCompletion: (() -> Void)? = nil) {
        self.slipDirection = slipDirection
        self.slipCompletion = slipCompletion
        
        if viewControllerProxy == nil {
            viewControllerProxy = PanSlipViewControllerProxy(viewController: base,
                                                             slipDirection: slipDirection,
                                                             slipCompletion: slipCompletion)
            viewControllerProxy?.configure()
        }
    }
    
    public func disable() {
        slipDirection = nil
        slipCompletion = nil
        
        viewControllerProxy = nil
    }
    
    public func slip(animated: Bool) {
        defer {
            viewControllerProxy?.unconfigure()
            slipCompletion?()
        }
        
        viewControllerProxy?.interactiveTransition.hasStarted = true
        base.dismiss(animated: true, completion: nil)
        
        viewControllerProxy?.interactiveTransition.shouldFinish = true
        viewControllerProxy?.interactiveTransition.hasStarted = false
        viewControllerProxy?.interactiveTransition.finish()
    }
    
}

// MARK: - PanSlipViewControllerProxy

private class PanSlipViewControllerProxy: NSObject {
    
    // MARK: - Properties
    
    let interactiveTransition = InteractiveTransition()
    
    private unowned let viewController: UIViewController
    private var slipDirection: PanSlipDirection?
    private var slipCompletion: (() -> Void)?
    
    private lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
    
    // MARK: - Con(De)structor
    
    init(viewController: UIViewController, slipDirection: PanSlipDirection, slipCompletion: (() -> Void)?) {
        self.viewController = viewController
        super.init()
        
        self.slipDirection = slipDirection
        self.slipCompletion = slipCompletion
        viewController.transitioningDelegate = self
    }
    
    // MARK: - Internal methods
    
    func configure() {
        viewController.view.addGestureRecognizer(panGesture)
    }
    
    func unconfigure() {
        viewController.transitioningDelegate = nil
        viewController.view.removeGestureRecognizer(panGesture)
    }
    
    // MARK: - Private selector
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        guard let slipDirection = slipDirection else { return }
        
        let translation = sender.translation(in: viewController.view)
        let size = viewController.view.bounds
        var movementPercent: CGFloat?
        switch slipDirection {
        case .leftToRight:
            movementPercent = translation.x / size.width
        case .righTotLeft:
            movementPercent = -(translation.x / size.width)
        case .topToBottom:
            movementPercent = translation.y / size.height
        case .bottomToTop:
            movementPercent = -(translation.y / size.height)
        }
        
        guard let movement = movementPercent else {return}
        let downwardMovementPercent = fminf(fmaxf(Float(movement), 0.0), 1.0)
        let progress = CGFloat(fminf(downwardMovementPercent, 1.0))
        switch sender.state {
        case .began:
            interactiveTransition.hasStarted = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            let percentThreshold: CGFloat = (viewController as? PanSlipBehavior)?.percentThreshold ?? 0.3
            interactiveTransition.shouldFinish = progress > percentThreshold
            interactiveTransition.update(progress)
        case .cancelled:
            interactiveTransition.hasStarted = false
            interactiveTransition.cancel()
        case .ended:
            interactiveTransition.hasStarted = false
            interactiveTransition.shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
            if interactiveTransition.shouldFinish {
                unconfigure()
                slipCompletion?()
            }
        default:
            break
        }
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension PanSlipViewControllerProxy: UIViewControllerTransitioningDelegate {
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let slipDirection = slipDirection, interactiveTransition.hasStarted == true else {return nil}
        return PanSlipAnimator(direction: slipDirection)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
}
