//
//  TermVC.swift
//  synex
//
//  Created by Subhash Mehta on 15/03/24.
//

import UIKit

class TermVC: BaseVC {
    //MARK: - getObject method
    class func getObject() -> TermVC?{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: TermVC.className) as? TermVC{
            return controller
        }
        return nil
    }
    
    typealias typeCompletionHandler = (String?) -> ()
    var complition : typeCompletionHandler = { _  in }
    func dismissVCCompletion(_ completionHandler: @escaping typeCompletionHandler) {
        self.complition = completionHandler
    }
    
    @IBOutlet weak var lblForTermTitle: UILabel!
    @IBOutlet weak var btnForONOff1: UIButton!
    @IBOutlet weak var lblForTerm1: UILabel!
    
    @IBOutlet weak var btnForONOff2: UIButton!
    @IBOutlet weak var lblForTerm2: UILabel!
    
    @IBOutlet weak var btnForONOff3: UIButton!
    @IBOutlet weak var lblForTerm3: UILabel!
    
    @IBOutlet weak var btnForONOff4: UIButton!
    @IBOutlet weak var lblForTerm4: UILabel!
    @IBOutlet weak var btnForConfirm: UIButton!
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnForConfirm.backgroundColor = UIColor(hexString: "#CCD1D3")
        btnForConfirm.isEnabled = false
        languageStringConvert()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        lblForTermTitle.text = languageStrings[Keys.termsConditions]! as? String
        lblForTerm1.text = languageStrings[Keys.agreeToAllItems]! as? String
        lblForTerm2.text = languageStrings[Keys.termsOfService]! as? String
        lblForTerm3.text = languageStrings[Keys.collectionAndUse]! as? String
        lblForTerm4.text = languageStrings[Keys.marketingInformation]! as? String
        btnForConfirm.setTitle(languageStrings[Keys.confirm] as? String, for: .normal)
  }
    
    @IBAction func actionForOnOff1(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            btnForONOff1.isSelected = !btnForONOff1.isSelected
            btnForONOff2.isSelected = btnForONOff1.isSelected
            btnForONOff3.isSelected = btnForONOff1.isSelected
            btnForONOff4.isSelected = btnForONOff1.isSelected
        case 1:
            btnForONOff2.isSelected = !btnForONOff2.isSelected
        case 2:
            btnForONOff3.isSelected = !btnForONOff3.isSelected
        default:
            btnForONOff4.isSelected = !btnForONOff4.isSelected
        }
        if  btnForONOff2.isSelected &&  btnForONOff3.isSelected {
            btnForConfirm.backgroundColor = UIColor.greenColor()
            btnForConfirm.isEnabled = true
        }else {
            btnForConfirm.backgroundColor = UIColor(hexString: "#CCD1D3")
            btnForConfirm.isEnabled = false
        }
    }
    @IBAction func actionForForward(_ sender: UIButton) {
        if sender.tag == 1 {
              let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
              vc.isTerms = true
              vc.hideNavigationBar()
              self.navigationController?.pushViewController(vc, animated: true)
            } else if sender.tag == 2{
              let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
              vc.isPrivacy = true
              vc.hideNavigationBar()
              self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
              let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
              vc.isMarketing = true
              vc.hideNavigationBar()
              self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    
    @IBAction func actionForConfirm(_ sender: Any) {
        if btnForONOff2.isSelected && btnForONOff3.isSelected   {
            self.callAPI()
        }
    }
    
    func callAPI(){
        
        let diction = ["isTermsAccepted": true] as [String : AnyObject]
        
        viewModel.acceptTerms(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                let value = 1
                Global.saveDataInUserDefaults(value: value as AnyObject, key: .terms)
                self.dismissView(selection: "")
            } else {
                self.showAlert(title: (languageStrings[message] as? String ?? ""), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
    }
    
    private func dismissView(selection:String) {
        self.view.removeFromSuperview()
        self.view.window?.removeFromSuperview()
        removeFromParent()
        complition(selection)
    }
    
   
}
