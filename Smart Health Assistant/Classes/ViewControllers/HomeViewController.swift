//
//  HomeViewController.swift
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
import SideMenu

class HomeViewController: BaseViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var bluetoothBarButton: UIBarButtonItem!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSideMenu()
        serial = BluetoothSerial(delegate: self)
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
        bluetoothBarButton.rx.tap.subscribe({[weak self] _ in self?.scanBluetooth()}).disposed(by: disposeBag)
        menuBarButton.rx.tap.subscribe({[weak self] _ in self?.menuTapped()}).disposed(by: disposeBag)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func scanBluetooth() {
        self.alertSettings(message: "Turn on bluetooth")
    }
    
    func menuTapped() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        if serial.isReady {
            bluetoothBarButton.isEnabled = false
        } else if serial.centralManager.state == .poweredOn {
            bluetoothBarButton.isEnabled = false
        } else {
            bluetoothBarButton.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HomeViewController: BluetoothSerialDelegate {
    func serialDidReceiveString(_ message: String) {
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            self.alertSettings(message: "Turn on bluetooth")
        }
    }
}

