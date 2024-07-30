//
//  HealthDetailsVC.swift
//  synex
//
//  Created by Subhash Mehta on 13/03/24.
//

import UIKit
import DropDown

class HealthDetailsVC: BaseVC {
    //MARK: - getObject method
    class func getObject() -> HealthDetailsVC?{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: HealthDetailsVC.className) as? HealthDetailsVC{
            return controller
        }
        return nil
    }
    @IBOutlet weak var viewForTransLucent: UIView!
    @IBOutlet weak var btnForCancel: UIButton!
    @IBOutlet weak var btnForDone: UIButton!
    
        //MARK: - outlets
        
        @IBOutlet weak var confirmButton: UIButton!
        @IBOutlet weak var generTitle: UILabel!
        @IBOutlet weak var userInformationTitle: UILabel!
        @IBOutlet weak var maleButton: UIButton!
        @IBOutlet weak var femaleButton: UIButton!
        @IBOutlet weak var heightTextfield: UITextField!
        @IBOutlet weak var heightLabel: UILabel!
        @IBOutlet weak var weightTextfield: UITextField!
        @IBOutlet weak var weightLabel: UILabel!
        @IBOutlet weak var skipLineView: UIView!
        
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewForPicker: UIView!
    var isHeightSelected:Bool = false
    
    //MARK: - Variable
        let viewModel = LoginViewModel()
        var languageStrings = [String:AnyObject]()
        var comeFromSideMenu = false
        var gender = 0
        var arrForHeight = [String]()
        var arrForWeight = [String]()
    
        //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let intHeight = 500
        for i in 30...intHeight {
            arrForHeight.append(String(i))
        }
        let intWeight = 500
        for i in 1...intWeight {
            arrForWeight.append(String(i))
        }
        
        confirmButton.backgroundColor = UIColor(hexString: "#DCDFE3")
        confirmButton.isEnabled = false
        [heightTextfield,weightTextfield].forEach {
            $0?.addTarget(self,
                          action: #selector(editingChanged(_:)),
                          for: .allEvents)
        }
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
            customizeUI()
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        
        // Trim whitespace and newlines
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

            guard
              let height = heightTextfield.text, !height.isEmpty,
              let weight = weightTextfield.text, !weight.isEmpty
              else
                {
              return
            }
            // enable okButton if all conditions are met
        if gender > 0 {
            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = UIColor.greenColor()
        }
    }
        
        
        //MARK: - private function
      private func customizeUI() {
          setNavigation(title: AppConfig.empty,showBack: comeFromSideMenu ? false : true,showMenuButton: comeFromSideMenu ? true : false)
          self.navigationController?.navigationBar.backgroundColor = UIColor.clear
          languageStringConvert()
          if comeFromSideMenu {
              skipLineView.isHidden = true
              
          }
          pickerView.showsSelectionIndicator = true
          pickerView.delegate = self
          pickerView.dataSource = self
          pickerView.reloadAllComponents()
        //  getProfileApi ()
        setValues()
    
    }
        
        //MARK: - languageConvert
        func languageStringConvert() {
            languageStrings = Global.readStrings()
            userInformationTitle.text = languageStrings[Keys.enterHealthInfo] as? String
            generTitle.text = languageStrings[Keys.gender] as? String
            maleButton.setTitle(languageStrings[Keys.male] as? String, for: .normal)
            femaleButton.setTitle(languageStrings[Keys.female] as? String, for: .normal)
            heightLabel.text = languageStrings[Keys.height] as? String
            heightTextfield.placeholder = languageStrings[Keys.enterYourInformation] as? String
            weightLabel.text = languageStrings[Keys.weightTitle] as? String
            weightTextfield.placeholder = languageStrings[Keys.enterYourInformation] as? String
            confirmButton.setTitle(languageStrings[Keys.signIn] as? String, for: .normal)
            btnForCancel.setTitle(languageStrings[Keys.cancel] as? String, for: .normal)
            btnForDone.setTitle(languageStrings[Keys.select] as? String, for: .normal)
      }
      
    func setValues(){
            if  let user = Global.getDataFromUserDefaults(.userData) {
                if let userGender = AppInstance.shared.kakaoUserGender {
                        if userGender == "female" {
                            femaleButton.backgroundColor = UIColor.themeColor()
                            maleButton.backgroundColor = UIColor(hexString: "#DCDFE3")
                            gender = 2
                        } else {
                            maleButton.backgroundColor = UIColor.themeColor()
                            femaleButton.backgroundColor = UIColor(hexString: "#DCDFE3")
                            gender = 1
                        }
                    }
                else{
                    if user["gender"] as? Int == 2 {
                        femaleButton.backgroundColor = UIColor.themeColor()
                        maleButton.backgroundColor = UIColor(hexString: "#DCDFE3")
                        gender = 2
                    } else {
                        maleButton.backgroundColor = UIColor.themeColor()
                        femaleButton.backgroundColor = UIColor(hexString: "#DCDFE3")
                        gender = 1
                    }
                }
                if let userHeight = user["height"] as? String{
                    heightTextfield.text = userHeight
                }
                if let userWeight = user["weight"] as? String{
                    weightTextfield.text = userWeight
                }
                guard
                  let height = heightTextfield.text, !height.isEmpty,
                  let weight = weightTextfield.text, !weight.isEmpty
                  else
                    {
                  return
                }
                self.confirmButton.isEnabled = true
                self.confirmButton.backgroundColor = UIColor.greenColor()
            }
    }

        //MARK: - Actions
        @IBAction func genderButtonAction(_ sender: UIButton) {
            if sender.tag == 0 {
                maleButton.backgroundColor = UIColor.themeColor()
                femaleButton.backgroundColor = UIColor(hexString: "#DCDFE3")
               // maleButton.setTitleColor(UIColor.white, for: .normal)
               // maleButton.titleLabel?.font = UIFont.CustomFont.extraBold.fontWithSize(size: 15)
                
               // femaleButton.setTitleColor(UIColor(named: "brown"), for: .normal)
                //femaleButton.titleLabel?.font = UIFont.CustomFont.medium.fontWithSize(size: 15)
            }else{
               // femaleButton.titleLabel?.font = UIFont.CustomFont.extraBold.fontWithSize(size: 15)
                femaleButton.backgroundColor = UIColor.themeColor()
                maleButton.backgroundColor = UIColor(hexString: "#DCDFE3")
              //  maleButton.setTitleColor(UIColor.white, for: .normal)
              //  maleButton.titleLabel?.font = UIFont.CustomFont.medium.fontWithSize(size: 15)
            }
            gender = sender.tag + 1
//            if !heightTextfield.isEmpty && !weightTextfield.isEmpty {
//                self.confirmButton.isEnabled = true
//                self.confirmButton.backgroundColor = UIColor.greenColor()
//            }
            self.editingChanged(UITextField())
        }
    @IBAction func actionForHeight(_ sender: UIButton) {
        isHeightSelected = true
        viewForPicker.isHidden = false
        pickerView.selectRow(135, inComponent: 0, animated: true)
        viewForTransLucent.isHidden = false
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        viewForPicker.isHidden = true
        viewForTransLucent.isHidden = true
    }
    @IBAction func doneAction(_ sender: Any) {
        viewForTransLucent.isHidden = true
        viewForPicker.isHidden = true
        let row = self.pickerView.selectedRow(inComponent: 0)
                self.pickerView.selectRow(row, inComponent: 0, animated: false)
        if isHeightSelected {
            self.heightTextfield.text = self.arrForHeight[row]
        }else {
            self.weightTextfield.text = self.arrForWeight[row]
        }
        self.editingChanged(UITextField())
    }
    
    @IBAction func actionForWeight(_ sender: UIButton) {
        isHeightSelected = false
        viewForPicker.isHidden = false
        pickerView.selectRow(49, inComponent: 0, animated: true)
        viewForTransLucent.isHidden = false
    }
    
       
        @IBAction func confirmButtonAction(_ sender: UIButton) {
            self.view.endEditing(true)
//            if heightTextfield.text.optionalValue().isEmpty {
//                self.showAlert(title: languageStrings[Keys.fullNameRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
//                return
//            }
//            else if weightTextfield.text.optionalValue().isEmpty {
//                self.showAlert(title: languageStrings[Keys.phoneNumberRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
//                return
//            }
    //        else if dobTextfield.text.optionalValue().isEmpty {
    //            self.showAlert(title: languageStrings[Keys.dobRequired] as? String, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
    //            return
    //        }
            self.callApi()
        }

        
        func getProfileApi () {
            
            self.showProgressBar(message: "")
            
            viewModel.getProfile() { [self] status, message in
                self.hideProgressBar()
                if status {
                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                }
              }
        }
        
        func callApi() {
            if !heightTextfield.text.optionalValue().isEmpty && !weightTextfield.text.optionalValue().isEmpty  {
                let diction = ["gender": gender, "height": heightTextfield.text ?? "", "weight": weightTextfield.text ?? "", "step": ProfileCompletionSteps.step2] as [String : AnyObject]
            
            self.showProgressBar(message: "")
            
            viewModel.userInfo(parameters: diction) { [self] status, message in
                
                self.hideProgressBar()
                
                if status {
//                    if var dict = Global.getDataFromUserDefaults(.userData) as? [String:AnyObject] {
//                        dict["step"] = 2 as AnyObject
//                        Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
//                        AppInstance.shared.userDict = dict
//                    }
                    if AppInstance.shared.step == 2 && AppInstance.shared.isTermsAccepted == false {
                        self.showTerm(navController: self.navigationController ?? UINavigationController())
                    } else {
                        self.navigationController?.navigationBar.isHidden = true
                        self.navigationController?.isNavigationBarHidden = true
                        self.redirectToHome()
                    }
                   // self.showAlert(title: (languageStrings[Keys.profileSuccess] as? String)!, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
                   // self.showToast((languageStrings[Keys.profileSuccess] as? String)!)
                   
                  // self.appDelegate?.navigateToHome()
                } else {
                    self.showAlert(title: (languageStrings[message] as? String)!, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
                }
              }
           }
        }

        
        func callDeleteAccountApi() {
            
            self.showProgressBar(message: "")
            
            viewModel.deleteAccount() { [self] status, message in
                
                self.hideProgressBar()
                
                if status {
                    self.goToLogin()
                } else {
                    self.showAlert(title: "Network error!", message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
                }
            }
        }
    }

extension HealthDetailsVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  isHeightSelected ? self.arrForHeight.count : self.arrForWeight.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return isHeightSelected ? self.arrForHeight[row] : self.arrForWeight[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isHeightSelected {
            self.heightTextfield.text = self.arrForHeight[row]
        }else {
            self.weightTextfield.text = self.arrForWeight[row]
        }
        self.editingChanged(UITextField())
    }
}



