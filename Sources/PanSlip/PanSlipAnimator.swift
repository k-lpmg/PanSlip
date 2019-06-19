import UIKit

final class PanSlipAnimator: NSObject {
    
    let direction: PanSlipDirection
    
    init(direction: PanSlipDirection) {
        self.direction = direction
        super.init()
    }
    
}

extension PanSlipAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {return}
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let screenBounds = UIScreen.main.bounds
        var point: CGPoint?
        switch direction {
        case .leftToRight:
            point = CGPoint(x: screenBounds.width, y: 0)
        case .righTotLeft:
            point = CGPoint(x: -screenBounds.width, y: 0)
        case .topToBottom:
            point = CGPoint(x: 0, y: screenBounds.height)
        case .bottomToTop:
            point = CGPoint(x: 0, y: -screenBounds.height)
        }
        
        guard let finalPoint = point else {return}
        let finalFrame = CGRect(origin: finalPoint, size: screenBounds.size)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFrame
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
