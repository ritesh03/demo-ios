//
//  TermsConditionDetailVC.swift
//  synex
//
//  Created by Ritesh chopra on 07/09/23.
//

import UIKit
import WebKit

class TermsConditionDetailVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var termsConditionTitle: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmedButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var confirmedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Variable
    var isTerms = false
    var isPrivacy = false
    var isMarketing = false
    var isMedical =  false
    var isHome = false
    var isGuide = false
    var termsText = AppConfig.empty
    var titleString = AppConfig.empty

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        hideNavigationBar()
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        let languageStrings = Global.readStrings()
        confirmedButton.setTitle(languageStrings[Keys.confirmed] as? String, for: .normal)
        var link = UrlConfig.BASE_URL
        let language = ""
        if isHome {
            titleButton.setTitle(languageStrings[Keys.guide] as? String, for: .normal)
            link = link + UrlConfig.ANALYSIS_URL
            if language.getLanguage() == "ko" {
              link = link + "_ko.html"
            } else {
              link = link + "_en.html"
            }
            bottomConstraint.constant = 0
            confirmedHeightConstraint.constant = 0
            confirmedButton.isHidden = true
        }
        else if isTerms {
            titleButton.setTitle(languageStrings[Keys.termsOfUse] as? String, for: .normal)
            link = link + UrlConfig.TERMS_URL_KO
//            if language.getLanguage() == "ko" {
//              link = link + "_ko.html"
//            } else {
//              link = link + "_en.html"
//            }
        }
        else if isPrivacy {
            titleButton.setTitle(languageStrings[Keys.privacyPolicy] as? String, for: .normal)
            link = link + UrlConfig.PRIVACY_URL_KO
//            if language.getLanguage() == "ko" {
//              link = link + "_ko.html"
//            } else {
//              link = link + "_en.html"
//            }
        }
        else if isMarketing{
              titleButton.setTitle(languageStrings[Keys.marketingConsent] as? String, for: .normal)
              link = link + UrlConfig.MARKETING_URL_KO
//            if language.getLanguage() == "ko" {
//              link = link + "_ko.html"
//            } else {
//              link = link + "_en.html"
//            }
        }
        else if isMedical{
              titleButton.setTitle(languageStrings[Keys.medicalDeviceLabel] as? String, for: .normal)
              link = link + UrlConfig.MEDICAL_URL_KO
//            if language.getLanguage() == "ko" {
//              link = link + "_ko.html"
//            } else {
//              link = link + "_en.html"
//            }
        }
        
        let url = URL(string:link)!
        let request = URLRequest(url: url)
        webView.load(request)
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //customizeUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    @IBAction func actionForBack(_ sender: Any) {
        if isHome {
            self.dismiss(animated: true)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Function
    func customizeUI() {
       // setNavigation(title: AppConfig.empty)
       // termsConditionTitle.text = titleString
    }
}

