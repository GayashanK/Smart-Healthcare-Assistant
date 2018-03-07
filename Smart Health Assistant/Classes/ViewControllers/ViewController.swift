//
//  ViewController.swift
//  Smart Health Assistant
//
//  Created by Kasun Gayashan on 3/5/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var launchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomIn(view: launchView)
        _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.send), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func send(){
        self.performSegue(withIdentifier: StoryboardSegueIdnetifier.initialSegue.rawValue, sender: self)
    }
    
    func zoomIn(duration: TimeInterval = 0.2, view:UIView) {
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 5, animations: {() -> Void in
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
        })
    }
}
