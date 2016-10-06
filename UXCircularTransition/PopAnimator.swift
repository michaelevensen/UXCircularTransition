//
//  PopAnimator.swift
//  UXCircularTransition
//
//  Created by Michael Nino Evensen on 05/10/2016.
//  Copyright © 2016 Michael Nino Evensen. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum PopTransitionMode {
        case Present, Dismiss
    }
    
    var transitionMode: PopTransitionMode = .Present
    
    // View of circle being presented
    var circle: UIView?
    
    // Color of circle, set based on button clicked
    var circleColor: UIColor?
    
    /* Duration */
    let presentDuration = 0.5
    let dismissDuration = 0.3
    
    // Starting point of transition
    var startingPoint = CGPoint.zero {
        didSet {
            self.circle?.center = startingPoint
        }
    }
    
    // Returns the frame for the circle required to fill the screen
    func frameForCircle(center: CGPoint, size: CGSize, start: CGPoint) -> CGRect {
        
        let lengthX = fmax(start.x, size.width - start.x)
        let lengthY = fmax(start.y, size.height - start.y)
    
        /* NOTE: This is really important, because it offsets the original center point with the sizing for the circle */
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        
        // Size
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
    /* MARK: - Required: UIViewControllerAnimatedTransitioning Protocol */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        /* Set the transition duration based on whether it is a presenting transition or a dismiss transition */
        if self.transitionMode == .Present {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // The view that acts as the superview for the views involved in the transition.
        let containterView = transitionContext.containerView
        
        if self.transitionMode == .Present {
            
            // NOTE: This is the view (from the view controller) that is being presented / transitioned to
            if let presentedView = transitionContext.view(forKey: .to) {
                
                let originalCenter = presentedView.center
                let originalSize = presentedView.frame.size
                
                /*
                 *  This is basically copying the view for the UIButton and making a new view that is going to be used for the transition itself.
                 *  Eg. I am not actually animating the button, but a constructed view based of the original UIButton.
                 */
                
                // Calculate the max size for the circle (to animate to)
                self.circle = UIView(frame: self.frameForCircle(center: originalCenter, size: originalSize, start: self.startingPoint))
                
                // unwrap
                guard let circleView = self.circle else {
                    return
                }
                
                // Fully rounded
                circleView.layer.cornerRadius = self.circle!.frame.size.height / 2
                circleView.center = self.startingPoint
                
                // Initially make it very small
                circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                // Set BackgroundColor
                circleView.backgroundColor = self.circleColor
                
                /*
                *   Here I am adding this constructed UIView (that is to be animated) into the containerView which is the holding View (the view that you animate) for the animation.
                */
                containterView.addSubview(circleView)
                
                // Make presentedView very small and transparent
                presentedView.center = self.startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                // Set background color
                presentedView.backgroundColor = self.circleColor!
                
                // Add presented view to container view
                containterView.addSubview(presentedView)
                
                /*
                *   Animate both views
                */
                UIView.animate(withDuration: self.presentDuration, animations: {
                    
                        // scale up circleview
                        circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                        // scale up presentedview
                        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                        // preserve center
                        presentedView.center = originalCenter
                    
                    }, completion: { (finished) in
                        
                        // On completion, complete the transition
                        transitionContext.completeTransition(finished)
                })
            }
        }
        
        /* Back */
        else {
            guard let returningControllerView = transitionContext.view(forKey: .from), let circleView = self.circle else {
                return
            }
            
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            circleView.frame = self.frameForCircle(center: originalCenter, size: originalSize, start: self.startingPoint)
            circleView.layer.cornerRadius = circleView.frame.size.height / 2
            circleView.center = self.startingPoint
            
            UIView.animate(withDuration: self.dismissDuration, animations: {
                
                circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.center = self.startingPoint
                returningControllerView.alpha = 0
                
                
                }, completion: { (_) in
                    returningControllerView.removeFromSuperview()
                    circleView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
}
