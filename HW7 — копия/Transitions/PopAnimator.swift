//
//  PopAnimator.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//

import UIKit

final class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        let width = source.view.frame.width
        let height = source.view.frame.height
        
        let initialTranslation = CGAffineTransform(translationX: -100, y: 0)
        let initialScale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        destination.view.frame = source.view.frame
        destination.view.transform = initialScale.concatenating(initialTranslation)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.8,
                                                       animations: {
                                                        let translation = CGAffineTransform(translationX: 0, y: 0)
                                                        let scale = CGAffineTransform(scaleX: 1, y: 1)
                                                        destination.view.transform = scale.concatenating(translation)
                                    })
                                    
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.8,
                                                       animations: {
                                                        let translation = CGAffineTransform(translationX: width/2 + height/2, y: -width/2)
                                                        let rotation = CGAffineTransform(rotationAngle: -90 * .pi/180)
                                                        source.view.transform = rotation.concatenating(translation)
                                    })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
