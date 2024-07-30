//
//  HospitalVC.swift
//  synex
//
//  Created by Subhash Mehta on 16/03/24.
//

import UIKit
import SDWebImage

class HospitalVC: BaseVC {
    
    //MARK: - getObject method
    class func getObject() -> HospitalVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: HospitalVC.className) as? HospitalVC{
            return controller
        }
        return nil
    }
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var btnForSearch: UIButton!
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblForHospitalRegister: UILabel!
    @IBOutlet weak var btnForDelete: UIButton!
    @IBOutlet weak var viewForSearch: UIView!
    @IBOutlet weak var txtFieldForSearch: UITextField!
    @IBOutlet weak var btnForRegister: UIButton!
    @IBOutlet weak var viewForNoData: UIView!
    @IBOutlet weak var lblForNoHospital: UILabel!
    @IBOutlet weak var lblForHospitalHeader: UILabel!
    @IBOutlet weak var tblViewForHospital: UITableView!
    
    //MARK: - Variable
    let viewModel = HomeViewModel()
    var languageStrings = [String:AnyObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialSetup()
        languageStringConvert()
        callApi()
    }
    
    private func initialSetup(){
        heightConstraints.constant = 126
        viewForSearch.isHidden = false
        btnForRegister.isEnabled = false
        btnForRegister.alpha = 0.5
        tblViewForHospital.isHidden = true
        viewForNoData.isHidden = false
        self.btnForDelete.isHidden = true
    }
    
    private func setupAfterLinking(){
        heightConstraints.constant = 65
        viewForSearch.isHidden = true
        self.txtFieldForSearch.text = ""
        lblForHospitalRegister.text = languageStrings[Keys.hospitalCodeLinked]! as? String
        self.btnForDelete.isHidden = false
        self.viewForNoData.isHidden = true
        self.tblViewForHospital.isHidden = false
        self.tblViewForHospital.reloadData()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        lblForTitle.text = languageStrings[Keys.hospital]! as? String
        lblForHospitalRegister.text = languageStrings[Keys.hospitalCodeReg]! as? String
        lblForHospitalHeader.text = languageStrings[Keys.registeredHospital]! as? String
        lblForNoHospital.text = languageStrings[Keys.noRegisteredHospital]! as? String
        btnForRegister.setTitle(languageStrings[Keys.register] as? String, for: .normal)
        btnForDelete.setTitle(languageStrings[Keys.delete] as? String, for: .normal)
        txtFieldForSearch.placeholder = languageStrings[Keys.enterHospitalCode] as? String
    }
    
    func callApi() {
        
        self.showProgressBar(message: "")
        
        viewModel.hospital{ [self] status, message in
            
            self.hideProgressBar()
             
            if status {
                if let data = viewModel.home["data"] as? [String : AnyObject] {
                    if let name = data["name"] as? String {
                        setupAfterLinking()
                    } else {
                        initialSetup()
                    }
                }
            } else {
                self.viewForNoData.isHidden = false
                self.tblViewForHospital.isHidden = true
            }
          }
    }
    
    func registerHospitalAPI() {
        let diction = ["uniqueCode": txtFieldForSearch.text ?? ""] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.registerHospital(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                self.callApi()
            } else {
                self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
        }
    }

    
    @IBAction func actionForSearch(_ sender: UIButton) {
//        if !sender.isSelected {
//            sender.isSelected = !sender.isSelected
//            heightConstraints.constant = 126
//            viewForSearch.isHidden = false
//        } else {
//            sender.isSelected = !sender.isSelected
//            heightConstraints.constant = 65
//            viewForSearch.isHidden = true
//        }
        
    }
    @IBAction func actionForRegister(_ sender: Any) {
        self.view.endEditing(true)
        if !txtFieldForSearch.text.optionalValue().isEmpty {
            self.registerHospitalAPI()
        }
    }
    
    @IBAction func actionForDelete(_ sender: Any) {
        self.view.endEditing(true)
        self.showDeleteAlert(navController: self.navigationController ?? UINavigationController())
    }
    func showDeleteAlert(navController:UINavigationController)  {
        if let controller = CustomAlertViewController.getObject(){
            controller.isSdkViewVisible = false
            navController.addChild(controller)
            controller.navigationItem.hidesBackButton = true
            controller.view?.frame = (navController.view?.frame)!
            controller.hidesBottomBarWhenPushed = true
            navController.view.window?.addSubview((controller.view)!)
            controller.dismissVCCompletion { result  in
                    //Call Delete Api
                if result != "Cancel" {
                    self.registerHospitalAPI()
                }
            }
        }
    }
    
}
extension HospitalVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewForHospital.dequeueReusableCell(withIdentifier: HospitalTVC.className, for: indexPath) as! HospitalTVC
        cell.selectionStyle = .none
        let data = viewModel.home["data"] as? [String : AnyObject]
        cell.lblForTitla.text = data?["name"] as? String ?? ""
        cell.lblForSubTitle.text = data?["address"] as? String ?? ""
        cell.imgForHospital.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgForHospital.sd_setImage(with: URL(string: ("\(data?["profileImage"] as? String ?? "")")), placeholderImage:UIImage(named: "default"))
        return cell
    }
}
extension HospitalVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        if newString.count > 0 {
            btnForRegister.alpha = 1.0
            btnForRegister.isEnabled = true
        } else {
            btnForRegister.alpha = 0.5
            btnForRegister.isEnabled = false
        }
        return true
    }
}

