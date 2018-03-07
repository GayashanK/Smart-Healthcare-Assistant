//
//  AOModalStatusView.swift
//  Feel Destination
//
//  Created by Chamikara R on 11/4/17.
//  Copyright © 2017 KeenEye Solutions. All rights reserved.
//

import UIKit

public class AOModalStatusView: UIView {
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var headerLine: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    let nibName = "AOModalStatusView"
    var contentView: UIView!
    var timer: Timer?
    
    var errorMessage : String {
        get {return self.errorMessage}
        set (newValue) {
            self.headerLine.text = "Error"
            self.message.text = newValue
        }
    }
    
    public override init(frame: CGRect) {
        // For use in code
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
        setUpView()
    }
    
    public override func didMoveToSuperview() {
        // Add a timer to remove the view
        self.timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(3.0),
            target: self,
            selector: #selector(self.removeSelf),
            userInfo: nil,
            repeats: false)
    }
    
    @objc private func removeSelf() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
        })
        
    }
    
    public override func layoutSubviews() {
        // Rounded corners
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
    }

    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        headerLine.text = ""
        
        
//        checkBox.onAnimationType = .oneStroke
//        checkBox.offAnimationType = .fade
        //checkBox.on = false
    }

}
