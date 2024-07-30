//
//  HistoryVC.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit
import PDFKit

class HistoryVC: BaseVC {
    
    //MARK: - getObject method
    class func getObject() -> HistoryVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: HistoryVC.className) as? HistoryVC{
            return controller
        }
        return nil
    }
    
    @IBOutlet weak var lblForSearchTitle: UILabel!
    @IBOutlet weak var viewForTop: UIView!
    //MARK: - outlets
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var btnForTitle: UIButton!
    @IBOutlet weak var btnForSearch: UIButton!
    //MARK: - Variable
    let viewModel = HistoryViewModel()
    var historyArray = [AnyObject]()
    var sectionArray = [String]()
    var rowArray = [AnyObject]()
    var pdfPath = ""
    var selectedDeterminations = [String]()
    var selectedDeterminationsTemp = [String]()
    var fromDate = AppConfig.empty
    var toDate = AppConfig.empty
    var isStarred = false
    var comeFromSideMenu = false
    var languageStrings = [String:AnyObject]()
    var sectionRowDict = [String:AnyObject]()
    var currentPage = 1
    var totalPages = 1
    var pageSize = 20
    var isSearch = false
    var selectedIndexPath: IndexPath?
   // let refreshControl = UIRefreshControl()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
//        tableView.refreshControl = refreshControl
        tableView.isHidden = true
        lblForSearchTitle.isHidden = true
        viewForTop.isHidden = false
        registerCell()
        customizeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
      //  customizeUI()
    }
    
    //MARK: - Private Function
    private func customizeUI() {
      languageStringConvert()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
      //  setNavigation(title: languageStrings[Keys.history] as? String ?? AppConfig.empty,showBack: comeFromSideMenu ? false : true,showMenuButton: comeFromSideMenu ? true : false)
        searchTextfield.placeholder = languageStrings[Keys.search] as? String
        titleLabel.text = languageStrings[Keys.searchPast] as? String
        self.descriptionLabel.text = languageStrings[Keys.searchFilter] as? String
        self.errorLabel.isHidden = true
      //  descriptionLabel.text = languageStrings[Keys.personalReport] as? String
        btnForTitle.setTitle(languageStrings[Keys.searchRecord] as? String, for: .normal)

    }
    
    //MARK: - registerCell
    func registerCell() {
        tableView.registerTableCell(identifier: CellIdentifier.historyCell)
        tableView.registerTableCell(identifier: "SearchTVC")
    }
    
    @objc func loadData() {
        // Make network call to fetch data for currentPage
        currentPage += 1
      //  refreshControl.endRefreshing()
        callHistoryApi()
    }
    
    //MARK: - Actions
    @IBAction func actionForSearch(_ sender: Any) {
        if searchTextfield.hasText {
            searchTextfield.text = ""
            currentPage = 1
            self.callHistoryApi()
        }
    }
    @IBAction func actionForCross(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterButton(_ sender: UIButton) {

        self.showFilter(navController: self.navigationController ?? UINavigationController())
        }
    func showFilter(navController:UINavigationController)  {
        if let controller = FiltersViewController.getObject(){
            controller.delegate = self
            controller.selectedDeterminationTemp = self.selectedDeterminationsTemp
            controller.fromString = self.fromDate
            controller.toString = self.toDate
            controller.isStarred = self.isStarred
            navController.addChild(controller)
            controller.navigationItem.hidesBackButton = true
            controller.view?.frame = (navController.view?.frame)!
            controller.hidesBottomBarWhenPushed = true
            navController.view.window?.addSubview((controller.view)!)
//            controller.dismissVCCompletion { result  in
//                self.redirectToHome()
//            }
        }
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        
    }
    
    func callHistoryApi () {
        let determinationString = (self.selectedDeterminations.map{String($0)}.joined(separator: ","))
        let diction = ["isFavourite":isStarred,"determination": determinationString,"startDate":fromDate,"endDate":toDate,"search":searchTextfield.text ?? "","page":self.currentPage, "size":self.pageSize] as [String : AnyObject]
        print(diction)
        
       // self.showProgressBar(message: "")
        
        viewModel.history(parameters: diction) { [self] status, message in
            
         //   self.hideProgressBar()
             
            if status {
                if currentPage == 1{
                    sectionArray.removeAll()
                    rowArray.removeAll()
                    sectionRowDict.removeAll()
                }
                if let totalPages = viewModel.history["totalPages"] {
                    self.totalPages = totalPages as! Int
                }
                if let dataArray = viewModel.history["data"] as? [AnyObject] {
                    self.historyArray = dataArray
                if historyArray.count > 0 {
                    viewForTop.isHidden = true
                    tableView.isHidden = false
                    self.createSectionArray()
                    if isSearch{
                        self.lblForSearchTitle.isHidden = false
                        let languageString = ""
                        if languageString.getLanguage() == "ko"{
                            self.lblForSearchTitle.text = (self.searchTextfield.text ?? "") + " " + (languageStrings[Keys.resultOf] as? String ?? "")
                        } else {
                            self.lblForSearchTitle.text = (languageStrings[Keys.resultOf] as? String ?? "") + " " + (self.searchTextfield.text ?? "")
                        }
                        
                    }
                   // self.errorLabel.isHidden = true
                } else {
                    viewForTop.isHidden = false
                    self.lblForSearchTitle.isHidden = true
                    //self.errorLabel.isHidden = false
                    tableView.isHidden = true
                }
              }
                self.tableView.reloadData()
            } else {
//                self.showAlert(title: (languageStrings[Keys.invalidCredentials] as? String)!, message: nil, buttonText: languageStrings[Keys.ok] as? String)
            }
          }
    }
    
    func createSectionArray(){
        //Create Section Header
        for i in 0..<historyArray.count{
            let recordObj = historyArray[i]
            let dateTime = recordObj["createdAt"] as? String
            let dateString = dateTime?.getDateString() as? String
            if !sectionArray.contains(dateString) {
               // code here
                sectionArray.append(dateString!)
            }
        }
        //Create Rows in each section Header
        for i in 0..<sectionArray.count{
            var rows = [AnyObject]()
            for j in 0..<historyArray.count{
                let recordObj = historyArray[j]
                let dateTime = recordObj["createdAt"] as? String
                let dateString = dateTime?.getDateString() as? String
                if sectionArray[i] == dateString {
                    rows.append(recordObj)
                }
            }
            if rows.count > 0 {
                if let items = sectionRowDict[sectionArray[i]]  {
                    sectionRowDict[sectionArray[i]] = items as! Array<AnyObject> + rows as AnyObject
                }
                else {
                    sectionRowDict[sectionArray[i]] = rows as AnyObject
                }
            }
        }
    }
    
    func openPDFView() {
        if let pdfVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewController") as? PDFViewController {
            pdfVC.pdfPath = self.pdfPath
            self.navigationController?.pushViewController(pdfVC)
        }
    }
}

//MARK: - tableView Delegate
extension HistoryVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionArray[section]
        if let rows = sectionRowDict[sectionTitle] {
            return rows.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTVC = tableView.dequeueReusableCell(withIdentifier: SearchTVC.className) as! SearchTVC
        
        let sectionTitle = sectionArray[indexPath.section]
        rowArray = sectionRowDict[sectionTitle] as! [AnyObject]
    
        let recordObj = rowArray[indexPath.row]
        
        let dateTime = recordObj["createdAt"] as? String
        let timeString = dateTime?.getTimeString()
        cell.lblForTime.text = timeString ?? ""
        
        if let dateStr = dateTime?.changeFormat(), dateStr != ""{
            let newDateStr = dateStr.replace(target: "-", withString:".")
            cell.lblForDate.text = newDateStr
        }
       
       
        let bpm = recordObj["averageHeartRate"]
        if let bpmValue = bpm as? NSNumber {
            cell.lblForHeartRate.text = bpmValue.stringValue
        } else {
            cell.lblForHeartRate.text = ""
        }
        cell.lblForBPM.text = (bpm != nil) ? "BPM" :""
        let determination = recordObj["determination"] as? String
        cell.lblForDescription.text = languageStrings[determination ?? ""] as? String
        
//        let pdfLead = recordObj["pdfLead"] as? Int
//
//        let leadText = languageStrings[Keys.pdfLead] as? String ?? "L"
    
       // cell.lblForDescription.text = recordObj["algorithmResultDescription"] as? String ?? ""
        cell.btnForfavorite.setImage(recordObj["isFavourite"] as? Bool == true ? UIImage(named: "bookmark") : UIImage(named: "bookmark_dis"), for: .normal)
        cell.btnForfavorite.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
        cell.btnForCheckRecord.addTarget(self, action: #selector(graphButtonAction), for: .touchUpInside)
        cell.btnForCheckRecord.setTitle(languageStrings[Keys.checkRecord] as? String, for: .normal)
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if indexPath.section == sectionArray.count - 1{
             if indexPath.row == rowArray.count - 1, currentPage < totalPages {
                 loadData()
             }
         }
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 48))
        let mainView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.width - 40, height: 48))
        mainView.cornerRadius = 8
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.backgroundColor = UIColor(named: "buttonColor")
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: mainView.size.width, height: 48))
        sectionLabel.text = sectionArray[section]
        sectionLabel.textAlignment = .center
        sectionLabel.textColor = UIColor.white
        sectionLabel.font = UIFont.CustomFont.medium.fontWithSize(size: 13)
        mainView.addSubview(sectionLabel)
        headerView.addSubview(mainView)
        return UIView()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let sectionTitle = sectionArray[indexPath.section]
//        var rows = sectionRowDict[sectionTitle] as! [AnyObject]
//
//        if let path = rows[indexPath.row]["pdfFileUrl"] as? String{
//            self.pdfPath = path
//            self.openPDFView()
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    @objc func graphButtonAction(sender:UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        selectedIndexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        let sectionTitle = sectionArray[selectedIndexPath!.section]
        let rows = sectionRowDict[sectionTitle] as! [AnyObject]
        let recordObj = rows[selectedIndexPath!.row]
        
        if let path = recordObj["pdfFileUrl"] as? String{
            self.pdfPath = path
            self.openPDFView()
        }
    }
    
    @objc func favButtonAction(sender:UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        selectedIndexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        let sectionTitle = sectionArray[selectedIndexPath!.section]
        var rows = sectionRowDict[sectionTitle] as! [AnyObject]
        let recordObj = rows[selectedIndexPath!.row]
        
        if let favId = recordObj["_id"] as? String{
            self.callFavApi(favId: favId)
        }
    }
    
    @objc func emailButtonAction(sender:UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        let sectionTitle = sectionArray[indexPath!.section]
        let rows = sectionRowDict[sectionTitle] as! [AnyObject]
        
        if let path = rows[indexPath!.row]["pdfFileUrl"] as? String{
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
        var existingRows = [AnyObject]()
        if  let items = sectionRowDict[sectionArray[selectedIndexPath!.section]]{
            existingRows = items as! [AnyObject]
            existingRows[selectedIndexPath!.row] = viewModel.favDict as AnyObject
            sectionRowDict[sectionArray[selectedIndexPath!.section]] = existingRows as AnyObject
        }
        
        let sectionTitle = sectionArray[selectedIndexPath!.section]
        var rows = sectionRowDict[sectionTitle] as! [AnyObject]
        let recordObj = rows[selectedIndexPath!.row]
        
        let cell = tableView.cellForRow(at: IndexPath(row: selectedIndexPath!.row, section: selectedIndexPath!.section)) as! SearchTVC
        cell.btnForfavorite.setImage(recordObj["isFavourite"] as? String == "true" ? UIImage(named: "bookmark") : UIImage(named: "bookmark_dis"), for: .normal)
        let indexPosition = IndexPath(row: selectedIndexPath!.row, section: selectedIndexPath!.section)
        tableView.reloadRows(at: [indexPosition], with: .none)
    }
}

//MARK: - DELEGATES FILTER HANDLING

extension HistoryVC : DelegateSelectedFilters {
    func delegateSelectedFilters(starred: Bool?, determination: [String]?,fromDate: String, toDate: String) {
        self.isStarred = starred ?? false
        self.fromDate = fromDate
        self.toDate = toDate
        self.selectedDeterminationsTemp = determination ?? []
        self.selectedDeterminations = []
        for i in 0..<determination!.count{
            if determination![i] == DeterminationKeys.Normal || determination![i] == DeterminationKeysKr.Normal  {
                self.selectedDeterminations.append(Determination.Normal)
            }
            if determination![i] == DeterminationKeys.Afib || determination![i] == DeterminationKeysKr.Afib {
                self.selectedDeterminations.append(Determination.Afib)
            }
            if determination![i] == DeterminationKeys.Unclassified || determination![i] == DeterminationKeysKr.Unclassified {
                self.selectedDeterminations.append(Determination.Unclassified)
            }
            if determination![i] == DeterminationKeys.Tachycardia || determination![i] == DeterminationKeysKr.Tachycardia {
                self.selectedDeterminations.append(Determination.Tachycardia)
            }
            if determination![i] == DeterminationKeys.Bradycardia || determination![i] == DeterminationKeysKr.Bradycardia {
                self.selectedDeterminations.append(Determination.Bradycardia)
            }
            if determination![i] == DeterminationKeys.Short || determination![i] == DeterminationKeysKr.Short {
                self.selectedDeterminations.append(Determination.Short)
            }
            if determination![i] == DeterminationKeys.Long || determination![i] == DeterminationKeysKr.Long {
                self.selectedDeterminations.append(Determination.Long)
            }
            if determination![i] == DeterminationKeys.Unreadable || determination![i] == DeterminationKeysKr.Unreadable {
                self.selectedDeterminations.append(Determination.Unreadable)
            }
            if determination![i] == DeterminationKeys.NoAnalysis || determination![i] == DeterminationKeysKr.NoAnalysis {
                self.selectedDeterminations.append(Determination.NoAnalysis)
            }
        }
    
        if determination!.count > 0 || isStarred {
            self.callHistoryApi()
        }
        else if fromDate != "" && toDate != ""{
            self.callHistoryApi()
        }
        else {
            viewForTop.isHidden = false
            tableView.isHidden = true
            lblForSearchTitle.isHidden = true
        }
    }
}

extension Array {
     func contains<T>(_ object: T) -> Bool where T: Equatable {
         !self.filter {$0 as? T == object }.isEmpty
     }
 }

extension HistoryVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == searchTextfield
            {
//                if textField.hasText {
//                    btnForSearch.isSelected = true
//                } else {
//                    btnForSearch.isSelected = false
//                }
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
                if newString.count == 0{
                    isSearch = false
                    lblForSearchTitle.isHidden = true
                    if selectedDeterminations.count > 0 || isStarred {
                        self.callHistoryApi()
                    }
                    else if fromDate != "" && toDate != ""{
                        self.callHistoryApi()
                    }
                    else {
                        viewForTop.isHidden = false
                        tableView.isHidden = true
                    }
                } else {
                    isSearch = true
                    currentPage = 1
                    self.callHistoryApi()
                }
            }
            return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            isSearch = false
            lblForSearchTitle.isHidden = true
            if selectedDeterminations.count > 0 || isStarred {
                self.callHistoryApi()
            }
            else if fromDate != "" && toDate != ""{
                self.callHistoryApi()
            }
            else {
                viewForTop.isHidden = false
                tableView.isHidden = true
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            isSearch = false
            lblForSearchTitle.isHidden = true
            if selectedDeterminations.count > 0 || isStarred {
                self.callHistoryApi()
            }
            else if fromDate != "" && toDate != ""{
                self.callHistoryApi()
            }
            else {
                viewForTop.isHidden = false
                tableView.isHidden = true
            }
        }
            textField.resignFirstResponder()
            return true
        }
}
