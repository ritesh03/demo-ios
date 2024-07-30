//
//  HomeViewController.swift
//  synex
//
//  Created by Subhash Mehta on 16/03/24.
//

import UIKit
import FSCalendar
import AliveCorKitLite

class HomeVCNew: BaseVC {
    //MARK: - getObject method
    class func getObject() -> HomeVCNew?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: HomeVCNew.className) as? HomeVCNew{
            return controller
        }
        return nil
    }
    
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var notificationsCountLabel: UILabel!
    @IBOutlet weak var errorLableVerticalConstraints: NSLayoutConstraint!
    @IBOutlet weak var myHealthRecordButton: UIButton!
    @IBOutlet weak var headerDescLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var collectionViewForHome: UICollectionView!
    @IBOutlet weak var determinationTag: UIView!
    @IBOutlet weak var determinationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var noRecordView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var viewForNoData: UIView!
    
    //MARK: - Variable
    var currentDate:String = ""
    var selectedDate:String = ""
    var selectedDevice = ""
    let viewModel = HomeViewModel()
    var homeObj = [String:AnyObject]()
    var bannerArr = [AnyObject]()
    var languageStrings = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        hideNavigationBar()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(retrieveNotificationsCount), name: Notification.Name("getNotifications"), object: nil)
        self.noRecordView.isHidden = false
       // self.notificationsCountLabel.isHidden = true
        self.notificationsView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionViewForHome.reloadData()
        languageStringConvert()
        let language = ""
        calenderView.dataSource = self
        calenderView.delegate = self
        calenderView.select(Date())
        calenderView.scope = .week
        calenderView.locale = Locale.init(identifier: language.getLanguage())
        calenderView.reloadData()
        yearMonthLabel.font = UIFont(name: "Inter-SemiBold", size: 18)
        if  let user = Global.getDataFromUserDefaults(.userData) {
            if let name = user["name"] as? String, name != ""{
                let languageString = ""
                if languageString.getLanguage() == "en"{
                    username.text = "\(name),"
                }else {
                    username.text = "\(name) " + String(languageStrings[Keys.sir] as? String ?? "")
                }
                username.font = UIFont(name: "Inter-Bold", size: 18)
            }
            if let imageStr = user["thumbnailImage"] as? String, imageStr != ""{
                if let imageUrl = URL(string: imageStr) {
                    self.profileImage.load(url: imageUrl)
                }
                   // self.profileImage.image = UIImage(url: URL(string: imageStr))
            }
            
        }
        
        selectedDate = dateFormatter.string(for: Date()) ?? ""
        
        yearMonthLabel.text = dateFormatter1.string(for: Date())
        
        self.callApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadCurrentDateInCenter()
    }
    private func loadCurrentDateInCenter() {
        let day = Calendar.current.component(.weekday, from:  Date())
        switch day {
        case 1:
            calenderView.firstWeekday = 5
        case 2:
            calenderView.firstWeekday = 6
        case 3:
            calenderView.firstWeekday = 7
        case 4:
            calenderView.firstWeekday = 1
        case 5:
            calenderView.firstWeekday = 2
        case 6:
            calenderView.firstWeekday = 3
        default:
            calenderView.firstWeekday = 4
        }
    }
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        headerDescLabel.text = languageStrings[Keys.checkYourHealth] as? String
        errorLabel.text = languageStrings[Keys.noRecord] as? String
        myHealthRecordButton.setTitle(languageStrings[Keys.myHealthRecord] as? String, for: .normal)
        addButton.setTitle(languageStrings[Keys.add] as? String, for: .normal)
        detailsButton.setTitle(languageStrings[Keys.details] as? String, for: .normal)
    }
    //API Calls
    @objc func retrieveNotificationsCount(){
        
        viewModel.notificationsCount() { [self] status, message in
             
            if status {
                if let data = viewModel.home["data"] as? [String:AnyObject] {
                    if let count = data["count"] as? Int {
                        if count > 0{
                            self.notificationsCountLabel.text = String(count)
                           // self.notificationsCountLabel.isHidden = false
                            self.notificationsView.isHidden = false
                        } else {
                           // self.notificationsCountLabel.isHidden = true
                            self.notificationsView.isHidden = true
                        }
                    }
                }
                
            } else {
                self.notificationsView.isHidden = true
            }
        }
    }
    func callApi () {
        
      //  self.showProgressBar(message: "")
        
        viewModel.home(selectedDate:selectedDate) { [self] status, message in
            
          //  self.hideProgressBar()
             
            if status {
                if let data = viewModel.home["data"] as? [String : AnyObject] {
                    homeObj = data
                    self.noRecordView.isHidden = true
                    self.setRecord()
                }
                else {
                    self.noRecordView.isHidden = false
                }
            } else {
                self.noRecordView.isHidden = false
            }
            self.callContentApi()
        }
    }
    
    func setRecord(){
        if let colorString = homeObj["resultColor"] as? String, colorString != ""{
           determinationTag.backgroundColor = UIColor.init(hexString: colorString)
        }
        if let determination = homeObj["determination"] as? String{
            let determinationUppercase = determination.uppercased()
            determinationLabel.text = languageStrings[determinationUppercase] as? String
            descriptionLabel.text = languageStrings["\(determinationUppercase)_DESC" ] as? String ?? ""
        }
        
        if let dateTime = homeObj["createdAt"] as? String {
            timeLabel.text = dateTime.getTimeString()
        }
        let bpm = homeObj["averageHeartRate"]
        if let bpmValue = bpm as? NSNumber {
            bpmLabel.text = bpmValue.stringValue
        } else {
            bpmLabel.text = ""
        }
    }
    
    func callContentApi() {
        
      //  self.showProgressBar(message: "")
        let languageString = ""
       
        viewModel.content(lang: languageString.getLanguage()) { [self] status, message in
            
          //  self.hideProgressBar()
             
            if status {
                if let data = viewModel.home["data"] as? [AnyObject] {
                    bannerArr = data
                    self.pageControl.numberOfPages = bannerArr.count
                    //self.noRecordView.isHidden = true
                    self.collectionViewForHome.reloadData()
                }
                else {
                   // self.noRecordView.isHidden = false
                }
            } else {
              //  self.noRecordView.isHidden = false
            }
        }
    }
    
    @objc func handleGuideButtonDidTap(_ sender: Any) {
        if let controller = WebViewController.getObject() {
            controller.hidesBottomBarWhenPushed = true
            controller.url = UrlConfig.GUIDE
            controller.titleString =  languageStrings[Keys.support]! as? String ?? ""
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func actionForProfileButton(_ sender: Any) {
        if let controller = HealthInfoVC.getObject() {
            controller.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func actionForMyHealthRecords(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
        
       // if let navVC = self.tabBarController?.viewControllers?[3] as? UINavigationController {
         //   navVC.popToRootViewController(animated: false)
            
//            if let controller = MyRecordsVC.getObject() {
//                sel.pushViewController(controller, animated: true)
//            }
       // }
    }
    
    @IBAction func actionForDetailsButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func actionForNotification(_ sender: Any) {
        if let controller = NotificationVC.getObject() {
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @IBAction func addButton(_ sender: Any) {
        addButtonFunction()
//        self.showDeleteAlert(navController: self.navigationController ?? UINavigationController())
    }
    
//    func showDeleteAlert(navController:UINavigationController)  {
//        if let controller = CustomAlertViewController.getObject(){
//            controller.isSdkViewVisible = true
//            navController.addChild(controller)
//            controller.navigationItem.hidesBackButton = true
//            controller.view?.frame = (navController.view?.frame)!
//            controller.hidesBottomBarWhenPushed = true
//            navController.view.window?.addSubview((controller.view)!)
//            controller.dismissVCCompletion { result  in
//                if result != "Cancel" {
//                    self.openSDK(device: result ?? "1")
//                }
//            }
//        }
//    }
//    
//    func openSDK(device:String){
//        self.showProgressBar()
//        let diction = ["bundleId": AppConstants.bundleId as AnyObject, "patientMrn": "" as AnyObject, "teamId": AppConstants.teamId as AnyObject, "partnerId": AppConstants.partnerId as AnyObject]
//        viewModel.getToken(diction) { status, message in
//        if status {
//            getinitAlivecoreHome(device: device)
//        } else {
//            self.hideProgressBar()
//        }
//      }
//    }

}
extension HomeVCNew:FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       // currentDate = TimeUtils.stringFromdate(date, with: DateFormats.DD_MM_YYYY)
        selectedDate = dateFormatter.string(from: date)
        yearMonthLabel.text = dateFormatter1.string(for: date)
        self.callApi()
        
        if dateFormatter.string(from: date) != dateFormatter.string(from: Date()) {
            errorLabel.text = languageStrings[Keys.noPastRecord] as? String
            self.addButton.isHidden = true
            errorLableVerticalConstraints.constant = 0
        } else {
            errorLabel.text = languageStrings[Keys.noRecord] as? String
            self.addButton.isHidden = false
            errorLableVerticalConstraints.constant = -22.5
        }
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        let finalMonth = month < 10 ? "0\(month)" : String(month)
        let year = Calendar.current.component(.year, from: currentPageDate)
        yearMonthLabel.text = "\(year).\(finalMonth)"
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        if let minDate = Calendar.current.date(byAdding: .day, value: -10, to: Date()) {
            return minDate
        }
        return Date()
    }
    func calendar(_ calendar: FSCalendar,
                  appearance: FSCalendarAppearance,
                  fillDefaultColorFor date: Date
    ) -> UIColor? {
        if date > Date(){
            return .white
        }
        return UIColor.grayColor() // Return Default
    }
}
extension HomeVCNew:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewForHome.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.className, for: indexPath) as! HomeCollectionViewCell
        let bannerObj = bannerArr[indexPath.item]
        cell.lblForTitle.text = bannerObj["heading"] as? String
        cell.btnForSubTitle.setTitle(bannerObj["subHeading"] as? String, for: .normal)
        cell.btnForSubTitle.addTarget(self, action: #selector(handleGuideButtonDidTap), for: .touchUpInside)
        if let imageStr = bannerObj["image"] as? String, imageStr != ""{
            if let imageUrl = URL(string: imageStr) {
                cell.bannerImage.load(url: imageUrl)
            }
               // self.profileImage.image = UIImage(url: URL(string: imageStr))
        }
        //pageControl.currentPage = indexPath.item
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 40, height: 71)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
   
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        pageControl.currentPage = indexPath.item
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            let pageWidth = self.collectionViewForHome.frame.size.width
            pageControl.currentPage = Int(self.collectionViewForHome.contentOffset.x / pageWidth)
        }
    
    
}

//extension HomeVCNew {
//    
//    //MARK: - Initializaion ECG SDK
//    
//    func getinitAlivecore(device:String) {
//        ACKManager.initWithApiKey(viewModel.jwtToken, isDebugMode: true) { error, config in
//            if let config = config {
//                print(config)
//        
//                DispatchQueue.main.async {
//            
//                    var configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.card, leadsConfig: .single, filterType: .original, algorithmPackage: "", error: nil)
//                
//                    if device == "2"{
//                        configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.triangle, leadsConfig: .six, filterType: .original, algorithmPackage: "", error: nil)
//                    }
//                    else if device == "3"{
//                        configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.mobile, leadsConfig: .single, filterType: .original, algorithmPackage: "", error: nil)
//                    }
//                    
//                    Global.saveDataInUserDefaults(value: device as AnyObject, key: .device)
//                    Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//
////                    if Global.getDataFromUserDefaults(.device) != nil {
////                        let deviceTypeRaw = Global.getDataFromUserDefaults(.device) as? String ?? ""
////                        let deviceType = ACKDeviceType(rawValue: deviceTypeRaw)
////                        
////                        let leadsConfigRaw = Global.getDataFromUserDefaults(.leadConfig) as? Int ?? 0
////                        let leadsConfig = ACKLeadsConfig(rawValue: leadsConfigRaw)
////                        
////                        configg = ACKEcgRecordingConfig.init(deviceType: deviceType, leadsConfig: leadsConfig ?? .single, filterType: .enhanced, algorithmPackage: "", error: nil)
////                    } else {
////                        Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
////                        Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
////                    }
//                    
//                    self.hideProgressBar()
//                    if let config1 = configg {
//                        if let monitorViewController = ACKEcgMonitorViewController(config: config1, delegate: self) {
//                           // monitorViewController.delegate = self
//                            let newController = UINavigationController(rootViewController: monitorViewController)
//                            newController.modalPresentationStyle = .overFullScreen
//                            
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
//extension HomeVCNew: ACKEcgMonitorDelegate {
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

