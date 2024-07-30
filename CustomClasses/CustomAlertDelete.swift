//
//  CustomAlert.swift
//  synex
//
//  Created by Ritesh chopra on 11/09/23.
//

import UIKit
typealias ButtonActionDelete = (()->())


class CustomAlertDelete: UIView {
    //MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    convenience init(title:String?, message: String?,cancelButtonTitle: String?, doneButtonTitle: String?) {
        self.init(frame:UIScreen.main.bounds)
        self.initialize(title: title, message: message, cancelButtonTitle: cancelButtonTitle,doneButtonTitle: doneButtonTitle)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK:- private Method
    private func nibSetup () {
        view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    

    
    private func loadFromNib () -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    private func initialize(title:String?, message: String?,cancelButtonTitle: String?, doneButtonTitle: String?) {
         
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        self.title.text = title ?? ""
        
        self.doneButton.titleLabel?.textAlignment = .center
        self.doneButton.titleLabel?.numberOfLines = 0
        self.doneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.doneButton.titleLabel?.minimumScaleFactor = 0.5
        
        self.cancelButton.titleLabel?.textAlignment = .center
        self.cancelButton.titleLabel?.numberOfLines = 0
        self.cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.cancelButton.titleLabel?.minimumScaleFactor = 0.5
        
        self.message.text = message ?? ""
    }
    
    //MARK: Show Alert
    func show() {
        self.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration:0.2) {
            self.alpha = 1.0
        }
    }
    
   
    func remove() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.alpha = 0
        }, completion: {(success) in
            self.removeFromSuperview()
        })
    }
    
    
    
    
    @IBAction func noButtonAction(_ sender: Any) {
         self.remove()
    }
    
    
    @IBAction func okButtonAction(_ sender: UIButton) {
       // self.remove()
    }
    
}

//For Handle Action
class ClosureSleeveDelete {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}


//Add Target With Closure
extension UIControl {
    func addTargetDelete (action: @escaping ()->()) {
        let sleeve = ClosureSleeveDelete(action)
        addTarget(sleeve, action: #selector(ClosureSleeveDelete.invoke), for: UIControl.Event.touchUpInside)
        objc_setAssociatedObject(self, String(ObjectIdentifier(self).hashValue) + String(UIControl.Event.touchUpInside.rawValue), sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}


