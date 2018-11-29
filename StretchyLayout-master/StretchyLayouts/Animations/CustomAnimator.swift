//
//  PresentAnimator.swift
//  StretchyLayouts
//
//  Created by Lam on 11/28/18.
//  Copyright © 2018 Enabled. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject {
    enum TransitionType {
        case present, dismiss
    }
    var type: TransitionType = .present
    var indexPath: IndexPath?
    var tableCellFrame: CGRect?
    var imageView: UIImageView?
    
    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? StretchyViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? ViewController,
            let imageViewSnapshot =  fromVC.imageView.snapshotView(afterScreenUpdates: false),
            let viewSnapshot = fromVC.view.snapshotView(afterScreenUpdates: false), let tableCellFrame = tableCellFrame
            else {
                transitionContext.completeTransition(true)
                return
        }
        let containView = UIView()
        containView.frame = fromVC.view.frame
        viewSnapshot.frame = fromVC.view.frame
        imageViewSnapshot.frame = fromVC.scrollView.convert(fromVC.imageView.frame, to: fromVC.scrollView.superview)
        containView.layer.masksToBounds = true
        fromVC.view.isHidden = true
        
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        transitionContext.containerView.addSubview(containView)
        containView.addSubview(viewSnapshot)
        containView.addSubview(imageViewSnapshot)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0/4, relativeDuration: 2/4, animations: {
                    containView.frame = CGRect(x: tableCellFrame.origin.x, y: tableCellFrame.origin.y + CGFloat.padding, width: tableCellFrame.width, height: tableCellFrame.height - CGFloat.padding * 2)
                })
                UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1, animations: {
                    imageViewSnapshot.frame.origin = .zero
                })
        },
            completion: { [weak self] (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                containView.removeFromSuperview()
                self?.imageView?.isHidden = transitionContext.transitionWasCancelled
                fromVC.view.isHidden = !transitionContext.transitionWasCancelled
        })
    }
    
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard indexPath != nil,
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? ViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? StretchyViewController,
            let imageView = (fromVC.tableView.cellForRow(at: indexPath!) as? CustomTableCell)?.imageViewCell,
            let snapshot = imageView.snapshotView(afterScreenUpdates: false)
            else {
                transitionContext.completeTransition(true)
                return
        }
        self.imageView = imageView
        imageView.isHidden = true
        toVC.view.isHidden = true
        
        let redView = UIView()
        redView.alpha = 0
        redView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1235740449, blue: 0.2699040081, alpha: 1)
        redView.frame = snapshot.frame
        
        snapshot.frame = imageView.frame
        snapshot.frame.origin = CGPoint(x: (tableCellFrame?.origin.x ?? 0), y: (tableCellFrame?.origin.y ?? 0) + CGFloat.padding)
        
        transitionContext.containerView.addSubview(redView)
        transitionContext.containerView.addSubview(snapshot)
        transitionContext.containerView.addSubview(toVC.view)
        
        let finalFrame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.7))
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
                    snapshot.frame = finalFrame
                }
                
                UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1) {
                    redView.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
                    redView.alpha = 0.9
                }
        },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !transitionContext.transitionWasCancelled {
                    toVC.view.setView(hidden: false) {
                        snapshot.removeFromSuperview()
                        redView.removeFromSuperview()
                    }
                }
        })
    }
}

extension CustomAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .present:
            presentTransition(using: transitionContext)
        case .dismiss:
            dismissTransition(using: transitionContext)
        }
    }
}
