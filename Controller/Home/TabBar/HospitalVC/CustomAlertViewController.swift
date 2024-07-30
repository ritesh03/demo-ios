//
//  CustomAlertViewController.swift
//
//

import UIKit

class CustomAlertViewController: BaseViewController {

    // MARK: - Constants
    //MARK: - getObject method
    class func getObject() -> CustomAlertViewController?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: CustomAlertViewController.className) as? CustomAlertViewController{
            return controller
        }
        return nil
    }
    @IBOutlet weak var lblFortitle: UILabel!
    @IBOutlet weak var viewForDouble: UIView!
    @IBOutlet weak var lblForDoubleDesc: UILabel!
    @IBOutlet weak var btnForDoubleOkay: UIButton!
    @IBOutlet weak var btnForCancel: UIButton!
    @IBOutlet weak var viewForSDK: UIView!
    @IBOutlet weak var lblForSdkTitle: UILabel!
    @IBOutlet weak var btnForSdkCOnfirm: UIButton!
    @IBOutlet weak var btnForSdkCancel: UIButton!
    @IBOutlet weak var viewForDeviceOne: UIView!
    @IBOutlet weak var lblForDeviceOne: UILabel!
    @IBOutlet weak var viewForDevice2: UIView!
    @IBOutlet weak var lblForDevice2: UILabel!
    @IBOutlet weak var viewForDevice3: UIView!
    @IBOutlet weak var lblForDevice3: UILabel!
    @IBOutlet weak var btnForDevice1: UIButton!
    @IBOutlet weak var btnForDevice2: UIButton!
    @IBOutlet weak var btnForDevice3: UIButton!
    
    typealias typeCompletionHandler = (String?) -> ()
    var complition : typeCompletionHandler = { _  in }
    func dismissVCCompletion(_ completionHandler: @escaping typeCompletionHandler) {
        self.complition = completionHandler
    }
    var strForDesc:String = ""
    var isSdkViewVisible:Bool = true
    var callBackString = "Okay"
    var languageStrings = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSdkViewVisible {
            viewForDouble.isHidden = true
            viewForSDK.isHidden = false
            selectedDevice()

        } else {
            viewForDouble.isHidden = false
            viewForSDK.isHidden = true
        }
        languageStringConvert()
    }
    
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        lblFortitle.text = languageStrings[Keys.deleteHospital]! as? String
        lblForDoubleDesc.text = languageStrings[Keys.deleteDesc]! as? String
        btnForSdkCOnfirm.setTitle(languageStrings[Keys.confirm] as? String, for: .normal)
        btnForSdkCancel.setTitle(languageStrings[Keys.cancel] as? String, for: .normal)
        btnForDoubleOkay.setTitle(languageStrings[Keys.confirm] as? String, for: .normal)
        btnForCancel.setTitle(languageStrings[Keys.cancel] as? String, for: .normal)
        lblForSdkTitle.text = languageStrings[Keys.selectDevice]! as? String
        lblForDeviceOne.text = languageStrings[Keys.kardiaMobile6]! as? String
        lblForDevice2.text =  languageStrings[Keys.kardiaMobile1]! as? String
        lblForDevice3.text =  languageStrings[Keys.kardiaCard]! as? String
    }
    
    func selectedDevice(){
        if Global.getDataFromUserDefaults(.device) != nil {
            let deviceType = Global.getDataFromUserDefaults(.device) as? String ?? ""
            callBackString = deviceType
        }
        if callBackString == "3"{
            btnForDevice1.isSelected = false
            viewForDeviceOne.backgroundColor = .white
            lblForDeviceOne.textColor = UIColor(hexString: "#282829")
            btnForDevice2.isSelected = true
            viewForDevice2.backgroundColor = UIColor(hexString: "#FF601A")
            lblForDevice2.textColor = .white
            btnForDevice3.isSelected = false
            viewForDevice3.backgroundColor = .white
            lblForDevice3.textColor = UIColor(hexString: "#282829")
        }
        else if callBackString == "1"{
            btnForDevice1.isSelected = false
            viewForDeviceOne.backgroundColor = .white
            lblForDeviceOne.textColor = UIColor(hexString: "#282829")
            btnForDevice2.isSelected = false
            viewForDevice2.backgroundColor = .white
            lblForDevice2.textColor = UIColor(hexString: "#282829")
            btnForDevice3.isSelected = true
            viewForDevice3.backgroundColor = UIColor(hexString: "#FF601A")
            lblForDevice3.textColor = .white
        } else {
            callBackString = "2"
            btnForDevice1.isSelected = true
            viewForDeviceOne.backgroundColor = UIColor(hexString: "#FF601A")
            lblForDeviceOne.textColor = .white
            btnForDevice2.isSelected = false
            viewForDevice2.backgroundColor = .white
            lblForDevice2.textColor = UIColor(hexString: "#282829")
            btnForDevice3.isSelected = false
            viewForDevice3.backgroundColor = .white
            lblForDevice3.textColor = UIColor(hexString: "#282829")
        }
       
    }
  
    @IBAction func actionForDoubleOkay(_ sender: Any) {
        self.dismissView(selection: callBackString)
    }
    @IBAction func actionForDoubleCancel(_ sender: Any) {
        self.dismissView(selection: "Cancel")
    }
    @IBAction func actionForSdkConfirm(_ sender: Any) {
        self.dismissView(selection: callBackString)
    }
    @IBAction func actionForSdkCancel(_ sender: Any) {
        self.dismissView(selection: "Cancel")
    }
    
    @IBAction func actionForDeviceOne(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            viewForDeviceOne.backgroundColor = UIColor(hexString: "#FF601A")
            lblForDeviceOne.textColor = .white
            viewForDevice2.backgroundColor = .white
            lblForDevice2.textColor = UIColor(hexString: "#282829")
            viewForDevice3.backgroundColor = .white
            lblForDevice3.textColor = UIColor(hexString: "#282829")
            btnForDevice2.isSelected = false
            btnForDevice3.isSelected = false
            callBackString = "2"
        } else {
            sender.isSelected = !sender.isSelected
            viewForDeviceOne.backgroundColor = .white
            lblForDeviceOne.textColor = UIColor(hexString: "#282829")
        }
        
    }
    @IBAction func actionFOrDeviceTwo(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            viewForDevice2.backgroundColor = UIColor(hexString: "#FF601A")
            lblForDevice2.textColor = .white
            viewForDevice3.backgroundColor = .white
            lblForDevice3.textColor = UIColor(hexString: "#282829")
            viewForDeviceOne.backgroundColor = .white
            lblForDeviceOne.textColor = UIColor(hexString: "#282829")
            btnForDevice1.isSelected = false
            btnForDevice3.isSelected = false
            callBackString = "3"
        } else {
            sender.isSelected = !sender.isSelected
            viewForDevice2.backgroundColor = .white
            lblForDevice2.textColor = UIColor(hexString: "#282829")
        }
    }
    
    @IBAction func actionForDeviceThree(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            viewForDevice3.backgroundColor = UIColor(hexString: "#FF601A")
            lblForDevice3.textColor = .white
            viewForDeviceOne.backgroundColor = .white
            lblForDeviceOne.textColor = UIColor(hexString: "#282829")
            viewForDevice2.backgroundColor = .white
            lblForDevice2.textColor = UIColor(hexString: "#282829")
            btnForDevice2.isSelected = false
            btnForDevice1.isSelected = false
            callBackString = "1"
        } else {
            sender.isSelected = !sender.isSelected
            viewForDevice3.backgroundColor = .white
            lblForDevice3.textColor = UIColor(hexString: "#282829")
        }
    }
    
    
    private func dismissView(selection:String) {
        self.view.removeFromSuperview()
        self.view.window?.removeFromSuperview()
        removeFromParent()
        complition(selection)
    }

}
