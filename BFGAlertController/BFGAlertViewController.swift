//
//  BFGAlertViewController.swift
//  Pods
//
//  Created by Craig Pearlman on 2016-03-23.
//
//

import UIKit

@available(iOS 9.0, *)
class BFGAlertViewController: UIViewController {

    typealias CompletionHandler = (Bool) -> Void
    typealias AnimationBlock = () -> Void
    
    @IBOutlet var alertView: UIStackView?
    @IBOutlet var alertTitle: UILabel?
    @IBOutlet var alertMessage: UILabel?
    @IBOutlet var alertFieldsView: UIStackView?
    @IBOutlet var alertButtonsView: UIStackView?
    
    var appearance = BFGAlertAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.applyAppearance()
        self.hideAlertView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showAlertView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

@available(iOS 9.0, *)
extension BFGAlertViewController {
    
    private func hideAlertView(completion: CompletionHandler? = nil) {
        self.animateAlertView(
            duration: 0.33,
            animations: {
                self.alertView?.transform = CGAffineTransformMakeScale(0, 0)
                self.alertView?.alpha = 0
            },
            completion: completion
        )
    }
    
    private func showAlertView(completion: CompletionHandler? = nil) {
        self.animateAlertView(
            duration: 0.33,
            animations: {
                self.alertView?.transform = CGAffineTransformMakeScale(1, 1)
                self.alertView?.alpha = 1
            },
            completion: completion
        )
    }
    
    private func animateAlertView(duration duration: NSTimeInterval, animations: AnimationBlock, completion: CompletionHandler?) {
        UIView.animateWithDuration(duration,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.05,
            options: .CurveLinear,
            animations: animations,
            completion: completion
        )
    }
    
    private func applyAppearance() {
        self.alertView?.backgroundColor = self.appearance.backgroundColor
        
        self.alertTitle?.textColor = self.appearance.titleColor
        self.alertTitle?.font = self.appearance.titleFont
        
        self.alertMessage?.textColor = self.appearance.messageColor
        self.alertMessage?.font = self.appearance.messageFont
        
        self.view.backgroundColor = self.appearance.shadeColor.colorWithAlphaComponent(self.appearance.shadeOpacity)
        
        self.alertView?.layer.cornerRadius = self.appearance.cornerRadius
        self.alertView?.clipsToBounds = true
    }
    
}