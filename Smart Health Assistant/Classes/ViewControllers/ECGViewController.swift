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
import SwiftChart

class ECGViewController: BaseViewController {

    @IBOutlet weak var chartContainerView: Chart!
    @IBOutlet weak var connectBarButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let disposeBag = DisposeBag()
    var timer : Timer!
    var poseDuration = 60.0
    var currentPoseIndex = 0.0
    var currentTime : Double = 0.0
    var chartValues : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        startButton.layer.cornerRadius = 5
        connectBarButton.rx.tap.subscribe({[weak self] _ in self?.connect()}).disposed(by: disposeBag)
        startButton.rx.tap.subscribe({[weak self] _ in self?.connect()}).disposed(by: disposeBag)
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(ECGViewController.reloadView), name: NSNotification.Name(rawValue: NotificationKey.reloadAfterConnect.rawValue), object: nil)
        progressBar.progress = 0.0
        
        initializeChart()
    }
    
    func startECG() {
        startButton.setTitle("Live", for: .normal)
        startButton.isEnabled = false
        progressBar.progress = 0.0
        if timer == nil {
            timer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(0.3),
                target      : self,
                selector    : #selector(ECGViewController.setProgressBar),
                userInfo    : nil,
                repeats     : true)
            }
//         = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ECGViewController.setProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func setProgressBar(){
        if(currentPoseIndex <= 120.0){
            currentPoseIndex += 0.3
            progressBar.progress = Float(currentPoseIndex) / Float(poseDuration)
        }
        if(progressBar.progress == 1){
            timer.invalidate()
            timer = nil
            startButton.isEnabled = true
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        
        if serial.isReady {
            connectBarButton.image = #imageLiteral(resourceName: "connected")
            connectBarButton.isEnabled = true
            startECG()
        } else if serial.centralManager.state == .poweredOn {
            connectBarButton.image = #imageLiteral(resourceName: "disconnected")
            connectBarButton.isEnabled = true
        } else {
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
            startButton.setTitle("Start", for: .normal)
            startButton.isEnabled = true
            progressBar.progress = 0.0
            currentPoseIndex = 0.0
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
        }
    }
    
    func initializeChart() {
        chartContainerView.delegate = self
        let series = ChartSeries(chartValues)
        series.area = true
        series.color = UIColor.red
        
        // Configure chart layout
        chartContainerView.backgroundColor = UIColor.clear
        chartContainerView.lineWidth = 2
        chartContainerView.labelFont = UIFont.systemFont(ofSize: 0)
        chartContainerView.xLabelsTextAlignment = .center
        chartContainerView.yLabelsOnRightSide = true
        // Add some padding above the x-axis
        chartContainerView.minY = chartValues.min()
        chartContainerView.maxX = chartValues.max()
        chartContainerView.add(series)
       
    }
    
//    func backPressed() {
//        self.dismiss(animated: true, completion: nil)
//    }

}

extension ECGViewController: BluetoothSerialDelegate {
    func serialDidReceiveString(_ message: String) {
        print(message)
        if(currentTime <= 60000){
//            time.append(currentTime)
//            data.append((message as NSString).doubleValue)
            chartValues.append((message as NSString).doubleValue)
            currentTime += 100.0
        }
        if(currentTime == 60100){
            serial.disconnect()
            reloadView()
            initializeChart()
        }
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
//        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = "Disconnected"
        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
//            hud?.mode = MBProgressHUDMode.text
            hud?.labelText = "Bluetooth turned off"
            hud?.hide(true, afterDelay: 1.0)
        }
    }
}

extension ECGViewController: ChartDelegate {
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }

}


