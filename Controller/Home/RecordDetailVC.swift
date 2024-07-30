//
//  RecordDetailVC.swift
//  synex
//
//  Created by Ritesh chopra on 11/09/23.
//

import UIKit
import AliveCorKitLite
import CommonCrypto

class RecordDetailVC: BaseVC,ACKRecordingResultTraceViewDelegate {
   
    //MARK: - Outlets
    @IBOutlet weak var ecgContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sharePDFLabel: UILabel!
    @IBOutlet weak var addMemoLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    //MARK: - Variable
    let viewModel = RecordPreviewViewModel()
    var patientId = AppConfig.empty
    var eckRecord: ACKEcgRecord?
    var languageStrings = [String:AnyObject]()
    var pdfLead = 1
    var lock = 2
    var count = 0
    var pdfType = 1
    var merchantType = 1 //korea and hongkong existng customers
    var notes = ""
    var pdfFilePath = ""
    let user = Global.getDataFromUserDefaults(.userData)
    
//MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        languageStrings = Global.readStrings()
        titleLabel.text = languageStrings[Keys.result] as? String
        finishButton.setTitle(languageStrings[Keys.save] as? String, for: .normal)
        shareButton.setTitle(languageStrings[Keys.sharePDF] as? String, for: .normal)
        noteButton.setTitle(languageStrings[Keys.addMemo] as? String, for: .normal)
  
        //Show recorded ECG report
        initializeECGRecordView()
        
        //Generate PDF
        generatePDFReport()
    }
    
    func initializeECGRecordView(){
//        let eckFileView = ACKEcgFileView()
//        eckFileView.maximumDisplayMode = kECGDisplayModeSixLead
//        eckFileView.renderEcg(eckRecord!, xScale: 0, yScale: 100, scrollingDisabled: false)
//        print(eckFileView.displayMode)
//        guard let resultView = ACKRecordingResultTraceView(ecg: eckRecord, fileView: eckFileView, largeLayout: true, supportsLandscape: false, delegate: self) else { 
//            return }
//        resultView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: ecgContainerView.frame.height)
//            ecgContainerView.addSubview(resultView)
        
        let eckFileView = ACKEcgFileView()
        eckFileView.maximumDisplayMode = kECGDisplayModeSixLead
        eckFileView.renderEcg(eckRecord!, xScale: 100, yScale: 100, scrollingDisabled: false)
        print(eckFileView.displayMode)
        guard let resultView = ACKRecordingResultTraceView(ecg: eckRecord, fileView: eckFileView, largeLayout: true, supportsLandscape: false, delegate: self) else { return }
        resultView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: ecgContainerView.frame.height)
       // resultView.recordingResultTraceViewPressedAlgorithmInfoButton.addTarget(self, action: #selector(handleRecordsButtonDidTap), for: .touchUpInside)
            ecgContainerView.addSubview(resultView)
    }
    
    func recordingResultTraceViewPressedAlgorithmInfoButton(){
        let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.isHome = true
        vc.titleString = ""
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func generatePDFReport(){
        let pdfConfig = ACKPDFConfig.init(ecg: eckRecord!)
        pdfConfig.metadata = ACKPDFMetadata()
        if let name = user?["name"] as? String, name != "" {
            pdfConfig.metadata?.patientFirstName = user?["name"] as? String
        }else{
            pdfConfig.metadata?.patientFirstName = user?["_id"] as? String
         }
        
        pdfConfig.metadata?.patientDateOfBirth = user?["dateOfBirth"] as? String
        let gender = user?["gender"] as? Int
        if  gender == 2 {
            pdfConfig.metadata?.male = 0
        } else if gender == 1 {
            pdfConfig.metadata?.male = 1
        }
        pdfConfig.metadata?.notes = self.notes
        self.pdfFilePath = ACKPDFReport.pdfPath(for: pdfConfig) ?? ""
    }


    
    //MARK: - Actons
    @IBAction func pdfButton(_ sender: UIButton) {
        let pdfView = PDFView()
        let pdfUrl = URL(fileURLWithPath: self.pdfFilePath)
        if let document = PDFDocument(url: pdfUrl) {
            pdfView.document = document
        }
        guard let pdfDocument = pdfView.document?.dataRepresentation() else { return }
        let activityViewController = UIActivityViewController(activityItems: [pdfDocument], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    
    @IBAction func addMemoButtonAction(_ sender: UIButton) {
        let vc = AddMemoViewController.instantiate(fromAppStoryboard: .Home)
        vc.delegate = self
        vc.note =  self.notes
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @IBAction func finishButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        self.showProgressBar(message: languageStrings[Keys.saving] as? String)
       
        patientId = user?["_id"] as? String ?? ""
        
        var leadConfig = "SINGLE"
        if let leadsConfigRaw = Global.getDataFromUserDefaults(.leadConfig), let leadsConfig = ACKLeadsConfig(rawValue: leadsConfigRaw as! Int), leadsConfig == ACKLeadsConfig.six {
            pdfLead = 2
            leadConfig = "SIX"
        }
        
       
        if let lockMode = Global.getDataFromUserDefaults(.lockMode) as? Bool, lockMode {
            lock = 1
            if let counter = Global.getDataFromUserDefaults(.counter) as? Int {
                count = counter
            } else {
                count = 1
            }
        }
        
        let determination = eckRecord?.evaluation?.determination
        let isInverted = eckRecord?.evaluation?.isInverted
        let resultColor = eckRecord?.evaluation?.determinationColor().hexString
        let kaiResult = eckRecord?.evaluation?.determination
        let kardiaAIVersion = eckRecord?.evaluation?.version
        let algorithmResultDescription = eckRecord?.evaluation?.localizedDescription()
        let algorithmResultText = eckRecord?.evaluation?.localizedDeterminationDescription()
        let averageHeartRate = eckRecord?.evaluation?.averageHeartRate
        let resultDisclaimerText = eckRecord?.evaluation?.localizedDisclaimer()

        
        //Get devive name
        var deviceName = ""
        if eckRecord?.config.deviceType == .triangle {
            deviceName = "TRAINGLE"
        } else if eckRecord?.config.deviceType == .mobile {
            deviceName = "KARDIA_MOBILE"
        } else if eckRecord?.config.deviceType == .band {
            deviceName = "KARDIA_BAND"
        } else if eckRecord?.config.deviceType == .sakuraOne {
            deviceName = "SAKURAONE"
        } else if eckRecord?.config.deviceType == .card {
            deviceName = "KARDIA_CARD"
        }else{
            deviceName = "Unknown"
        }
        
        //ACKConfig Properties
        let recordingConfigurationDeviceName = deviceName
        let recordingConfigurationMainsFrequency = eckRecord?.config.frequency
        let recordingConfigurationMaxDuration = eckRecord?.config.maxDuration
        var filterType = ""
        if eckRecord?.config.filterType == .enhanced {
            filterType = "ENHANCED"
        } else {
            filterType = "ORIGINAL"
        }
        let recordingConfigurationFilterType = filterType
        let recordingConfigurationOverrideDeviceName = eckRecord?.config.deviceType.rawValue
        let recordingConfigurationResetDurationSeconds = eckRecord?.config.minDuration
        let recordingConfigurationSampleRate = eckRecord?.config.sampleRate
        
        //ACKDevice Properties
        let deviceDetails = ["deviceName": deviceName , "deviceUuid": eckRecord?.device?.uuid as AnyObject, "leadConfiguration": leadConfig, "batteryLevel": eckRecord?.device?.batteryLevel ?? 0.0,"firmwareVersion": eckRecord?.device?.firmwareRevision,"hardwareVersion": eckRecord?.device?.hardwareRevision,"serialNumber": eckRecord?.device?.serialNumber ?? ""] as [String : Any]
        let deviceInfo = deviceDetails.jsonStringRepresentation
        
        //ACKRecord Properties
        let enhancedAtcPath = eckRecord?.enhancedPath
        let rawAtcPath = eckRecord?.originalPath
        let durationMs = eckRecord?.duration
        let timezoneOffset = eckRecord?.timeZoneOffset
        let uuid = eckRecord?.uuid
        let filesDirectory = eckRecord?.filesDirectory
        let recordedAtMs = eckRecord?.recordedAt?.millisecondsSince1970
        
        let params = ["patientId": patientId as AnyObject, "deviceId": AppConfig.deviceID as AnyObject,"deviceType": AppConfig.deviceType as AnyObject, "pdfType": pdfType as AnyObject, "pdfLead": pdfLead as AnyObject,"timeStamp": Date().getDateString() as AnyObject, "determination": determination as AnyObject, "isInverted": isInverted as AnyObject, "resultColor": resultColor as AnyObject, "kaiResult": kaiResult,"kardiaAiVersion": kardiaAIVersion ?? "", "algorithmResultDescription": algorithmResultDescription ?? "", "algorithmResultText": algorithmResultText ?? "",
                      "averageHeartRate": averageHeartRate as AnyObject, "resultDisclaimerText": resultDisclaimerText as AnyObject , "recordingConfigurationDeviceName": recordingConfigurationDeviceName,"recordingConfigurationOverrideDeviceName":recordingConfigurationOverrideDeviceName,"recordingConfigurationMainsFrequency":  recordingConfigurationMainsFrequency as AnyObject, "recordingConfigurationMaxDurationSeconds": recordingConfigurationMaxDuration as AnyObject, "recordingConfigurationFilterType": recordingConfigurationFilterType, "recordingConfigurationResetDurationSeconds": recordingConfigurationResetDurationSeconds as AnyObject,"recordingConfigurationSampleRate": recordingConfigurationSampleRate as AnyObject,"deviceInfo":deviceInfo as AnyObject,"enhancedAtcPath":enhancedAtcPath as AnyObject,"rawAtcPath":rawAtcPath as AnyObject, "durationMs":durationMs as AnyObject,"timezoneOffset":timezoneOffset as AnyObject,"uuid":uuid,"filesDirectory":filesDirectory ?? "","recordedAtMs":recordedAtMs,"notes":notes] as [String : AnyObject]
       
        print(params)
        
        //Save pdf locally in local storage before uploading to server
        savePdf(urlString:self.pdfFilePath, fileName:"\(self.patientId)")

        let atcURL = URL(string: enhancedAtcPath!)  //convert atc path to URL
        let atcFilename = atcURL?.lastPathComponent
        
        //For MEDAI Customer (Call only MEDAI API)
        if merchantType == 2 {
            self.callMedAIAPI(atcFile: enhancedAtcPath ?? "", atcFileName: atcFilename ?? "")
        }
        else { //For Other customers (Upload to s3 bucket)
        //upload pdf to server along with params (Call API to save data on s3 bucket)
        viewModel.uploadPDF(pdfFilePath: self.pdfFilePath ?? "", fileName: "\(patientId).pdf", rawAtcFile: enhancedAtcPath ?? "", atcFileName: atcFilename!, parameters: params) { [self] status, message in
        self.hideProgressBar()
            if status {
                if merchantType == 3 { //(THAILAND, HONGKONG, HANARO Customers)
                    self.callMedAIAPI(atcFile: enhancedAtcPath ?? "", atcFileName: atcFilename ?? "")
                } else { //(KOREA Customers)
                    self.alert(view: self, title: (languageStrings[Keys.pdfUpload] as? String)!, buttonText: self.languageStrings[Keys.ok] as? String ) {
                        self.redirectToHome()
                    }
              }
            } else {
                self.showAlert(title: message, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
        }
      }
    }
    
    func savePdf(urlString:String, fileName:String) {
           DispatchQueue.main.async {
               let url = URL(string: urlString)
               let pdfData = try? Data.init(contentsOf: url!)
               let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
               let pdfNameFromUrl = "\(fileName).pdf"
               let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
               do {
                   try pdfData?.write(to: actualPath, options: .atomic)
                   print("pdf successfully saved!")
               } catch {
                   print("Pdf could not be saved")
               }
           }
       }
    
    func showSavedPdf(url:String, fileName:String) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName).pdf") {
                       // its your file! do what you want with it!

                }
            }
        } catch {
            print("could not locate pdf file !!!!!!!")
        }
    }
}
    
}

extension RecordDetailVC{
    //MEDAI APIS
    func getAccessToken(){
      //  let passwordString = AppConstants.username + AppConstants.password
        //let encryptedPassword = passwordString.sha256()
        let params = ["username": AppConstants.username as AnyObject, "password": AppConstants.password as AnyObject, "grant_type": "password" as AnyObject, "client_id": AppConstants.clientId as AnyObject,"client_secret":AppConstants.clientSecret as AnyObject]
        viewModel.getAccessToken(params) { status, message in
            if status {
                self.getRefreshToken()
            } else {
                self.hideProgressBar()
                self.showToast(message)
            }
        }
        
    }
    
    func getRefreshToken(){
        let params = ["refresh_token": viewModel.refreshToken as AnyObject, "grant_type": "refresh_token" as AnyObject, "client_id": AppConstants.clientId as AnyObject,"client_secret":AppConstants.clientSecret as AnyObject]
        viewModel.getAccessToken(params) { status, message in
            if status {
                print("Refresh Token API Success")
            } else {
                self.hideProgressBar()
                self.showToast(message)
            }
        }
    }
    
    func callMedAIAPI(atcFile:String?,atcFileName:String?){
        self.showProgressBar(message: languageStrings[Keys.saving] as? String)
        let customerId = Global.getDataFromUserDefaults(.customerID)
        let params = ["customer_id": customerId as AnyObject, "patient_id": patientId as AnyObject]  as [String : AnyObject]
        viewModel.uploadATCFile(header: viewModel.refreshToken, rawAtcFile: atcFile ?? "" , atcFileName: atcFileName ?? "", parameters: params) { [self] status, message in
        self.hideProgressBar()
        self.appDelegate!.navigateToHome()
        }
    }
}
//MARK::- DELEGATES
extension RecordDetailVC : DelegateNote {
    func delegateNote(note: String) {
        self.notes = note
        generatePDFReport()
    }
}
