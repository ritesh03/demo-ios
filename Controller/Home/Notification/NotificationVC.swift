//
//  NotificationVC.swift
//  synex
//
//  Created by Subhash Mehta on 02/04/24.
//

import UIKit

class NotificationVC: BaseVC {
    //MARK: - getObject method
    class func getObject() -> NotificationVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: NotificationVC.className) as? NotificationVC{
            return controller
        }
        return nil
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnForTitle: UIButton!
    @IBOutlet weak var lblForNotice: UILabel!
    
    let viewModel = HomeViewModel()
    var languageStrings = [String:AnyObject]()
    var notificationsArray = [AnyObject]()
    var currentPage = 1
    var totalPages = 1
    var pageSize = 20
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        languageStringConvert()
        callApi()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        lblForNotice.text = languageStrings[Keys.newNotice]! as? String
//        errorLabel.text = languageStrings[Keys.noRecord]! as? String
//        myHealthRecordButton.setTitle(languageStrings[Keys.myHealthRecord] as? String, for: .normal)
//        addButton.setTitle(languageStrings[Keys.add] as? String, for: .normal)
        btnForTitle.setTitle(languageStrings[Keys.noticeBoard] as? String, for: .normal)
    }
    
    func callApi() {
        let diction = ["page":self.currentPage, "size":self.pageSize] as [String : AnyObject]
        print(diction)
        
      //  self.showProgressBar(message: "")
        
        viewModel.notifications(parameters: diction) { [self] status, message in
            
      //   self.hideProgressBar()
             
            if status {
                if currentPage == 1{
                    self.notificationsArray.removeAll()
                }
                if let totalPages = viewModel.home["totalPages"] {
                    self.totalPages = totalPages as! Int
                }
                if let dataArray = viewModel.home["data"] as? [AnyObject] {
                    self.notificationsArray.append(contentsOf: dataArray)
                if notificationsArray.count > 0 {
                    tableView.isHidden = false
                   // self.errorLabel.isHidden = true
                } else {
                    //self.errorLabel.isHidden = false
                    tableView.isHidden = true
                }
              }
                self.tableView.reloadData()
            } else {
//                self.showAlert(title: (languageStrings[message] as? String)!, message: nil, buttonText: languageStrings[Keys.ok] as? String)
            }
          }
    }
    
    @objc func loadData() {
        // Make network call to fetch data for currentPage
        currentPage += 1
        callApi()
    }

    
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTVC.className, for: indexPath) as! NotificationTVC
        cell.selectionStyle = .none
        let notificationObj = notificationsArray[indexPath.row]
        cell.lblForName.text = notificationObj["message"] as? String
//        cell.lblForName.text = "\(notificationObj["title"] as? String ?? "")\n\(notificationObj["message"] as? String ?? "")"
        let dateTime = notificationObj["createdAt"] as? String
        
        let timeString = dateTime?.getTimeString()
        if let dateFromString = dateTime?.getDate() {
            if Calendar.current.isDateInToday(dateFromString){
                cell.lblForSubTitle.text = languageStrings[Keys.today]! as? String
            }
            else if Calendar.current.isDateInYesterday(dateFromString){
                cell.lblForSubTitle.text = languageStrings[Keys.yesterday]! as? String
            }
            else{
                if let dateStr = dateTime?.changeFormat(), dateStr != ""{
                    let newDateStr = dateStr.replace(target: "-", withString:".")
                    cell.lblForSubTitle.text = newDateStr
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == notificationsArray.count - 1, currentPage < totalPages {
                loadData()
            }
   }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

