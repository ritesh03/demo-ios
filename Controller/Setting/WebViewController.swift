//
//  WebViewController.swift
//  synex
//
//  Created by Subhash Mehta on 17/04/24.
//

import UIKit
import WebKit

class WebViewController: BaseVC, WKNavigationDelegate {
    
    //MARK: - getObject method
    class func getObject() -> WebViewController?{
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: WebViewController.className) as? WebViewController{
            return controller
        }
        return nil
    }
    
    //MARK: - Outlets
    @IBOutlet weak var termsConditionTitle: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    //MARK: - Variable
    var isTerms = false
    var isPrivacy = false
    var isHome = false
    var termsText = AppConfig.empty
    var titleString = AppConfig.empty
    var url:String = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleButton.setTitle(titleString, for: .normal)
//        var languageStrings = Global.readStrings()
//        var link = UrlConfig.BASE_URL
//        if isHome {
//            titleButton.setTitle(languageStrings[Keys.guide] as? String, for: .normal)
//            link = link + UrlConfig.ANALYSIS_URL
//        }
//        else if isTerms {
//            titleButton.setTitle(languageStrings[Keys.termsAndConditions] as? String, for: .normal)
//            link = link + UrlConfig.TERMS_URL
//        }
//        else if isPrivacy {
//            titleButton.setTitle(languageStrings[Keys.privacyPolicy] as? String, for: .normal)
//            link = link + UrlConfig.TERMS_URL
//        }
//        else {
//            titleButton.setTitle(languageStrings[Keys.marketingConsent] as? String, for: .normal)
//            link = link + UrlConfig.CONSENT_URL
//        }
//        let language = ""
//        if language.getLanguage() == "ko" {
//            link = link + "_ko.html"
//        } else {
//            link = link + "_en.html"
//        }
        if let url = URL(string:url) {
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.load(request)
            activityIndicator.startAnimating()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //customizeUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // hideNavigationBar()
    }
    @IBAction func actionForBack(_ sender: Any) {
//        if isHome {
//            self.dismiss(animated: true)
//            return
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Function
    func customizeUI() {
       // setNavigation(title: AppConfig.empty)
       // termsConditionTitle.text = titleString
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
