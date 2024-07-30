//
//  ReminderVC.swift
//  synex
//
//  Created by Subhash Mehta on 08/04/24.
//

import UIKit

class ReminderVC: BaseVC {
    
    //MARK: - getObject method
    class func getObject() -> ReminderVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: ReminderVC.className) as? ReminderVC{
            return controller
        }
        return nil
    }
    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var btnForAdd: UIButton!
    @IBOutlet weak var viewForNoData: UIView!
    @IBOutlet weak var lblForSetAlarm: UILabel!
    @IBOutlet weak var lblForNoAlarm: UILabel!
    @IBOutlet weak var lblForSetAlarmNoData: UILabel!
    @IBOutlet weak var tblViewForReminder: UITableView!
    
    var languageStrings = [String:AnyObject]()
    private let alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    private let scheduler: NotificationSchedulerDelegate = NotificationScheduler()
    private let alarms: Alarms = Store.shared.alarms
    var selectedIndex:Int?
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        if alarms.count > 0 {
            tblViewForReminder.isHidden = false
            btnForAdd.isHidden = true
        } else {
            tblViewForReminder.isHidden = true
            btnForAdd.isHidden = false
        }
        languageStringConvert()
        NotificationCenter.default.addObserver(self, selector: #selector(handleChangeNotification(_:)), name: Store.changedNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        btnForBack.setTitle(languageStrings[Keys.reminder] as? String, for: .normal)
        btnForAdd.setTitle(languageStrings[Keys.added] as? String, for: .normal)
        lblForSetAlarm.text = languageStrings[Keys.setAlarm] as? String
        lblForNoAlarm.text = languageStrings[Keys.noRegisteredAlarm] as? String
        lblForSetAlarmNoData.text = languageStrings[Keys.alarmDesc] as? String
  }
    
    //MARK: - Actions
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionForAdd(_ sender: Any) {
        self.showReminder(navController: self.navigationController ?? UINavigationController(), isEdit: false)
    }
    func showReminder(navController:UINavigationController, isEdit:Bool)  {
        if let controller = AddReminderVC.getObject(){
            if isEdit {
                controller.isEditMode = true
                controller.alarms = alarms
                controller.currentAlarm = alarms[selectedIndex ?? 0]
            } else {
                controller.isEditMode = false
                controller.alarms = alarms
                controller.currentAlarm = Alarm()
            }
            
            navController.addChild(controller)
            controller.navigationItem.hidesBackButton = true
            controller.view?.frame = (navController.view?.frame)!
            controller.hidesBottomBarWhenPushed = true
            navController.view.window?.addSubview((controller.view)!)
            controller.dismissVCCompletion { result  in
               // self.tblViewForReminder.reloadData()
                if let result = result {
                   // self.setAlarm(result: result)
                }
            }
        }
    }
    
    @objc func handleChangeNotification(_ notification: Notification) {
        
            guard let userInfo = notification.userInfo else {
            return
        }
        if alarms.count > 0 {
            tblViewForReminder.isHidden = false
            btnForAdd.isHidden = true
        } else {
            tblViewForReminder.isHidden = true
            btnForAdd.isHidden = false
        }
        
        // Handle changes to contents
        if let changeReason = userInfo[Alarm.changeReasonKey] as? String {
            let newValue = userInfo[Alarm.newValueKey]
            let oldValue = userInfo[Alarm.oldValueKey]
            switch (changeReason, newValue, oldValue) {
            case let (Alarm.removed, (uuid as String)?, (oldValue as Int)?):
               // tableView.deleteRows(at: [IndexPath(row: oldValue, section: 0)], with: .fade)
                if alarms.count == 0 {
                  //  self.navigationItem.leftBarButtonItem = nil
                    self.viewForNoData.isHidden = false
                    self.tblViewForReminder.isHidden = true
                }
                scheduler.cancelNotification(ByUUIDStr: uuid)
            case let (Alarm.added, (index as Int)?, _):
                tblViewForReminder.reloadData()
                    //insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
               // self.navigationItem.leftBarButtonItem = editButtonItem
                let alarm = alarms[index]
                scheduler.setNotification(date: alarm.date, ringtoneName: alarm.mediaLabel, repeatWeekdays: alarm.repeatWeekdays, snoozeEnabled: alarm.snoozeEnabled, onSnooze: false, uuid: alarm.uuid.uuidString)
            case let (Alarm.updated, (index as Int)?, _):
                let alarm = alarms[index]
                let uuid = alarm.uuid.uuidString
                if alarm.enabled {
                    scheduler.updateNotification(ByUUIDStr: uuid, date: alarm.date, ringtoneName: alarm.mediaLabel, repeatWeekdays: alarm.repeatWeekdays, snoonzeEnabled: alarm.snoozeEnabled)
                } else {
                    scheduler.cancelNotification(ByUUIDStr: uuid)
                }
                tblViewForReminder.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            default: tblViewForReminder.reloadData()
            }
        } else {
            tblViewForReminder.reloadData()
        }
    }
    
//    private func setAlarm(result:Dictionary<String,Any>){
//        // create local notification content
//        let content = UNMutableNotificationContent()
//        let alarmBody = languageStrings[Keys.alarmText] as? String
//        content.title = ""
//        content.body = alarmBody
//        content.sound = UNNotificationSound(named: UNNotificationSoundName("alert.caf"))
//
//        // Configure the recurring date.
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//                
//        dateComponents.weekday = 2
//        dateComponents.hour = 11
//        dateComponents.minute = 10
//                   
//        // Create the trigger as a repeating event.
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//        // Create the request
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.add(request) { (error) in
//          if error != nil {
//            // Handle any errors.
//          }
//        }
//    }
    
}
extension ReminderVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTVC.className, for: indexPath) as! ReminderTVC
        cell.selectionStyle = .none
        cell.btnForEdit.setTitle(languageStrings[Keys.editAlarm] as? String, for: .normal)
        cell.btnForDelete.setTitle(languageStrings[Keys.deleteAlarm] as? String, for: .normal)
        cell.btnForDelete.tag = indexPath.row
        cell.btnForDelete.addTarget(self, action: #selector(actionForDelete), for: .touchUpInside)
        cell.btnForEdit.tag = indexPath.row
        cell.btnForEdit.addTarget(self, action: #selector(actionForEdit), for: .touchUpInside)
        cell.switchForOnOff.tag = indexPath.row
        cell.switchForOnOff.addTarget(self, action: #selector(actionForSwitch), for: .valueChanged)
        
        let alarm = alarms[indexPath.row]
        let str = alarm.formattedTime
        let am = str.components(separatedBy: " ")
        if am.count > 1 {
            cell.lblForAMPM.text = am[1]
            cell.lblForTime.text = am[0]
        }
        if alarm.repeatWeekdays.count == 7 {
            cell.lblForDays.text = languageStrings[Keys.everyday] as? String
        } else {
            let monday = languageStrings[Keys.mon] as? String ?? "Mon"
            let tuesday = languageStrings[Keys.tue] as? String ?? "Tue"
            let wednesday = languageStrings[Keys.wed] as? String ?? "Wed"
            let thursday = languageStrings[Keys.thu] as? String ?? "Thu"
            let friday = languageStrings[Keys.fri] as? String ?? "Fri"
            let saturday = languageStrings[Keys.sat] as? String ?? "Sat"
            let sunday = languageStrings[Keys.sun] as? String ?? "Sun"
        
            var daysStrings = ""
            for (index,day) in alarm.repeatWeekdays.sorted().enumerated() {
                if index == 0 {
                    daysStrings = (day == 2 ? monday : day == 3 ? tuesday : day == 4 ? wednesday : day == 5 ? thursday : day == 6 ? friday : day == 7 ? saturday : sunday)
                } else {
                    daysStrings.append(" \((day == 2 ? monday : day == 3 ? tuesday : day == 4 ? wednesday : day == 5 ? thursday : day == 6 ? friday : day == 7 ? saturday : sunday))")
                }
            }
            cell.lblForDays.text = daysStrings
        }
        
       
        if alarm.enabled {
            cell.switchForOnOff.setOn(true, animated: false)
        } else {
            cell.switchForOnOff.setOn(false, animated: false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func actionForDelete(sender:UIButton){
        self.showCustomAlert(message: languageStrings[Keys.deleteSelectedAlarm]! as? String,cancelButtonTitle: languageStrings[Keys.cancel]! as? String,doneButtonTitle: languageStrings[Keys.confirm]! as? String, doneCallback:  {
            self.alarms.remove(at: sender.tag)
        })
    }
    
    @objc func actionForEdit(sender:UIButton){
        selectedIndex = sender.tag
        self.showReminder(navController: self.navigationController ?? UINavigationController(), isEdit: true)
    }
    @objc func actionForSwitch(sender:UISwitch){
        let alarm = alarms[sender.tag]
        alarm.enabled = sender.isOn
        alarms.update(alarm)
    }
   
}
