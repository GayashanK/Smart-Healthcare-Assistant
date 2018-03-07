//
//  ECGViewController.swift
//  Smart Health Assistant
//
//  Created by Kasun Gayashan on 3/5/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreBluetooth
import QuartzCore

class ECGViewController: BaseViewController {

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var connectBarButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButton.rx.tap.subscribe({[weak self] _ in self?.backPressed()}).disposed(by: disposeBag)
        connectBarButton.rx.tap.subscribe({[weak self] _ in self?.connect()}).disposed(by: disposeBag)
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ECGViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        
        if serial.isReady {
            title = serial.connectedPeripheral!.name
            connectBarButton.image = #imageLiteral(resourceName: "connected")
            connectBarButton.isEnabled = true
        } else if serial.centralManager.state == .poweredOn {
            title = "Connect to device"
            connectBarButton.image = #imageLiteral(resourceName: "disconnected")
            connectBarButton.isEnabled = true
        } else {
            title = "Connect to device"
            connectBarButton.image = #imageLiteral(resourceName: "disconnected")
            connectBarButton.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func connect() {
        if(serial.connectedPeripheral == nil){
            self.passDataToViewControllerAction()
        }else if(serial.isReady == false || serial.centralManager.state != .poweredOn){
            self.alertSettings(message: "Turn on bluetooth")
        }else{
            serial.disconnect()
            reloadView()
        }
    }
    
    func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ECGViewController: BluetoothSerialDelegate {
    func serialDidReceiveString(_ message: String) {
        // add the received text to the textView, optionally with a line break at the end
        print(message)
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = "Disconnected"
        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.mode = MBProgressHUDMode.text
            hud?.labelText = "Bluetooth turned off"
            hud?.hide(true, afterDelay: 1.0)
        }
    }
}
