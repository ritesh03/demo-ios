//
//  CalendarViewController.swift
//
//  Copyright © 2023 Xperge. All rights reserved.
//

import UIKit
import FSCalendar

protocol DelegateGetSelectedDate {
    func getSelectedDate(fromDate: String, toDate: String)
}

class CalendarViewController: UIViewController {
    
    //MARK: - getObject method
    class func getObject() -> CalendarViewController?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: CalendarViewController.className) as? CalendarViewController{
            return controller
        }
        return nil
    }

    
    //MARK::- OUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var forwardArrow: UIImageView!
    @IBOutlet weak var backArrow: UIImageView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK::- PROPERTIES
    var languageStrings = [String:AnyObject]()
    var delegate:DelegateGetSelectedDate?
    var multipleDates = false
    var selectedDates = [Date]()
    var selectedDate = Date()
    var fromShowDate = false
    var fromBookingReview = false
    var fromString = ""
    var toString = ""
    var isFromString = false
    var isToString = false

    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        languageStrings = Global.readStrings()
        titleLabel.text = ""
//        if isFromString {
//            titleLabel.text = languageStrings[Keys.fromDate] as? String
//        } else  {
//            titleLabel.text = languageStrings[Keys.toDate] as? String
//        }
        let language = ""
        calendar.locale = Locale.init(identifier: language.getLanguage())
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scrollDirection = .horizontal
        calendar.appearance.todayColor = .white
        calendar.appearance.headerDateFormat = "yyyy.MM"
        calendar.placeholderType = .none
        calendar.calendarHeaderView.collectionViewLayout.collectionView?.semanticContentAttribute = .forceLeftToRight
        calendar.select(nil)
        cancelButton.setTitle(languageStrings[Keys.cancel] as? String, for: .normal)
        selectButton.setTitle(languageStrings[Keys.select] as? String, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.calendar.setCurrentPage(selectedDate, animated: true)
    }
    
    //MARK::- FUNCTIONS
    
    func dismissSelf(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK::- ACTIONS
    private func dismissView(selection:String) {
        self.view.removeFromSuperview()
        self.view.window?.removeFromSuperview()
        removeFromParent()
    }
    
    @IBAction func btnActionCancel(_ sender: UIButton) {
      //  delegate?.cancelDate()
      //  dismissSelf()
        self.dismissView(selection: "")
    }
    
    @IBAction func btnActionSelect(_ sender: UIButton) {
        if calendar.selectedDate != nil {
        let selectedDate = calendar.selectedDate!.getDateYYYYMMDDString()
        print(selectedDate)
        if isFromString {
        fromString = selectedDate
//        delegate?.getSelectedDate(fromDate: fromString, toDate: toString)
       // titleLabel.text = languageStrings[Keys.toDate] as? String
        //isFromString = false
        //isToString = true
       // self.calendar.reloadData()
        } else {
        toString = selectedDate
       // dismissSelf()
        }
            delegate?.getSelectedDate(fromDate: fromString, toDate: toString)
            self.dismissView(selection: "")
     }

    }
}

extension CalendarViewController : FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    
  
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
       return Calendar.current.date(byAdding: .day, value:0, to: Date())!
        
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        if !isFromString {
            return self.dateFormatter.date(from: fromString)!
        }
       
        return self.dateFormatter.date(from: "2021-01-01")!
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
}



