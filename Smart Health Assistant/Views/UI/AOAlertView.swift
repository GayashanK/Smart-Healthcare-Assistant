//
//  AOAlertView.swift
//  Feel Destination
//
//  Created by KE-MacMini2 on 11/16/17.
//  Copyright © 2017 KeenEye Solutions. All rights reserved.
//

import UIKit
protocol AOAlertDelegate {
    func didTapActionButton()
}

class AOAlertView: UIView {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var btnAction: UIButton!
    
    let nibName = "AOAlertView"
    var contentView: UIView!
    var viewframe: CGRect = CGRect()
    var delegate:AOAlertDelegate?
    var alertType:respond? = nil
    var parentView : UIViewController? = nil
    
    public override init(frame: CGRect) {
        // For use in code
        super.init(frame: frame)
        viewframe = frame
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
    }

    @IBAction func action(_ sender: Any) {
        removeView(isActionButtontap: true)
    }
    
    func removeView(isActionButtontap:Bool = false){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) in
            if isActionButtontap { self.callDidTapActionButton() }
            self.removeFromSuperview()
        })
    }
    
    private func callDidTapActionButton() {
        if self.alertType != .authFailed {
            self.delegate?.didTapActionButton()
        } else if self.parentView != nil {
//            
        }
    }
    
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)
        contentView.frame = viewframe
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setView(errorCode: String, view: UIViewController) {
        parentView = view
        
        // default background image and button title
        self.background.image = UIImage(named: "error_msg_bg")
        self.btnAction.setTitle("Try again?", for: .normal)
        self.message.text = ValidationHelper.instance.getErrorMessage(errorCode: errorCode)
        if let respond = respond(rawValue: errorCode) {
            alertType = respond
            switch respond {
            case .authFailed:
                self.background.image = UIImage(named: "authentication_failed")
                self.btnAction.setTitle("Login again?", for: .normal)
                break
            case .recordNotExists:
                
                break
            default:
                break
            }
        }
    }
    
    func setView(errorMessage: String, view: UIViewController) {
        parentView = view
        
        // default background image and button title
        self.background.image = UIImage(named: "error_msg_bg")
        self.btnAction.setTitle("Try again?", for: .normal)
        self.message.text = errorMessage
    }
    
}

