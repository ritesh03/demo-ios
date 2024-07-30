//
//  FiltersViewController.swift
//  synex
//
//  Created by Ritesh on 15/03/23.
//

import UIKit
import TagListView
protocol DelegateSelectedFilters {
    func delegateSelectedFilters(starred:Bool?,determination:[String]?,fromDate: String, toDate: String)
    //func delegateCancel()
}

class FiltersViewController: BaseVC {
    
    //MARK: - getObject method
    class func getObject() -> FiltersViewController?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: FiltersViewController.className) as? FiltersViewController{
            return controller
        }
        return nil
    }

    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var starredButton: UIButton!
    @IBOutlet weak var starredLabel: UILabel!
    @IBOutlet weak var determinationLabel: UILabel!
    
    var determination = [String]()
    var selectedDetermination = [String]()
    var selectedDeterminationTemp = [String]()
    var delegate: DelegateSelectedFilters?
    var fromString = "YYYY.MM.DD"
    var toString = "YYYY.MM.DD"
    var languageStrings = [String:AnyObject]()
    var isStarred = false
    
    
    //UIVIEW LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        //Determination Array
        var languageString = ""
        if languageString.getLanguage() == "ko"{
            self.determination = [DeterminationKeysKr.Normal,DeterminationKeysKr.Bradycardia,DeterminationKeysKr.Tachycardia,DeterminationKeysKr.Afib,DeterminationKeysKr.Unclassified,DeterminationKeysKr.Unreadable,DeterminationKeysKr.Short]
        } else {
            self.determination = [DeterminationKeys.Normal,DeterminationKeys.Bradycardia,DeterminationKeys.Tachycardia,DeterminationKeys.Afib,DeterminationKeys.Unclassified,DeterminationKeys.Unreadable,DeterminationKeys.Short]
        }
        
        self.selectedDetermination = self.selectedDeterminationTemp
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.filtersTableView.reloadData()
        }
        self.initialSetup()
    }
   
    private func initialSetup() {
        // Do any additional setup after loading the view.
        languageStrings = Global.readStrings()
        if self.fromString != "" {
            fromButton.setTitle(self.fromString, for: .normal)
            fromButton.setTitleColor(.black, for: .normal)
        }
        if self.toString != "" {
            toButton.setTitle(self.toString, for: .normal)
            toButton.setTitleColor(.black, for: .normal)
        }
        self.starredButton.setImage(isStarred == true ? UIImage(named: "check_onn") : UIImage(named: "check_off"), for: .normal)
        starredLabel.text = languageStrings[Keys.starredResult] as? String
        dateLabel.text = languageStrings[Keys.selectDate] as? String
        determinationLabel.text = languageStrings[Keys.selectResult] as? String
        resetButton.setTitle(languageStrings[Keys.reset] as? String, for: .normal)
        applyButton.setTitle(languageStrings[Keys.apply] as? String, for: .normal)
        
    }
    
    private func dismissView(selection:String) {
        self.view.removeFromSuperview()
        self.view.window?.removeFromSuperview()
        removeFromParent()
    }
    
    @IBAction func actionForCross(_ sender: Any) {
        self.dismissView(selection: "")
    }
    @IBAction func starredButtonAction(_ sender: UIButton) {
        if  isStarred == true {
            self.starredButton.setImage(UIImage(named: "check_off"), for: .normal)
            isStarred = false
        }else{
            self.starredButton.setImage(UIImage(named: "check_onn"), for: .normal)
            isStarred = true
        }
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        selectedDetermination = []
        fromButton.setTitle("YYYY.MM.DD", for: .normal)
        fromButton.setTitleColor(.lightGray, for: .normal)
        toButton.setTitle("YYYY.MM.DD", for: .normal)
        toButton.setTitleColor(.lightGray, for: .normal)
        fromString = ""
        toString = ""
        starredButton.setImage(UIImage(named: "check_off"), for: .normal)
        isStarred = false
        self.filtersTableView.reloadData()
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        delegate?.delegateSelectedFilters(starred: isStarred, determination: self.selectedDetermination,fromDate: self.fromString, toDate: self.toString)
        self.dismissView(selection: "")
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fromButtonAction(_ sender: Any) {
        self.showDate(navController: self.navigationController ?? UINavigationController(), isFrom: true)
//        let calendarVC = CalendarViewController.instantiate(fromAppStoryboard: .Home)
//            calendarVC.modalPresentationStyle = .overCurrentContext
//            calendarVC.delegate = self
//            calendarVC.isFromString = true
//            calendarVC.fromString = fromString
//            calendarVC.toString = toString
//            self.navigationController?.present(calendarVC, animated: true, completion: nil)
    }
    
    func showDate(navController:UINavigationController,isFrom:Bool)  {
        if let controller = CalendarViewController.getObject(){
            controller.delegate = self
            controller.isFromString = isFrom
            controller.fromString = fromString
            controller.toString = toString
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
    
    @IBAction func toButtonAction(_ sender: UIButton) {
        if fromString != "" {
            self.showDate(navController: self.navigationController ?? UINavigationController(), isFrom: false)
      }
}

}
extension FiltersViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
    
        cell.tagListView.tagLineBreakMode = .byWordWrapping
        cell.tagListView.paddingX = 20
        cell.tagListView.paddingY = 12
        cell.tagListView.marginX = 12
        cell.tagListView.marginY = 20
        cell.tagListView.delegate = self
        cell.tagListView.removeAllTags()
        cell.tagListView.addTags(determination)
        for value in cell.tagListView.tagViews {
            if selectedDetermination.contains(value.titleLabel?.text ?? "")  {
                value.isSelected = true
            } else {
                value.isSelected = false
            }
        }
        cell.tagListView.textFont = UIFont(name: "Inter-SemiBold", size: 14) ?? .systemFont(ofSize: 14)
        cell.tagListView.alignment = .left
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedValue = self.determination[indexPath.row]
//        if selectedDetermination.contains(selectedValue){
//            if let index = selectedDetermination.firstIndex(of: selectedValue) {
//                self.selectedDetermination.remove(at: index)
//            }
//        } else{
//            self.selectedDetermination.append(selectedValue)
//        }
//        self.filtersTableView.reloadData()
    }
    
}
//MARK::- DELEGATES FILTER HANDLING

extension FiltersViewController : DelegateGetSelectedDate {
    func getSelectedDate(fromDate: String, toDate: String) {
        if fromDate != "" {
            fromString = fromDate
            let fromStr = fromString.replace(target: "-", withString:".")
            fromButton.setTitle(fromStr, for: .normal)
            fromButton.setTitleColor(.black, for: .normal)
        }
        
        if toDate != "" {
            toString = toDate
            let toStr = toString.replace(target: "-", withString:".")
            toButton.setTitle(toStr, for: .normal)
            toButton.setTitleColor(.black, for: .normal)
        }
    }
}

extension FiltersViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        let titleIndex = determination.firstIndex(of: title)
        if selectedDetermination.contains(title){
            if let index = selectedDetermination.firstIndex(of: title) {
                self.selectedDetermination.remove(at: index)
            }
        } else{
            self.selectedDetermination.append(title)
        }
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}
