//
//  AddReminderVC.swift
//  synex
//
//  Created by Subhash Mehta on 13/04/24.
//

import UIKit

class AddReminderVC: BaseVC {

    //MARK: - getObject method
    class func getObject() -> AddReminderVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: AddReminderVC.className) as? AddReminderVC{
            return controller
        }
        return nil
    }
    
    typealias typeCompletionHandler = (Dictionary<String,Any>?) -> ()
    var complition : typeCompletionHandler = { _  in }
    func dismissVCCompletion(_ completionHandler: @escaping typeCompletionHandler) {
        self.complition = completionHandler
    }
    @IBOutlet weak var lblForTime: UILabel!
    @IBOutlet weak var btnForReset: UIButton!
    @IBOutlet weak var btnForApply: UIButton!
    @IBOutlet weak var btnForEveryday: UIButton!
    @IBOutlet weak var lblForDate: UILabel!
    @IBOutlet weak var btnForMon: UIButton!
    @IBOutlet weak var btnForTue: UIButton!
    @IBOutlet weak var btnForWed: UIButton!
    @IBOutlet weak var btnForThru: UIButton!
    @IBOutlet weak var btnForFri: UIButton!
    @IBOutlet weak var btnForSat: UIButton!
    @IBOutlet weak var btnForSun: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var result:Dictionary<String,Any>?
    var arrForDay = [String]()
    var languageStrings = [String:AnyObject]()
    
    var alarms: Alarms?
    var currentAlarm: Alarm?
    var isEditMode = false

    
    private var snoozeEnabled = false
    private var label = ""
    private var repeatWeekdays: [Int] = []
    private var mediaLabel = ""
    private var mediaID = ""
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnForApply.isEnabled = false
        btnForApply.backgroundColor = UIColor(hexString: "#DCDFE3")
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
           swipeRight.direction = .down
           self.view.addGestureRecognizer(swipeRight)
        languageStringConvert()
        datePicker.date = Date()
        let language = ""
        datePicker.locale = Locale(identifier: language.getLanguage())
        // Do any additional setup after loading the view.
        if let alarm = currentAlarm {
           
            snoozeEnabled = alarm.snoozeEnabled
            label = alarm.label
            repeatWeekdays = alarm.repeatWeekdays
            mediaLabel = alarm.mediaLabel
            mediaID = alarm.mediaID
            datePicker.date = alarm.date
            if alarm.repeatWeekdays.count > 0 {
                btnForApply.isEnabled = true
                btnForApply.backgroundColor = UIColor.greenColor()
            }
            if alarm.repeatWeekdays.count == 7 {
                btnForEveryday.isSelected = true
                btnForMon.isSelected = true
                btnForTue.isSelected = true
                btnForWed.isSelected = true
                btnForThru.isSelected = true
                btnForFri.isSelected = true
                btnForSat.isSelected = true
                btnForSun.isSelected = true
            } else {
                for day in alarm.repeatWeekdays {
                    switch day {
                    case 2:
                        btnForMon.isSelected = true
                    case 3:
                        btnForTue.isSelected = true
                    case 4:
                        btnForWed.isSelected = true
                    case 5:
                        btnForThru.isSelected = true
                    case 6:
                        btnForFri.isSelected = true
                    case 7:
                        btnForSat.isSelected = true
                    default:
                        btnForSun.isSelected = true
                    }
                }
            }
        }
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                self.dismissView(selection: nil)
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        lblForTime.text = languageStrings[Keys.selectTime] as? String
        lblForDate.text = languageStrings[Keys.selectedDay] as? String
        btnForReset.setTitle(languageStrings[Keys.reset] as? String, for: .normal)
        btnForApply.setTitle(languageStrings[Keys.apply] as? String, for: .normal)
        btnForEveryday.setTitle(languageStrings[Keys.everyday] as? String, for: .normal)
        btnForMon.setTitle(languageStrings[Keys.mon] as? String, for: .normal)
        btnForTue.setTitle(languageStrings[Keys.tue] as? String, for: .normal)
        btnForWed.setTitle(languageStrings[Keys.wed] as? String, for: .normal)
        btnForThru.setTitle(languageStrings[Keys.thu] as? String, for: .normal)
        btnForFri.setTitle(languageStrings[Keys.fri] as? String, for: .normal)
        btnForSat.setTitle(languageStrings[Keys.sat] as? String, for: .normal)
        btnForSun.setTitle(languageStrings[Keys.sun] as? String, for: .normal)
  }

    private func dismissView(selection:Dictionary<String,Any>?) {
        self.view.removeFromSuperview()
        self.view.window?.removeFromSuperview()
        removeFromParent()
        complition(selection)
    }

    func saveAlarm() {
        let date = NotificationScheduler.correctSecondComponent(date: datePicker.date)
        
        if let alarm = currentAlarm {
            alarm.date = date
            alarm.enabled = true
            alarm.snoozeEnabled = snoozeEnabled
            alarm.label = label
            alarm.mediaID = mediaID
            alarm.mediaLabel = mediaLabel
            alarm.repeatWeekdays = repeatWeekdays
            if isEditMode {
                alarms?.update(alarm)
            }
            else {
                alarms?.add(alarm)
            }
        }
       // self.performSegue(withIdentifier: Identifier.saveSegueIdentifier, sender: self)
    }
    
    
    @IBAction func actionForReset(_ sender: Any) {
       // self.dismissView(selection: result)
        btnForApply.isEnabled = false
        btnForApply.backgroundColor = UIColor(hexString: "#DCDFE3")
        btnForEveryday.isSelected = false
        btnForMon.isSelected = false
        btnForTue.isSelected = false
        btnForWed.isSelected = false
        btnForThru.isSelected = false
        btnForFri.isSelected = false
        btnForSat.isSelected = false
        btnForSun.isSelected = false
        repeatWeekdays.removeAll()
        datePicker.date = Date()
    }
    @IBAction func actionForApply(_ sender: Any) {
        saveAlarm()
        self.dismissView(selection: result)
    }
   
    @IBAction func actionForDays(_ sender: UIButton) {
       
        if sender.isSelected == false {
            sender.isSelected = !sender.isSelected
            repeatWeekdays.append(sender.tag == 0 ? 2 : sender.tag == 1 ? 3 : sender.tag == 2 ? 4 : sender.tag == 3 ? 5 : sender.tag == 4 ? 6 : sender.tag == 5 ? 7 : 1)
        }else {
            sender.isSelected = !sender.isSelected
            if let index = repeatWeekdays.firstIndex(of: sender.tag == 0 ? 2 : sender.tag == 1 ? 3 : sender.tag == 2 ? 4 : sender.tag == 3 ? 5 : sender.tag == 4 ? 6 : sender.tag == 5 ? 7 : 1) {
                repeatWeekdays.remove(at: index)
            }
        }
        if repeatWeekdays.count > 0 {
            btnForApply.isEnabled = true
            btnForApply.backgroundColor = UIColor.greenColor()
        }else {
            btnForApply.isEnabled = false
            btnForApply.backgroundColor = UIColor(hexString: "#DCDFE3")
        }
    }
    @IBAction func actionForEveryDay(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.isSelected = !sender.isSelected
            btnForMon.isSelected = true
            btnForTue.isSelected = true
            btnForWed.isSelected = true
            btnForThru.isSelected = true
            btnForFri.isSelected = true
            btnForSat.isSelected = true
            btnForSun.isSelected = true
            repeatWeekdays = [2,3,4,5,6,7,1]
            btnForApply.isEnabled = true
            btnForApply.backgroundColor = UIColor.greenColor()
        } else {
            sender.isSelected = !sender.isSelected
            btnForMon.isSelected = false
            btnForTue.isSelected = false
            btnForWed.isSelected = false
            btnForThru.isSelected = false
            btnForFri.isSelected = false
            btnForSat.isSelected = false
            btnForSun.isSelected = false
            repeatWeekdays.removeAll()
            btnForApply.isEnabled = false
            btnForApply.backgroundColor = UIColor(hexString: "#DCDFE3")
        }
    }
    @IBAction func actionForDatePicker(_ sender: UIDatePicker) {
        result?["time"] = dateFormatter.string(from: sender.date)
    }
    
    
}
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) }
    var minute: Int { return Calendar.current.component(.minute, from: self) }
    var nextHourQuarter: Date {
        return  Calendar.current.date(bySettingHour: hour, minute: minute.nextHourQuarter, second: 0, of: self)!
    }
}
extension Int {
    var nextHourQuarter: Int {
        return (self - self % 60) % 60
    }
}
