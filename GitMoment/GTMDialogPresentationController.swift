//
//  GTMDialogPresentationController.swift
//  GitMoment
//
//  Created by liying on 24/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMDialogPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    
    var dimmingView = UIView()
    var presentationWrappingView = UIView()
    
    
    override func presentationTransitionWillBegin() {
        
        let containerView = self.containerView
        
        self.dimmingView.frame = (containerView?.bounds)!
        self.dimmingView.backgroundColor = UIColor.black
        self.dimmingView.alpha = 0.4
        self.dimmingView.tag = 1001
        
        self.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
        
        containerView?.insertSubview(self.dimmingView, at: 0)
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect { get {
        var presentedViewFrame = CGRect.zero
        let containerBounds = self.containerView?.bounds
        presentedViewFrame.size = self.presentedViewController.preferredContentSize
        presentedViewFrame.origin = CGPoint(x: ((containerBounds?.size.width)! - presentedViewFrame.size.width) / 2, y: ((containerBounds?.size.height)! - presentedViewFrame.size.width) / 2)
        return presentedViewFrame
        }
    }
    
    func dimmingViewTapped() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }

}
