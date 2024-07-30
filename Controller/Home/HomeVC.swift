//
//  HomeVC.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit
import AliveCorKitLite


class HomeVC: BaseVC {
    
    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //MARK: - Variable
    let viewModel = HomeViewModel()
    var languageStrings = [String:AnyObject]()
    var homeTitleLabel = [String]()
    var homeSubTitleLabel = [String]()
    var homeDescriptionLabel = [String]()
    

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
    }
    
    //MARK: - Private Function
    private func customizeUI() {
        languageStringConvert()
        callApi ()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        setNavigation(title: (languageStrings[Keys.appName] as? String)!,showMenuButton: true,showRedLine: true)
        if  let user = Global.getDataFromUserDefaults(.userData) {
            let deviceLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-")
        }
       
        //Title
        homeTitleLabel.append(AppConfig.empty)
        homeTitleLabel.append(languageStrings[Keys.bloodPressureTitle] as? String ?? AppConfig.empty)
        homeTitleLabel.append(languageStrings[Keys.restingTitle] as? String ?? AppConfig.empty)
        homeTitleLabel.append(languageStrings[Keys.weightTitle] as? String ?? AppConfig.empty)
        homeTitleLabel.append(languageStrings[Keys.medicationTitle] as? String ?? AppConfig.empty)
        homeTitleLabel.append(AppConfig.empty)
        //SubTitle
        homeSubTitleLabel.append(AppConfig.empty)
        homeSubTitleLabel.append(languageStrings[Keys.bloodPressureSubTitle] as? String ?? AppConfig.empty)
        homeSubTitleLabel.append(languageStrings[Keys.restingSubTitle] as? String ?? AppConfig.empty)
        homeSubTitleLabel.append(AppConfig.empty)
        homeSubTitleLabel.append(languageStrings[Keys.restingSubTitle] as? String ?? AppConfig.empty)
        homeSubTitleLabel.append(AppConfig.empty)
        
        //Description
       
        homeDescriptionLabel.append(AppConfig.empty)
        homeDescriptionLabel.append(languageStrings[Keys.bloodPressureDetail] as? String ?? AppConfig.empty)
        homeDescriptionLabel.append(languageStrings[Keys.restingDetail] as? String ?? AppConfig.empty)
        homeDescriptionLabel.append(languageStrings[Keys.weightDetail] as? String ?? AppConfig.empty)
        homeDescriptionLabel.append(languageStrings[Keys.medicationDetail] as? String ?? AppConfig.empty)
        homeDescriptionLabel.append(AppConfig.empty)
     
}
    
    //MARK: - registerCell
    func registerCell() {
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.registerTableCell(identifier: CellIdentifier.homeHeaderCell)
        tableView.registerTableCell(identifier: CellIdentifier.homeFooterCell)
    }
    
    func callApi () {
        
        self.showProgressBar(message: "")
        
        viewModel.home(selectedDate: "") { [self] status, message in
            
            self.hideProgressBar()
             
            if status {
                tableView.reloadData()
            } else {
//                self.showAlert(title: (languageStrings[Keys.invalidCredentials] as? String)!, message: nil, buttonText: languageStrings[Keys.ok] as? String)
            }
          }
    }
}

//MARK: - tableView Delegate
extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

       // return homeTitleLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell:HomeHeaderCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.homeHeaderCell) as! HomeHeaderCell
            cell.titleLabel.text = languageStrings[Keys.electrocardiogram_EKG] as? String
            let dateTime = viewModel.home["createdAt"] as? String
            let dateString = dateTime?.getDateString()
            let timeString = dateTime?.getTimeString()
            cell.dateLabel.text = "\(String(describing: dateString ?? "")) - \(String(describing: timeString ?? ""))"
           // cell.timeLabel.text = dateTime?.getTimeString()
            let determination = viewModel.home["determination"] as? String
            let determinationUppercase = determination!.uppercased()
            cell.reportStatusLabel.text = languageStrings[determinationUppercase] as? String
            
            cell.infoButton.isHidden = (determination != nil) ? false : true
        
            let bpm = viewModel.home["averageHeartRate"]
            if let bpm = viewModel.home["averageHeartRate"] as? NSNumber {
                cell.bpmValueLabel.text = bpm.stringValue
            } else {
                cell.bpmValueLabel.text = ""
            }
           
//            if bpm == "null"{
//                cell.bpmValueLabel.text = "NA"
//            }
            cell.bpmLabel.text = (bpm != nil) ? "BPM" :""
            cell.historyLabel.text = languageStrings[Keys.history] as? String
            cell.recordEKGLabel.text = languageStrings[Keys.recordEKG] as? String
            cell.infoButton.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)
            cell.historyButton.addTarget(self, action: #selector(historyButtonAction), for: .touchUpInside)
            cell.recordEKGButton.addTarget(self, action: #selector(recordECGButtonAction), for: .touchUpInside)
            return cell
        case 5:
            let cell:HomeButtonCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.homeButtonCell) as! HomeButtonCell
            cell.insightButtonText.text = languageStrings[Keys.insight] as? String
            //cell.insightButton.addTarget(self, action: #selector(insightButtonAction), for: .touchUpInside)
            return cell
        default:
            let cell:HomeFooterCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.homeFooterCell) as! HomeFooterCell
           if (indexPath.row != 1) {
               cell.bloodPressureView.isHidden = true
           }
           cell.addBloodPressureLabel.text = languageStrings[Keys.addBloodPressure] as? String
           cell.getStartedLabel.text = languageStrings[Keys.getStarted] as? String
           cell.iconImage.image = HomeItem.homeImageIcon[indexPath.row]
           cell.titleLabel.text = homeTitleLabel[indexPath.row]
           cell.subTitleLabel.text = homeSubTitleLabel[indexPath.row]
           cell.descriptionLabel.text = homeDescriptionLabel[indexPath.row]

           return cell
        }
        
//        if indexPath.row == 0 {
//            let cell:HomeHeaderCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.homeHeaderCell) as! HomeHeaderCell
//            cell.titleLabel.text = languageStrings[Keys.electrocardiogram_EKG] as? String
//            cell.historyLabel.text = languageStrings[Keys.history] as? String
//            cell.recordEKGLabel.text = languageStrings[Keys.recordEKG] as? String
//            cell.historyButton.addTarget(self, action: #selector(historyButtonAction), for: .touchUpInside)
//            cell.recordEKGButton.addTarget(self, action: #selector(recordECGButtonAction), for: .touchUpInside)
//            return cell
//        }else if indexPath.row == homeTitleLabel.count - 1 {
//            let cell:HomeButtonCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.homeButtonCell) as! HomeButtonCell
//            cell.insightButtonText.text = languageStrings[Keys.insight] as? String
//            cell.insightButton.addTarget(self, action: #selector(insightButtonAction), for: .touchUpInside)
//            return cell
//        }else{
//             let cell:HomeFooterCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.homeFooterCell) as! HomeFooterCell
//            if (indexPath.row != 1) {
//                cell.bloodPressureView.isHidden = true
//            }
//            cell.addBloodPressureLabel.text = languageStrings[Keys.addBloodPressure] as? String
//            cell.getStartedLabel.text = languageStrings[Keys.getStarted] as? String
//            cell.iconImage.image = HomeItem.homeImageIcon[indexPath.row]
//            cell.titleLabel.text = homeTitleLabel[indexPath.row]
//            cell.subTitleLabel.text = homeSubTitleLabel[indexPath.row]
//            cell.descriptionLabel.text = homeDescriptionLabel[indexPath.row]
//
//            return cell
//
//        }
        
}

    //MARK: - TableView Cell Button Action
    
    @objc func historyButtonAction(sender:UIButton){
        let vc = HistoryVC.instantiate(fromAppStoryboard: .Home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func recordECGButtonAction(sender:UIButton) {
//        self.showProgressBar()
//        let user = Global.getDataFromUserDefaults(.userData)
//        let diction = ["bundleId": AppConstants.bundleId as AnyObject, "patientMrn": "" as AnyObject, "teamId": AppConstants.teamId as AnyObject, "partnerId": AppConstants.partnerId as AnyObject]
//        viewModel.getToken(diction) { status, message in
//            if status {
//                self.getinitAlivecore()
//            } else {
//                self.hideProgressBar()
//               // self.showToast(message)
//            }
//        }
    }
    
    @objc func infoButtonAction(sender:UIButton){
        let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.isHome = true
       // vc.termsText = TermsConditionArray.privacyPolicy
        vc.titleString = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//extension HomeVC {
//    
//    //MARK: - Initializaion ECG SDK
//    
//    func getinitAlivecore() {
//        ACKManager.initWithApiKey(viewModel.jwtToken, isDebugMode: true) { error, config in
//            if let config = config {
//                print(config)
//                
//                DispatchQueue.main.async {
//                    var configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.card, leadsConfig: .six, filterType: .enhanced, algorithmPackage: "", error: nil)
//
//                    if Global.getDataFromUserDefaults(.device) != nil {
//                        let deviceTypeRaw = Global.getDataFromUserDefaults(.device) as? String ?? ""
//                        let deviceType = ACKDeviceType(rawValue: deviceTypeRaw)
//                        
//                        let leadsConfigRaw = Global.getDataFromUserDefaults(.leadConfig) as? Int ?? 0
//                        let leadsConfig = ACKLeadsConfig(rawValue: leadsConfigRaw)
//                        
//                        configg = ACKEcgRecordingConfig.init(deviceType: deviceType, leadsConfig: leadsConfig ?? .single, filterType: .enhanced, algorithmPackage: "", error: nil)
//                    } else {
//                        Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
//                        Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//                    }
//                    self.hideProgressBar()
//                    if let config1 = configg {
//                        if let monitorViewController = ACKEcgMonitorViewController(config: config1, delegate: self) {
//                           // monitorViewController.delegate = self
//                            let newController = UINavigationController(rootViewController: monitorViewController)
//                            newController.modalPresentationStyle = .overFullScreen
//                            if Global.getTopMostViewController() is ACKEcgMonitorViewController{
//                                return
//                            }
//                            self.present(newController, animated: true)
//                        }
//                    }
//                }
//            } else {
//                self.hideProgressBar()
//            }
//        }
//    }
//}

////MARK: - ACKEcgMontitor Delegate
//extension HomeVC: ACKEcgMonitorDelegate {
// 
//    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didChange config: ACKLeadsConfig) {
//        Global.saveDataInUserDefaults(value: config.rawValue as AnyObject, key: .leadConfig)
//    }
//    
//    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didCancelWithError error: ACKError?) {
//        print(error?.localizedDescription as Any)
//    }
//    
//    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didEncounterError error: ACKError?) {
//        print(error?.localizedDescription as Any)
//    }
//    
//    func showSettingsButton(in viewController: ACKEcgMonitorViewController) -> Bool {
//        return true
//    }
//    
//    func showCancelButton(in viewController: ACKEcgMonitorViewController) -> Bool {
//        return true
//    }
//    
//    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didPressSettingWith config: ACKEcgRecordingConfig?) {
//        let alert = UIAlertController(title: "Select Device", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "TRIANGLE", style: .default, handler: { _ in
//            
//            Global.getTopMostViewController()?.dismiss(animated: true, completion: {
//                
//                
//                var configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.triangle, leadsConfig: .six, filterType: .enhanced, algorithmPackage: "", error: nil)
//                if Global.getDataFromUserDefaults(.lockMode) != nil {
//                    configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.triangle, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
//                }
//                Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
//                Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//                if let config1 = configg {
//                    if let monitorViewController = ACKEcgMonitorViewController(config: config1,delegate: self) {
//                        let newController = UINavigationController(rootViewController: monitorViewController)
//                        newController.modalPresentationStyle = .overFullScreen
//                        self.present(newController, animated: true)
//                    }
//                }
//                
//            })
//            
//        }))
//        alert.addAction(UIAlertAction(title: "KARDIA MOBILE", style: .default, handler: { _ in
//            
//            Global.getTopMostViewController()?.dismiss(animated: true, completion: {
//                
//                let configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.mobile, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
//                Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
//                Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//                if let config1 = configg {
//                    if let monitorViewController = ACKEcgMonitorViewController(config: config1,delegate: self) {
//                        let newController = UINavigationController(rootViewController: monitorViewController)
//                        newController.modalPresentationStyle = .overFullScreen
//                        self.present(newController, animated: true)
//                    }
//                }
//                
//            })
//        }))
//        
//        alert.addAction(UIAlertAction(title: "KARDIA CARD", style: .default, handler: { _ in
//            
//            Global.getTopMostViewController()?.dismiss(animated: true, completion: {
//                
//                let configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.card, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
//                Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
//                Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//                if let config1 = configg {
//                    if let monitorViewController = ACKEcgMonitorViewController(config: config1,delegate: self) {
//                        let newController = UINavigationController(rootViewController: monitorViewController)
//                        newController.modalPresentationStyle = .overFullScreen
//                        self.present(newController, animated: true)
//                    }
//                }
//                
//            })
//        }))
////        alert.addAction(UIAlertAction(title: languageStrings[Keys.cancel] as? String, style: .destructive, handler: { _ in
////
////        }))
//        Global.getTopMostViewController()?.present(alert, animated: true)
//    }
//    
//    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didCompleteRecording record: ACKEcgRecord?) {
//        Global.getTopMostViewController()?.dismiss(animated: true, completion: {
//            if let record = record {
////                if let recordPreviewVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordPreviewViewController") as? RecordPreviewViewController {
////                   // recordPreviewVC.patientId = self.patientId
//                let recordPreviewVC = RecordDetailVC.instantiate(fromAppStoryboard: .Home)
//                    recordPreviewVC.patientId = ""
//                    recordPreviewVC.eckRecord = record
//                    recordPreviewVC.modalPresentationStyle = .overFullScreen
//                self.navigationController?.pushViewController(recordPreviewVC, animated: true)
//                    //self.present(recordPreviewVC, animated: true)
//                }
//          //  }
//        })
//    }
//    
//}

