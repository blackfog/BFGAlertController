//
//  AlertSideBySideView.swift
//
//  Created by Craig Pearlman on 2015-06-30.
//

import UIKit

// MARK: - Main
class AlertSideBySideView: UIView {
    // MARK: - Declarations
    
    var leftView     = UIView()
    var rightView    = UIView()
    var dividerColor = UIColor.gray
    var dividerWidth = CGFloat(0.5)
    
    // MARK: - Private Declarations
    
    fileprivate var dividerView: UIView?
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(left: UIView, right: UIView) {
        self.init(frame: CGRect())

        self.leftView = left
        self.rightView = right
    }
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        self.insertDivider()
        self.insertLeftView()
        self.insertRightView()
        self.setNeedsLayout()
    }
}

// MARK: - Private
extension AlertSideBySideView {
    fileprivate func insertLeftView() {
        self.leftView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.leftView)
        
        self.addConstraints([
            NSLayoutConstraint(
                item: self.leftView, attribute: .leading,
                    relatedBy: .equal,
                toItem: self, attribute: .leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.leftView, attribute: .trailing,
                    relatedBy: .equal,
                toItem: self.dividerView!, attribute: .leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.leftView, attribute: .top,
                    relatedBy: .equal,
                toItem: self, attribute: .top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.leftView, attribute: .bottom,
                    relatedBy: .equal,
                toItem: self, attribute: .bottom,
                    multiplier: 1.0, constant: 0.0
            )
        ])
    }
    
    fileprivate func insertRightView() {
        self.rightView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.rightView)
        
        self.addConstraints([
            NSLayoutConstraint(
                item: self.rightView, attribute: .leading,
                    relatedBy: .equal,
                toItem: self.dividerView!, attribute: .trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.rightView, attribute: .trailing,
                    relatedBy: .equal,
                toItem: self, attribute: .trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.rightView, attribute: .top,
                    relatedBy: .equal,
                toItem: self, attribute: .top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.rightView, attribute: .bottom,
                    relatedBy: .equal,
                toItem: self, attribute: .bottom,
                    multiplier: 1.0, constant: 0.0
            )
        ])
    }
    
    fileprivate func insertDivider() {
        self.dividerView = UIView()
        self.dividerView?.translatesAutoresizingMaskIntoConstraints = false
        self.dividerView?.backgroundColor = self.dividerColor

        self.addSubview(self.dividerView!)
        
        self.addConstraints([
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .centerX,
                    relatedBy: .equal,
                toItem: self, attribute: .centerX,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .centerY,
                    relatedBy: .equal,
                toItem: self, attribute: .centerY,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .width,
                    relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
                    multiplier: 1.0, constant: self.dividerWidth
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .top,
                    relatedBy: .equal,
                toItem: self, attribute: .top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .bottom,
                    relatedBy: .equal,
                toItem: self, attribute: .bottom,
                    multiplier: 1.0, constant: 0.0
            )
        ])
    }
}
