//
//  AppConfig.swift

import UIKit


enum APIRequests : Int {
    case RType_Language
    case RType_Language_Strings
    case RType_Login
    case RType_Forgot_Password
    case RType_Find_Id
    case RType_Delete_Account
    case RType_Change_Password
    case RType_Terms
    case RType_Token
    case RType_Home
    case RType_Notification
    case RType_History
    case RType_Fav
    case RType_Upload_Pdf
}

enum RequestType: Int {
    case RType_Get
    case RType_Post
    case RType_Put
    case RType_Delete
}

struct ServiceStatusCode {
    static let kSuccess             =  200
    static let kSuccessRegister     =  201
    static let kUserAlreadyExist    =  400
    static let kAuthorizationError  =  401
    static let kError               =  404
}

struct ProfileCompletionSteps {
    static let step0 =  0
    static let step1 =  1
    static let step2 =  2
}

class AppConfig {

    static var deviceToken = ""
    static let deviceType = "IOS"
    static let deviceID = UIDevice.current.identifierForVendor!.uuidString
    static let lockPassword = "12345"
    static var empty = ""
    static var empty2 = " "
    static var code = "code"
    static var id = "_id"
    static var oid = "$oid"
    static var id2 = "id"
    static var kakaoButtonImage = "kakao_login_button_korean.png"
}

class Determination {
    static var Normal = "0"
    static var Afib = "1"
    static var Unclassified = "2"
    static var Tachycardia = "3"
    static var Bradycardia = "4"
    static let Short = "5"
    static let Long = "6"
    static let Unreadable = "7"
    static let NoAnalysis = "8"
}

class DeterminationKeys {
    static var Normal = "Normal"
    static var Afib = "Possible Atrial Fibrillation"
    static var Unclassified = "Unclassified"
    static var Tachycardia = "Tachycardia"
    static var Bradycardia = "Bradycardia"
    static let Short = "Too Short"
    static let Long = "Long"
    static let Unreadable = "Unreadable"
    static let NoAnalysis = "No Analysis"
}

class DeterminationKeysKr {
    static var Normal = "정상"
    static var Afib = "심방세동 가능성"
    static var Unclassified = "미분류"
    static var Tachycardia = "빈맥"
    static var Bradycardia = "서맥"
    static let Short = "너무 짧음"
    static let Long = "긴"
    static let Unreadable = "판독 불가"
    static let NoAnalysis = "분석 없음"
}

class Country {
    static var korea = "KR"
    static var hongkong = "HKG"
}

class CustomerId {
    static var korea = "58046600"
    static var hongkong = "56730994"
    static var medicalAI = "56730995"
    static var medAI = "medai"
}

class MerchantId {
    static var korea = "korea"
    static var hongkong = "hongkong"
    static var medicalAI = "56730995"
    static var medAI = "MedAI"
    static var synexMedAI = "MedAIMedai"
    static var synexThailand = "MedAIThailand"
    static var synexHongkong = "MedAIHongkong"
    static var synexHannaro = "MedAIHanaro"
}

class Languages {
    static var english = "en"
    static var chinese = "zh-hk"
    static var korean = "ko"
    static var thai = "th"
}

class Keys {
    //MARK: - New
    
    //Onboarding
    static var title1 = "TITLE_1"
    static var title2 = "TITLE_2"
    static var title3 = "TITLE_3"
    static var title4 = "TITLE_4"
    static var getStarted = "GETTING_STARTED"
    
    
    //Landing
    static var synexDigital = "SYNEX"
    static var loginWithKakao = "LOGIN_WITH_KAKAO"
    static var signInAnotherWay = "SIGN_IN_ANOTHER_WAY"
    static var signUpWithEmail = "SIGN_UP_WITH_EMAIL"
    static var forgotYourId = "FORGOT_YOUR_ID"
    
    //Login Page
    static var emailAddress = "EMAIL_ADDRESS"
    static var enterEmailAddress = "ENTER_EMAIL_ADDRESS"
    static var password = "PASSWORD"
    static var confirmPassword = "CONFIRM_PASSWORD"
    static var findId = "FIND_ID"
    static var forgotPassword = "FORGOT_PASSWORD"
    static var login = "LOGIN"
    
    //Sign up
    static var signUp = "SIGN_UP"
    static var signUpButton = "Sign_Up"
    static var next = "NEXT"
    static var email = "EMAIL"
    static var confirmEmailAddress = "CONFIRM_EMAIL_ADDRESS"
    static var passwordTitle = "Password"
    static var passwordPlaceholder = "PASSWORD_PLACEHOLDER"
    static var referralCode = "Referral_Code"
    static var dontAccount = "Donot_have_an_account"
    static var alreadyAccount = "Already_have_an_account"
    static var confirm = "CONFIRM"
    static var userInformation = "USER_INFORMATION"
    static var fullName = "FULL_NAME"
    static var namePlaceholder = "NAME_PLACEHOLDER"
    static var phoneNumber = "PHONE_NUMBER"
    static var enterHealthInfo = "ENTER_YOUR_HEALTH_INFO"
    static var gender = "GENDER"
    static var dob = "DATE_OF_BIRTH"
    static var male = "MALE"
    static var female = "FEMALE"
    static var height = "HEIGHT"
    static var enterYourInformation = "ENTER_YOUR_INFORMATION"
    static var signIn = "SIGN_IN"
    static var skipNextTime = "Skip_for_Next_Time"
    static var termsConditions = "TERM_CONDITION"
    static var agreeToAllItems = "AGREE_TO_ALL_ITEMS"
    static var termsOfService = "TERM_OF_SERVICE"
    static var collectionAndUse = "COLLECTION_AND_USE"
    static var marketingInformation = "MARKETING_INFORMATION"
    
    //Home
    static var home = "HOME"
    static var hospital = "HOSPITAL"
    static var myRecord = "MY_RECORD"
    static var more = "MORE"
    static var checkYourHealth = "CHECK_YOUR_HEALTH"
    static var myHealthRecord = "MY_HEALTH_RECORD"
    static var noRecord = "NO_RECORD"
    static var noPastRecord = "NO_PAST_RECORD"
    static var add = "ADD"
    static var details = "DETAILS"
    static var appName = "EKG"
    static var normal = "Normal"
    static var bradycardia = "BRADYCARDIA"
    static var beanbag = "BEANBAG"
    static var afib = "AFIB"
    static var unclassified = "UNCLASSIFIED"
    static var unreadable = "UNREADABLE"
    static var short = "TOO_SHORT"
    static var tachycardia = "TACHYCARDIA"
    static var long = "LONG"
    static var noAnalysis = "NO_ANALYSIS"
    static var afibDesc = "AFIB_DESC"
    static var bradycardiaDesc = "BRADYCARDIA_DESC"
    static var tachycardiaDesc = "TACHYCARDIA_DESC"
    static var normalDesc = "NORMAL_DESC"
    static var unclassifiedDesc = "UNCLASSIFIED_DESC"
    static var unreadableDesc = "UNREADABLE_DESC"
    static var shortDesc = "TOO_SHORT_DESC"
    static var historyTitle = "HEART_HEALTH"
    static var firstTime = "IS_THIS_FIRST_TIME"
    static var goToUserGuide = "GO_TO_USER_GUIDE"
    
    //More
    static var healthInformation = "HEALTH_INFORMATION"
    static var myAccount = "MY_ACCOUNT"
    static var linkToKakao = "LINK_TO_KAKAO"
    static var reminder = "REMINDER"
    static var lang = "LANG"
    static var notice = "NOTICE"
    static var faq = "FAQ"
    static var customerService = "CUSTOMER_SERVICE"
    static var termsAndConditions = "TERMS_AND_CONDITIONS"
    static var appVersionStatus = "APP_VERSION_STATUS"
    static var medicalDeviceLabel = "MEDICAL_DEVICE_LABEL"
    static var kardiaMobile =  "KARDIA_MOBILE"
    static var account = "ACCOUNT"
    static var setting = "SETTING"
    static var support = "SUPPORT"
    static var website = "WEBSITE"
    
    //My Account
    static var logout = "LOG_OUT"
    static var logoutConfirm = "LOGOUT_CONFIRM"
    static var logoutDES = "YOU_MUST_LOGIN"
    static var deleteAccount = "DELETE_ACCOUNT"
    static var deleteConfirm = "DELETE_CONFIRM"
    static var deletedDesc =  "DELETE_DES"
    static var save = "SAVE"
    static var cancel =  "CANCEL"
    static var saveChanges = "SAVE_CHANGES"
    static var changesSaved = "CHANGES_SAVED"
    static var accountDeleted = "ACCOUNT_DELETED_TEXT"
    static var thanksKaily = "KAILY_GREETINGS"
    
    //Hospital
    static var registeredHospital = "REGISTERED_HOSPITAL"
    static var noRegisteredHospital = "NO_REGISTERED_HOSPITAL"
    static var delete =  "DELETE"
    static var hospitalCodeReg =  "HOSPITAL_REG_CODE"
    static var enterHospitalCode =  "ENTER_HOSPITAL_CODE"
    static var register =  "REGISTER"
    static var deleteHospital =  "DELETE_LINKED_HOS"
    static var deleteDesc =  "DELETE_DESCRIPTION"
    static var hospitalCodeLinked =  "HOSPITAL_CODE_LINKED"
    
    
    //Change Password screen
    static var changePassword = "CHANGE_PASSWORD"
    static var oldPassword = "OLD_PASSWORD"
    static var newPassword = "NEW_PASSWORD"
    static var confirmNewPassword = "CONFIRM_NEW_PASSWORD"
    static var enterPassword = "ENTER_PASSWORD"
    static var enterNewPassword = "ENTER_NEW_PASSWORD"
    static var enterConfirmPassword = "ENTER_CONFIRM_PASSWORD"
    
    //Language screen
    static var english = "ENGLISH"
    static var korean = "KOREAN"
    
   //Version Page
    static var version = "VERSION"
    static var update = "UPDATE"
    static var kaily = "KAILY"
    static var latestVersion = "LATEST_VERSION"
    
    //Terms & Conditions Page
    static var termsOfUse = "TERMS_OF_USE"
    static var privacyPolicy = "PRIVACY_POLICY"
    static var marketingConsent = "MARKETING_CONSENT"
    static var confirmed =  "CONFIRMED"
    
    //My Health Record Page
    static var records = "RECORDS"
    static var checkRecord = "CHECK_RECORD"
    static var sharePDF = "SHARE_PDF"
    static var addMemo = "ADD_MEMO"
    static var starred = "STARRED"
    static var guide = "GUIDE"
    
    //Add Notes Screen
    static var memoPlaceholder = "NOTE_PLACEHOLDER"
    
    //Search Record Page
    static var searchRecord = "SEARCH_RECORD"
    static var search = "SEARCH"
    static var searchPast = "SEARCH_PAST"
    static var searchFilter = "SEARCH_FILTER"
    static var selectDate = "SELECT_DATE"
    static var selectResult = "SELECT_RESULT"
    static var starredResult = "STARRED_RESULTS"
    static var reset = "RESET"
    static var resultOf = "RESULT_OF"
    
    //Notifications Page
    static var noticeBoard = "NOTIFICATIONS"
    static var newNotice = "NEW_NOITCE"
    static var today = "TODAY"
    static var yesterday = "YESTERDAY"
    
    //SDK PopUp
    static var selectDevice = "SELECT_DEVICE"
    static var kardiaCard = "KARDIA_CARD_TITLE"
    static var kardiaMobile6 = "KARDIA_MOBILE_6"
    static var kardiaMobile1 = "KARDIA_MOBILE_1"
    
    //Reminder
    static var setAlarm = "ALARM"
    static var noRegisteredAlarm = "NO_REG_ALARM"
    static var alarmDesc = "SET_ALARM"
    static var selectTime = "TIME"
    static var selectedDay = "DAYS"
    static var everyday = "EVERY_DAY"
    static var deleteAlarm = "DELETE_ALARM"
    static var editAlarm = "EDIT_ALARM"
    static var deleteSelectedAlarm = "DELETE_SELECTED_ALARM"
    static var timerDate = "TIMER_DATE"
    static var selectDay = "SELECT_DAY_OF_WEEK"
    static var alarmText = "DONT_FORGOT_ECG"
    static var added = "ADD"
    static var mon = "MON"
    static var tue = "TUE"
    static var wed = "WED"
    static var thu = "THU"
    static var fri = "FRI"
    static var sat = "SAT"
    static var sun = "SUN"
    
    //Result
    static var result = "RESULT"
    
    static var kardia = "Kardia"
    static var welcome = "Welcome"
    static var electrocardiogram_EKG = "Electrocardiogram_EKG"
    static var history = "HISTORY"
    static var pdfLead = "PDF_LEAD"
    static var termsTitle = "TERMS_OF_SERVICE_&_PRIVACY_POLICY"
    static var agreeTitle = "I_AGREE_TO_ALL_OF_SYNEX'S_OPERATING_PRINCIPLES"
    static var termsService = "TERMS_OF_SERVICE_AND_PRIVACY_POLICY"
    static var consentTitle = "CONSENT_TO_THIRD-PARTY_INFORMATION_SHARING"
    static var recordEKG = "Record_your_EKG"
    static var bloodPressureTitle = "Blood_Pressure"
    static var bloodPressureSubTitle = "You_don't_have_any_recordings"
    static var bloodPressureDetail = "Take_your_blood_pressure_with_your_paired_OMRON_monitor_When_you_are_done_recording_tap_the_Add_Blood_Pressure_button_below_to_transfer_your_new_recordings"
    static var addBloodPressure = "Add_Blood_Pressure"
    static var restingTitle = "Resting_Heart_Rate"
    static var restingSubTitle = "Premium_Protection_Plan_Doesnot_apply_to_Korea"
    static var restingDetail = "Start_your_day_by_capturing_this_key_heart_health_indicator_before_getting_out_of_bed"
    static var weightTitle = "WEIGHT"
    static var weightDetail = "Maintain_a_healthy_weight_to_lower_your_risk_of_developing_heart_disease_and_stroke"
    static var medicationTitle = "Medication_Tracking"
    static var medicationDetail = "Keep_a_log_of_your_medications_to_track_how_your_health_is_impacted_by_changes_or_missed_doses"
    static var insight = "Insight"
    static var searchHere = "Search_here"
    static var personalReport = "Personal_Report_for_your_doctor"
    static var downloadReport = "Download_Report"
    static var savedCloud = "Saved_in_the_cloud"
    static var customerId = "ENTER_CUSTOMER_ID"
    static var enterPatientId = "ENTER_PATIENT_ID"
    static var error_custId = "ERROR_MESSAGE_ENTER_CUSTOMER_ID"
    static var error_password = "ERROR_MESSAGE_ENTER_CUSTOMER_PASSWORD"
    static var error_patientId = "ERROR_MESSAGE_ENTER_PATIENT_ID"
    static var failed = "FAILED"
    static var getRequest = "GET_REQUEST"
    static var invalidCredentials = "INVALID_CREDENTIAL"
    static var loading =  "LOADING"
    static var lockMode = "LOCK_MODE"
    static var allowAccess = "MANDATORY_FILE_PERMISSION_DESC"
    static var permissions = "MANDATORY_PERMISSIONS_DESC"
    static var notes = "NOTES"
    static var ok = "OK"
    static var or = "OR"
    static var patientId = "PATIENT_ID"
    static var recordEcg = "RECORD_ECG"
    static var saving = "SAVING"
    static var scanBarcode = "SCAN_BARCODE"
    static var submit =  "SUBMIT"
    static var success = "SUCCESS"
    static var yes = "YES"
    static var no = "NO"
    static var disableLock =  "DISABLE_LOCK"
    static var enableLock = "ENABLE_LOCK"
    static var enterCode = "ENTER_CODE"
    static var pdfUpload = "PDF_UPLOAD"
    static var incorrectCode = "INCORRECT_CODE"
   // static var noRecordFound = "NO_RECORD_FOUND"
    static var noRecordFound = "NO_RECORD"
    static var filters = "FILTERS"
    static var determination = "DETERMINATION"
    static var date = "DATE"
    static var from = "FROM"
    static var fromDate = "FROM_DATE"
    static var to = "TO"
    static var toDate = "TO_DATE"
    static var select = "SELECT"
    static var apply = "APPLY"
    static var instantAnalysis = "INSTANT_ANALYSIS"
    static var forgotDescription = "RESET_EMAIL"
    static var sideMenuUserInfo = "SIDEBAR_USER_INFORMATION"
   
    static var finish = "FINISH"
    static var sir = "SIR"
    
    
    //MARK:- Error strings

    //Login Screen
    static var emailRequired = "EMAIL_REQUIRED"
    static var passwordRequired = "PASSWORD_REQUIRED"
    static var invalidEmail = "INVALID_EMAIL"
    static var invalidEmailPassword = "INVALID_CREDENTIALS"
    static var accountNotFound = "ACCOUNT_NOT_REGISTERED"

    //Sign Up screen
    static var confirmEmailRequired = "CONFIRM_EMAIL_REQUIRED"
    static var validateConfirmEmail = "VALIDATE_CONFIRM_EMAIL"
    static var passwordError = "PASSWORD_VALIDATION"
    static var confirmPasswordRequired = "CONFIRM_PASSWORD_REQUIRED"
    static var confirmPasswordMatch = "CONFIRM_PASSWORD_VALIDATE"
    static var invalidReferralCode = "INVALID_REFERRAL_CODE"
    static var emailExist = "EMAIL_EXIST"
    
    //User Info screen
    static var fullNameRequired = "NAME_REQUIRED"
    static var phoneNumberRequired = "PHONE_NUMBER_REQUIRED"
    static var dobRequired = "DOB_REQUIRED"
    static var phoneNumberExist = "PHONE_NUMBER_EXIST"
    static var profileSuccess = "PROFILE_UPDATE"
   
    //Forgot Password screen
    static var emailSuccess = "EMAIL_CONFIRMATION"
    
    //Reset Password screen
    static var resetPassword = "RESET_PASSWORD"
    
    //Find My Id screen
    static var findIdDesc = "ENTER_PHONE_NUMBER"
    static var popUpTitle = "REGISTERED_EMAIL"
    
    //Change Password screen
    static var oldPasswordRequired = "OLD_PASSWORD_REQUIRED"
    static var newPasswordRequired = "NEW_PASSWORD_REQUIRED"
    static var confirmNewPasswordRequired = "CONFIRM_NEW_PASSWORD_REQUIRED"
    static var passwordSuccess = "PASSWORD_CHANGED"
    static var validateConfirmPassword = "VALIDATE_NEW_PASSWOD"
}


class CellIdentifier {
    static var homeHeaderCell = "HomeHeaderCell"
    static var homeFooterCell = "HomeFooterCell"
    static var historyCell = "HistoryCell"
    static var termsConditionCell = "TermsConditionCell"
    static var sideMenuCell = "SideMenuCell"
    static var homeButtonCell = "HomeButtonCell"
    
}

class HomeItem {
    static var homeImageIcon = [UIImage(),UIImage(named: "bp"),UIImage(named: "hr"),UIImage(named: "wt"),UIImage(named: "tr"),UIImage()]
    
}

class SideMenuArray {
    static var sideMenuItem = ["Home","User Information","History","Change Password","Log out"]
}


class NormalString {
    static var history = "History"
    static var forgotPassword = "Forgot Password"
    static var kardia = "Kardia"
    static var termsCondition = "Agree to Terms of Use"
    static var chooseCountry = "Choose Country"
    static var filters = "Filters"
    static var confirmation = "Confirmation"
    static var logout = "Log out"
    static var  cancel = "Cancel"
    static var  yes = "Yes"
    static var  no = "No"



}

class ValidationString {
    static var logoutString = "Are you sure you want to log out?"
    static var deleteString = "Do you want to delete profile?"

}


