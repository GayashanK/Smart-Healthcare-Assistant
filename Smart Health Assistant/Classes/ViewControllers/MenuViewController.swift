//
//  MenuViewController.swift
//  iHeart
//
//  Created by Kasun Gayashan on 1/22/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    fileprivate var menuRowHeight = 57

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        var nibName = UINib(nibName: CellIdentifier.sideMenuHeaderCell.rawValue, bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: CellIdentifier.sideMenuHeaderCell.rawValue)
        
        nibName = UINib(nibName: CellIdentifier.sideMenuTableCell.rawValue, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: CellIdentifier.sideMenuTableCell.rawValue)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = UIColor.clear
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension MenuViewController : UITableViewDelegate{
    
}

extension MenuViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.sideMenuTableCell.rawValue, for: indexPath) as! SideMenuTableCell
        
        cell.selectionStyle = .none
        cell.imgView?.clipsToBounds = true
        cell.imgView?.layer.cornerRadius = 20
        
        switch indexPath.row {
        case 0:
            cell.imgView.image = #imageLiteral(resourceName: "menu_profile_selected")
            cell.titleLbl.text = "Profile"
            break
        case 1:
            cell.imgView.image = #imageLiteral(resourceName: "menu_pulse")
            cell.titleLbl.text = "Pulse Rate"
            break
        case 2:
            cell.imgView.image = #imageLiteral(resourceName: "menu_bp")
            cell.titleLbl.text = "Blood Pressure"
            break
        case 3:
            cell.imgView.image = #imageLiteral(resourceName: "menu_ecg")
            cell.titleLbl.text = "ECG"
            break
        case 4:
            cell.imgView.image = #imageLiteral(resourceName: "menu_meet_doc")
            cell.titleLbl.text = "Meet Doctor"
            break
        case 5:
            cell.imgView.image = #imageLiteral(resourceName: "menu_history")
            cell.titleLbl.text = "History"
            break
        default:
            break
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
            self.dismiss(animated: true, completion: nil)
        }else if(indexPath.row == 1){
//            self.performSegue(withIdentifier: StoryboardSegueIdnetifier.pulseRate.rawValue, sender: self)
        }else if(indexPath.row == 2){
//            self.performSegue(withIdentifier: StoryboardSegueIdnetifier.bloodPressure.rawValue, sender: self)
        }else if(indexPath.row == 3){
            self.performSegue(withIdentifier: StoryboardSegueIdnetifier.ecgSegue.rawValue, sender: self)
        }else if(indexPath.row == 4){
//            self.performSegue(withIdentifier: StoryboardSegueIdnetifier.meetDoctor.rawValue, sender: self)
        }else if(indexPath.row == 5){
//            self.performSegue(withIdentifier: StoryboardSegueIdnetifier.history.rawValue, sender: self)
        }else{

        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(menuRowHeight)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: SideMenuHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellIdentifier.sideMenuHeaderCell.rawValue) as! SideMenuHeaderCell
        
        cell.conView.dropShadow(color: .white, offSet: CGSize(width: 0, height: 0))
        cell.imgView.layer.cornerRadius = 46.0
        cell.imgView.clipsToBounds = true
        cell.imgView.layer.masksToBounds = true
        
//        let name = UserDefaults.standard.string(forKey: UserDefaultsKey.userName.rawValue)
//        let phone = UserDefaults.standard.string(forKey: UserDefaultsKey.phone.rawValue)
//        let team = UserDefaults.standard.string(forKey: UserDefaultsKey.team.rawValue)
//        let university = UserDefaults.standard.string(forKey: UserDefaultsKey.university.rawValue)
//        let photo = UserDefaults.standard.string(forKey: UserDefaultsKey.userPhoto.rawValue)
        
//        if(name != "" && name != nil ){
//            cell.nameLabel.text = name
//        }
//        if(team != "" && team != nil ){
//            cell.teamLabel.text = team
//        }
//        if(university != "" && university != nil ){
//            cell.universityLabel.text = university
//        }
//        if(photo != "" && photo != nil ){
//            print(photo)
//            cell.imgView.loadImage(urlString: photo!)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
}



