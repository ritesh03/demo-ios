//
//  AddMemoViewController.swift
//  synex
//
//  Created by Ritesh chopra on 12/09/23.
//

import UIKit
import AliveCorKitLite

protocol DelegateNote{
    func delegateNote(note: String)
}

class AddMemoViewController: BaseVC {
    
    //MARK: - Outlets
   @IBOutlet weak var addMemoTextfield: UITextView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var cancelButton: UIButton!
   @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lblForPlaceHolder: UILabel!
    
    //MARK: - Variable
    var languageStrings = [String:AnyObject]()
    var delegate: DelegateNote?
    var note = String()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        languageStrings = Global.readStrings()
        titleLabel.text = languageStrings[Keys.addMemo] as? String
        cancelButton.setTitle(languageStrings[Keys.cancel] as? String, for: .normal)
        saveButton.setTitle(languageStrings[Keys.save] as? String, for: .normal)
        addMemoTextfield.text = note
        if note != "" {
            lblForPlaceHolder.text = ""
        } else {
            lblForPlaceHolder.text = languageStrings[Keys.memoPlaceholder] as? String
        }
    }
    
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        delegate?.delegateNote(note: addMemoTextfield.text ?? "")
        self.dismiss(animated: false)
    }
}
    
extension AddMemoViewController:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textInout = textView.text,
           let textRange = Range(range, in: textInout) {
            let updatedText = textInout.replacingCharacters(in: textRange,
                                                            with: text)
            if updatedText.count > 0 {
                lblForPlaceHolder.isHidden = true
            } else {
                lblForPlaceHolder.isHidden = false
            }
        }
        return true
    }
}
