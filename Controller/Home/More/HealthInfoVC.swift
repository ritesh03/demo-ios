//
//  HealthDetailsVC.swift
//  synex
//
//  Created by Subhash Mehta on 13/03/24.
//

import UIKit
import DropDown

class HealthInfoVC: BaseVC, PickerDelegate {
    //MARK: - getObject method
    class func getObject() -> HealthInfoVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: HealthInfoVC.className) as? HealthInfoVC{
            return controller
        }
        return nil
    }
    
    //MARK: - outlets
    @IBOutlet weak var viewForTranslucent: UIView!
    @IBOutlet weak var userProfile: UIImageView!
        @IBOutlet weak var dobTextfield: UITextField!
        @IBOutlet weak var dobTitle: UILabel!
        @IBOutlet weak var confirmButton: UIButton!
        @IBOutlet weak var generTitle: UILabel!
        @IBOutlet weak var userInformationTitle: UILabel!
        @IBOutlet weak var maleButton: UIButton!
        @IBOutlet weak var femaleButton: UIButton!
        @IBOutlet weak var heightTextfield: UITextField!
        @IBOutlet weak var heightLabel: UILabel!
        @IBOutlet weak var weightTextfield: UITextField!
        @IBOutlet weak var weightLabel: UILabel!
        @IBOutlet weak var registeredHospitalTextfield: UITextField!
        @IBOutlet weak var registeredHospitalLabel: UILabel!
        @IBOutlet weak var btnForDelete: UIButton!
        @IBOutlet weak var pickerView: UIPickerView!
        @IBOutlet weak var viewForPicker: UIView!
    @IBOutlet weak var btnForCancel: UIButton!
    @IBOutlet weak var btnForDone: UIButton!
    
    //MARK: - Variable
        let viewModel = LoginViewModel()
        let homeViewModel = HomeViewModel()
        var languageStrings = [String:AnyObject]()
        var gender = 0
        var arrForHeight = [String]()
        var arrForWeight = [String]()
        var isHeightSelected:Bool = false
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerDelegate = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
            customizeUI()
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        
//        // Trim whitespace and newlines
//        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//
//            guard
//              let height = heightTextfield.text, !height.isEmpty,
//              let weight = weightTextfield.text, !weight.isEmpty
//              else
//                {
//              return
//            }
//            // enable okButton if all conditions are met
//        if gender > 0 {
//            self.confirmButton.isEnabled = true
//            self.confirmButton.backgroundColor = UIColor.greenColor()
//        }
        self.confirmButton.isEnabled = true
        self.confirmButton.backgroundColor = UIColor.greenColor()
        
    }
        
        
        //MARK: - private function
      private func customizeUI() {
          let intHeight = 500
          for i in 30...intHeight {
              arrForHeight.append(String(i))
          }
          let intWeight = 500
          for i in 1...intHeight {
              arrForWeight.append(String(i))
          }
          [heightTextfield,weightTextfield].forEach {
              $0?.addTarget(self,
                            action: #selector(editingChanged(_:)),
                            for: .allEvents)
          }
          confirmButton.backgroundColor = UIColor(hexString: "#DCDFE3")
          confirmButton.isEnabled = false
          pickerView.showsSelectionIndicator = true
          pickerView.delegate = self
          pickerView.dataSource = self
          pickerView.reloadAllComponents()
          
          languageStringConvert()
          getProfileApi()
    }
    func didSelectDate(date: Date) {
        self.editingChanged(UITextField())
    }
    //MARK: - languageConvert
    func languageStringConvert() {
            languageStrings = Global.readStrings()
            userInformationTitle.text = languageStrings[Keys.healthInformation] as? String
            dobTitle.text = languageStrings[Keys.dob] as? String
            generTitle.text = languageStrings[Keys.gender] as? String
            maleButton.setTitle(languageStrings[Keys.male] as? String, for: .normal)
            femaleButton.setTitle(languageStrings[Keys.female] as? String, for: .normal)
            heightLabel.text = languageStrings[Keys.height] as? String
            heightTextfield.placeholder = languageStrings[Keys.enterYourInformation] as? String
            weightLabel.text = languageStrings[Keys.weightTitle] as? String
            weightTextfield.placeholder = languageStrings[Keys.enterYourInformation] as? String
            registeredHospitalLabel.text = languageStrings[Keys.registeredHospital] as? String
            registeredHospitalTextfield.placeholder = languageStrings[Keys.noRegisteredHospital] as? String
            btnForDelete.setTitle(languageStrings[Keys.delete] as? String, for: .normal)
            confirmButton.setTitle(languageStrings[Keys.save] as? String, for: .normal)
    }
      
    func setValues(){
        if  let user = Global.getDataFromUserDefaults(.userData) {
            if let userDob = user["dateOfBirth"] as? String{
                
                let newDobStr = userDob.changeFormatKakaoDob().replace(target: "/", withString:".")
                dobTextfield.text = newDobStr
            }
            if user["gender"] as? Int == 2 {
                femaleButton.backgroundColor = UIColor.themeColor()
                maleButton.backgroundColor = UIColor.grayColor()
            } else {
                maleButton.backgroundColor = UIColor.themeColor()
                femaleButton.backgroundColor = UIColor.grayColor()
            }
            if let userHeight = user["height"] as? String{
                heightTextfield.text = userHeight
            }
            if let userWeight = user["weight"] as? String{
                weightTextfield.text = userWeight
            }
            if let hospital = user["uniqueCode"] as? String{
                registeredHospitalTextfield.text = hospital
                btnForDelete.isHidden = false
            }
            if let imageStr = user["thumbnailImage"] as? String, imageStr != ""{
                if let imageUrl = URL(string: imageStr) {
                    self.userProfile.load(url: imageUrl)
                }
            }
        }
    }
    //MARK: - Actions
    @IBAction func actionForCross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionForDelete(_ sender: Any) {
        deleteHospitalAPI()
    }
    
    @IBAction func genderButtonAction(_ sender: UIButton) {
            if sender.tag == 0 {
                maleButton.backgroundColor = UIColor.themeColor()
                femaleButton.backgroundColor = UIColor.grayColor()
            }else{
                femaleButton.backgroundColor = UIColor.themeColor()
                maleButton.backgroundColor = UIColor.grayColor()
            }
            gender = sender.tag + 1

            self.editingChanged(UITextField())
    }
    
    @IBAction func actionForHeight(_ sender: UIButton) {
        isHeightSelected = true
        viewForPicker.isHidden = false
        pickerView.selectRow(135, inComponent: 0, animated: true)
        viewForTranslucent.isHidden = false
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        viewForPicker.isHidden = true
        viewForTranslucent.isHidden = true
    }
    
    @IBAction func doneAction(_ sender: Any) {
        viewForTranslucent.isHidden = true
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
        viewForTranslucent.isHidden = false
    }
    
       
    @IBAction func confirmButtonAction(_ sender: UIButton) {
            self.view.endEditing(true)
        self.showCustomAlert(message: languageStrings[Keys.saveChanges] as? String,cancelButtonTitle: languageStrings[Keys.cancel] as? String,doneButtonTitle: languageStrings[Keys.confirm] as? String, doneCallback:  {
            self.callApi()
        })
    }

        
    func getProfileApi() {
            
            self.showProgressBar(message: "")
            
            viewModel.getProfile() { [self] status, message in
                self.hideProgressBar()
                if status {
                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                    setValues()
                }
              }
        }
        
    func callApi() {
            if !dobTextfield.text.optionalValue().isEmpty && !heightTextfield.text.optionalValue().isEmpty && !weightTextfield.text.optionalValue().isEmpty  {
                let dobStr = dobTextfield.text!.replace(target: ".", withString:"/")
            let diction = ["dateOfBirth": dobStr,"gender": gender, "height": heightTextfield.text ?? "", "weight": weightTextfield.text ?? "", "step": ProfileCompletionSteps.step1] as [String : AnyObject]
            
            self.showProgressBar(message: "")
            
            viewModel.userAccountInfo(parameters: diction) { [self] status, message in
                
                self.hideProgressBar()
                
                if status {
                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                    setValues()
                    self.showCustomAlert(message: languageStrings[Keys.changesSaved] as? String,cancelButtonTitle: "",doneButtonTitle: languageStrings[Keys.confirm] as? String, doneCallback:  {
                    })
                } else {
                    self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
                }
              }
           }
        }
    
    func deleteHospitalAPI() {
        let diction = ["uniqueCode": ""] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        homeViewModel.registerHospital(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                registeredHospitalTextfield.text = ""
                btnForDelete.isHidden = true
                self.getProfileApi()
            } else {
                self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
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

extension HealthInfoVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isHeightSelected ? self.arrForHeight.count : self.arrForWeight.count
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
        
    }
}

extension HealthInfoVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dobTextfield {
            
            setDatePicker(textField: textField, datePickerMode: .date, maximunDate: Date(), minimumDate: nil)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
      
        if textField == registeredHospitalTextfield {
//            guard range.location == 0 else {
//                return true
//            }

            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
            if newString.count > 0 {
                btnForDelete.isHidden = false
                self.editingChanged(UITextField())
            } else {
                btnForDelete.isHidden = true
            }
            return true
        }
        return true
    }
}
extension HealthInfoVC:DelegateGetSelectedDate {
    func getSelectedDate(fromDate: String, toDate: String) {
        dobTextfield.text = toDate
    }
}
