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
import SwiftCharts

class ECGViewController: BaseViewController {

    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var connectBarButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    fileprivate var chart: Chart? // arc
    
    let disposeBag = DisposeBag()
    var timer = Timer()
    var poseDuration = 180.0
    var currentPoseIndex = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        startButton.layer.cornerRadius = 5
        connectBarButton.rx.tap.subscribe({[weak self] _ in self?.connect()}).disposed(by: disposeBag)
        startButton.rx.tap.subscribe({[weak self] _ in self?.startPressed()}).disposed(by: disposeBag)
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        progressBar.progress = 0.0
        setChart()
    }
    
    func startPressed() {
        startButton.setTitle("Live", for: .normal)
        startButton.isEnabled = false
        progressBar.progress = 0.0
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ECGViewController.setProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func setProgressBar(){
        if(currentPoseIndex <= 180.0){
            currentPoseIndex += 0.3
            progressBar.progress = Float(currentPoseIndex) / Float(poseDuration)
        }
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
        }
    }
    
    func setChart() {
        let chartPoints: [ChartPoint] = [(0, 0), (4, 4), (6, 6), (8, 8), (8, 10), (15, 15)].map{ChartPoint(x: ChartAxisValueInt($0.0), y: ChartAxisValueInt($0.1))}
        
        let labelSettings = ChartLabelSettings(font: ChartDefaults.labelFont)
        
        let generator = ChartAxisGeneratorMultiplier(2)
        let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
            return ChartAxisLabel(text: "\(scalar)", settings: labelSettings)
        }
        
        let xGenerator = ChartAxisGeneratorMultiplier(2)
        
        let xModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 16, axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: labelsGenerator)
        
        let yModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 16, axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical())], axisValuesGenerator: generator, labelsGenerator: labelsGenerator)
        
        let chartFrame = ChartDefaults.chartFrame(self.chartContainerView.bounds)
        
        let chartSettings = ChartDefaults.chartSettingsWithPanZoom
        
        // generate axes layers and calculate chart inner frame, based on the axis models
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        // create layer with guidelines
        let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ChartDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.black, lineWidth: 1, animDuration: 45, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], pathGenerator: CatmullPathGenerator()) // || CubicLinePathGenerator
        
        // create chart instance with frame and layers
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer
            ]
        )
        
        chartContainerView.addSubview(chart.view)
        self.chart = chart
    }
    
//    func backPressed() {
//        self.dismiss(animated: true, completion: nil)
//    }

}

extension ECGViewController: BluetoothSerialDelegate {
    func serialDidReceiveString(_ message: String) {
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

