//
//  MyRecordsVC.swift
//  synex
//
//  Created by Subhash Mehta on 16/03/24.
//

import UIKit
import FSCalendar
import AliveCorKitLite

class MyRecordsVC: BaseVC {
    //MARK: - getObject method
    class func getObject() -> MyRecordsVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: MyRecordsVC.className) as? MyRecordsVC{
            return controller
        }
        return nil
    }
    
    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var btnForSearch: UIButton!
    @IBOutlet weak var tblViewMyRecords: UITableView!

    
    private var selectedDate = Date()
    var currentDate:String = ""
    var languageStrings = [String:AnyObject]()
    var currentPage = 1
    var totalPages = 1
    var pageSize = 10
    var selectedIndexPath: IndexPath?
    let viewModel = HistoryViewModel()
    var recordsArray = [AnyObject]()
    var datesArray = [String]()
    var pdfPath = ""
    var isCalledInmonthChange:Bool = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.hidesBottomBarWhenPushed  = false
        self.tblViewMyRecords.reloadData()
        languageStringConvert()
        currentPage = 1
        currentDate = dateFormatter.string(for: Date()) ?? ""
        self.selectedDate = Date()
        self.recordsArray.removeAll()
        getRecords()
    }
    
    private func getRecords() {
        callHistoryApi(date: currentDate)
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
//        lblForTitle.text = languageStrings[Keys.myHealthRecord]! as? String
        btnForBack.setTitle(languageStrings[Keys.myHealthRecord] as? String, for: .normal)
    }
    
    @IBAction func actionForBack(_ sender: Any) {
      // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionForSearch(_ sender: Any) {
        if let controller = HistoryVC.getObject() {
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func loadData() {
        // Make network call to fetch data for currentPage
        currentPage += 1
        callHistoryApi(date: currentDate)
    }
    
    func callHistoryApi (date:String) {
        let diction = ["startDate":date,"endDate":date,"page":self.currentPage, "size":self.pageSize] as [String : AnyObject]
        print(diction)
        
        // self.showProgressBar(message: "")
        
        viewModel.history(parameters: diction) { [self] status, message in
            
          //  self.hideProgressBar()
            
            if status {
                if isCalledInmonthChange == false {
                    if let totalPages = viewModel.history["totalPages"] {
                        self.totalPages = totalPages as? Int ?? 1
                    }
                    if let dataArray = viewModel.history["data"] as? [AnyObject] {
                        self.recordsArray.append(contentsOf: dataArray)
                        if let dateArrayVa = viewModel.history["dates"] as? [String] {
                            self.datesArray = dateArrayVa
                        }
                    }
                    self.tblViewMyRecords.reloadData()
                } else {
                    if let dataArray = viewModel.history["data"] as? [AnyObject] {
                        if let dateArrayVa = viewModel.history["dates"] as? [String] {
                            self.datesArray = dateArrayVa
                            let cell  = self.tblViewMyRecords.cellForRow(at: IndexPath(row: 0, section: 0)) as! MyRecordsCallenderTVC
                            //cell.calenderForRequest.dataSource = self
                            //cell.calenderForRequest.delegate = self
                            cell.calenderForRequest.reloadData()
                        }
                    }
                }
               
                
            } else {
                //                self.showAlert(title: (languageStrings[Keys.invalidCredentials] as? String)!, message: nil, buttonText: languageStrings[Keys.ok] as? String)
            }
        }
    }
    func callFavApi(favId:String?) {
        
      //  self.showProgressBar(message: "")
        
        viewModel.favorite(favId: favId) { [self] status, message in
            
          //  self.hideProgressBar()
             
            if status {
                updateObject()
            }
        }
    }
    
    func updateObject(){
        
        recordsArray[selectedIndexPath!.row] = viewModel.favDict as AnyObject
        
        let recordObj = recordsArray[selectedIndexPath!.row]
        
        let cell = tblViewMyRecords.cellForRow(at: IndexPath(row: selectedIndexPath!.row, section: selectedIndexPath!.section)) as! MyRecordsTVC
        cell.starredImage.image = recordObj["isFavourite"] as? Int  == 1 ? UIImage(named: "Star_on") : UIImage(named: "Star_off")
        let indexPosition = IndexPath(row: selectedIndexPath!.row, section: selectedIndexPath!.section)
        tblViewMyRecords.reloadRows(at: [indexPosition], with: .none)
    }
    
    func updateNoteAPI(notes:String?){
        let diction = ["ecgId":AppInstance.shared.ecgID,"notes":notes] as [String : AnyObject]
        print(diction)
        viewModel.updateNote(parameters: diction) { [self] status, message in
            if status {
                if let indexPath = AppInstance.shared.selectedIndexPath?.row {
                    self.recordsArray[indexPath] = viewModel.favDict as AnyObject
                }
            
            }
        }
    }
}
extension MyRecordsVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : recordsArray.count == 0 ? 1 : recordsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {//Calendar Section
            let cell = tblViewMyRecords.dequeueReusableCell(withIdentifier: MyRecordsCallenderTVC.className, for: indexPath) as! MyRecordsCallenderTVC
            cell.selectionStyle = .none
            
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.day = 0
            let nextDate:Date = calendar.date(byAdding: dateComponents, to: self.selectedDate ) ?? Date()
           // cell.calenderForRequest.locale =  Locale(identifier:  AppInstance.shared.user?.default_language ?? "")
            let language = ""
            cell.calenderForRequest.appearance.headerMinimumDissolvedAlpha = 0
            cell.calenderForRequest.locale = Locale.init(identifier: language.getLanguage())
            cell.calenderForRequest.select(nextDate)
            cell.calenderForRequest.dataSource = self
            cell.calenderForRequest.delegate = self
            cell.calenderForRequest.appearance.headerTitleColor = .black
            cell.calenderForRequest.appearance.headerDateFormat = "yyyy.MM"
            cell.calenderForRequest.placeholderType = .none
            cell.calenderForRequest.reloadData()
           // cell.btnForNext.addTarget(self, action: #selector(monthForthButtonPressed(_:)), for: .touchUpInside)
           // cell.btnForPre.addTarget(self, action: #selector(monthBackButtonPressed(_:)), for: .touchUpInside)
            return cell
        } else {
            if recordsArray.count > 0 {
                let cell = tblViewMyRecords.dequeueReusableCell(withIdentifier: MyRecordsTVC.className, for: indexPath) as! MyRecordsTVC
                
                let recordObj = recordsArray[indexPath.row]
                let dateTime = recordObj["createdAt"] as? String
                let timeString = dateTime?.getTimeString()
                cell.lblForTime.text = timeString ?? ""
            
                let determination = recordObj["determination"] as? String
                print(determination!.uppercased())
                if let colorString = recordObj["resultColor"] as? String, colorString != ""{
                    let dotColor = UIColor.init(hexString: colorString)
                    cell.viewForStatus.backgroundColor = dotColor
                    cell.titleView.backgroundColor = dotColor.withAlphaComponent(0.2)
                }
                let determinationUppercase = determination!.uppercased()
                cell.lblForTitle.text = languageStrings[determinationUppercase] as? String
               
                let bpm = recordObj["averageHeartRate"]
                if let bpmValue = bpm as? NSNumber {
                    cell.lblForHeartRateValue.text = bpmValue.stringValue
                } else {
                    cell.lblForHeartRateValue.text = ""
                }
                cell.lblForBPM.text = (bpm != nil) ? "BPM" :""
            
                cell.lblForDescription.text = languageStrings["\(determinationUppercase)_DESC"] as? String ?? ""
                cell.starredImage.image = recordObj["isFavourite"] as? Int  == 1 ? UIImage(named: "Star_on") : UIImage(named: "Star_off")
                cell.lblForStar.text = languageStrings[Keys.starred] as? String
                cell.btnForStar.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
                cell.lblForShare.text = languageStrings[Keys.sharePDF] as? String
                cell.btnForShare.addTarget(self, action: #selector(emailButtonAction), for: .touchUpInside)
                cell.btnForCheckRecord.setTitle(languageStrings[Keys.checkRecord] as? String, for: .normal)
                cell.btnForCheckRecord.addTarget(self, action: #selector(graphButtonAction), for: .touchUpInside)
                cell.lblForNotes.text = languageStrings[Keys.addMemo] as? String
                cell.btnForNotes.addTarget(self, action: #selector(notesButtonAction), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tblViewMyRecords.dequeueReusableCell(withIdentifier: NoDataCell.className, for: indexPath) as! NoDataCell
                if dateFormatter.string(from: selectedDate) != dateFormatter.string(from: Date()) {
                    cell.errorLabel.text = languageStrings[Keys.noPastRecord] as? String
                    cell.addButton.isHidden = true
                } else {
                    cell.errorLabel.text = languageStrings[Keys.noRecord] as? String
                    cell.addButton.isHidden = false
                }
                cell.addButton.setTitle(languageStrings[Keys.add] as? String, for: .normal)
                cell.addButton.addTarget(self, action: #selector(self.addButton(_:)), for: .touchUpInside)
                return cell
            }
        }
        
       
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section == 1{
//            if indexPath.row == recordsArray.count - 1, currentPage < totalPages {
//                loadData()
//            }
//        }
//   }
    
    @objc func addButton(_ sender: UIButton) {
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
//                    self.openSDK(device: result ?? "")
//                }
//            }
//        }
//    }
//    
//    func openSDK(device:String){
//        self.showProgressBar()
//        
//        let diction = ["bundleId": AppConstants.bundleId as AnyObject, "patientMrn": "" as AnyObject, "teamId": AppConstants.teamId as AnyObject, "partnerId": AppConstants.partnerId as AnyObject]
//        viewModel.getToken(diction) { status, message in
//        if status {
//            self.getinitAlivecore(device: device)
//        } else {
//            self.hideProgressBar()
//        }
//    }
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? UITableView.automaticDimension : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tblViewMyRecords.dequeueReusableCell(withIdentifier: MyRecordHeaderTVC.className) as! MyRecordHeaderTVC
        cell.btnForRecords.setTitle("\(languageStrings[Keys.records] as? String ?? "") ", for: .normal)
        cell.btnForRecords.addTarget(self, action: #selector(handleRecordsButtonDidTap), for: .touchUpInside)
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == recordsArray.count - 1, currentPage < totalPages {
                loadData()
            }
   }
    
    @objc func monthForthButtonPressed(_ sender: Any) {
            
        self.moveCurrentPage(moveUp: false)
    }
        
    @objc func monthBackButtonPressed(_ sender: Any) {
            
        self.moveCurrentPage(moveUp: true)
    }

    @objc func handleRecordsButtonDidTap(_ sender: Any) {
        let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.isHome = true
        vc.titleString = ""
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func favButtonAction(sender:UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblViewMyRecords)
        selectedIndexPath = self.tblViewMyRecords.indexPathForRow(at: buttonPosition)
        let recordObj = recordsArray[selectedIndexPath!.row]
        if let favId = recordObj["_id"] as? String{
            self.callFavApi(favId: favId)
        }
    }
    
    @objc func emailButtonAction(sender:UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblViewMyRecords)
        selectedIndexPath = self.tblViewMyRecords.indexPathForRow(at: buttonPosition)
        
        if let path = recordsArray[selectedIndexPath!.row]["pdfFileUrl"] as? String{
            self.pdfPath = path
            self.showProgressBar(message: "")
            let pdfUrl = URL(string: path)
            let pdfView = PDFView()
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: pdfUrl!), let document = PDFDocument(data: data) {
                           DispatchQueue.main.async {
                               self.hideProgressBar()
                               pdfView.displayMode = .singlePageContinuous
                               pdfView.autoScales = true
                               pdfView.displayDirection = .vertical
                               pdfView.document = document
                               guard let pdfDocument = pdfView.document?.dataRepresentation() else { return }
                               let activityViewController = UIActivityViewController(activityItems: [pdfDocument], applicationActivities: nil)
                               self.present(activityViewController, animated: true)
                        }
                   }
             }
        }
    }
    
    @objc func graphButtonAction(sender:UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblViewMyRecords)
        selectedIndexPath = self.tblViewMyRecords.indexPathForRow(at: buttonPosition)
        
        let recordObj = recordsArray[selectedIndexPath!.row]
        
        if let path = recordObj["pdfFileUrl"] as? String{
            self.pdfPath = path
            self.openPDFView()
        }
    }
    
    func openPDFView() {
        if let pdfVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewController") as? PDFViewController {
            pdfVC.pdfPath = self.pdfPath
            self.navigationController?.pushViewController(pdfVC)
        }
    }
    
    @objc func notesButtonAction(sender:UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblViewMyRecords)
        selectedIndexPath = self.tblViewMyRecords.indexPathForRow(at: buttonPosition)
        AppInstance.shared.selectedIndexPath = selectedIndexPath
        let recordObj = recordsArray[selectedIndexPath!.row]
        AppInstance.shared.ecgID =  recordObj["_id"] as? String
        let vc = AddMemoViewController.instantiate(fromAppStoryboard: .Home)
        vc.delegate = self
        if let note = recordObj["notes"] as? String{
            vc.note =  note
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
   
    
    private func moveCurrentPage(moveUp: Bool) {
        let cell = tblViewMyRecords.cellForRow(at: IndexPath(row: 0, section: 0)) as! MyRecordsCallenderTVC
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? -1 : selectedDate < Date() ? 1 : 0
        
        self.selectedDate = calendar.date(byAdding: dateComponents, to: self.selectedDate ) ?? Date()
        currentDate = dateFormatter.string(from: selectedDate)
       
        cell.calenderForRequest.setCurrentPage(self.selectedDate, animated: true)
    }
    
}
extension MyRecordsVC:FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage

        let month = Calendar.current.component(.month, from: currentPageDate)
        let year = Calendar.current.component(.year, from: currentPageDate)
        //"yyyy-MM-dd"
        let finalMonth = month < 10 ? "0\(month)" : String(month)
        let callingDate = "\(year)-\(finalMonth)-01"
        isCalledInmonthChange = true
        callHistoryApi(date: callingDate)
        print(month)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        isCalledInmonthChange = false
        selectedDate = date
        currentPage = 1
        recordsArray.removeAll()
        currentDate = dateFormatter.string(from: selectedDate)
        getRecords()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesArray.contains(dateString) {
            return UIImage(named: "event")
        }
        return nil
    }
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let dateString = self.dateFormatter2.string(from: date)
//        if self.datesArray.contains(dateString) {
//            return 1
//        }
//        return 0
//    }
//    
//    private func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
//            return UIColor.red
//    }
}

//extension MyRecordsVC {
//    
//    //MARK: - Initializaion ECG SDK
//    
//    func getinitAlivecore(device:String) {
//        ACKManager.initWithApiKey(viewModel.jwtToken, isDebugMode: true) { error, config in
//            if let config = config {
//                print(config)
//                
//                DispatchQueue.main.async {
//                    var configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.card, leadsConfig: .single, filterType: .original,  algorithmPackage: "", error: nil)
//                
//                    if device == "2"{
//                        configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.triangle, leadsConfig: .six, filterType: .original, algorithmPackage: "", error: nil)
//                    }
//                    else if device == "3"{
//                        configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.mobile, leadsConfig: .single, filterType: .original,  algorithmPackage: "", error: nil)
//                    }
//                    
//                    Global.saveDataInUserDefaults(value: device as AnyObject, key: .device)
//                    Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
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
extension MyRecordsVC : DelegateNote {
    func delegateNote(note: String) {
        self.updateNoteAPI(notes: note)
    }
}
