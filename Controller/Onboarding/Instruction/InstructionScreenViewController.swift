
import UIKit

class InstructionScreenViewController: BaseVC {
    //MARK: - getObject method
    class func getObject() -> InstructionScreenViewController?{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: InstructionScreenViewController.className) as? InstructionScreenViewController{
            return controller
        }
        return nil
    }
   
    
    var pageIndex:Int = 0
    fileprivate var pageViewController : UIPageViewController!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var btnForLogin: UIButton!
    @IBOutlet weak var btnForCross: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    private var arraForImages = ["mockup1_en","mockup2_en","mockup3_en","mockup4_en"]
    private var arraForTitle = [String]()
    private var arraForSubTitle = [String]()
    
    var timer:Timer?
    var languageStrings = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Global.getDataFromUserDefaults(.terms) != nil) {
            if let controller = LandingVC.getObject() {
                self.navigationController?.pushViewController(controller, animated: false)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: NSNotification.Name(rawValue: "refreshLanguage"), object: nil)
        self.navigationController?.isNavigationBarHidden = true
        initialSetup()
       
       
        // Do any additional setup after loading the view.
    }
   
    override func viewDidDisappear(_ animated: Bool) {
       // timer?.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        var languageString = ""
        if languageString.getLanguage() == "ko"{
            arraForImages = ["mockup1_ko","mockup2_ko","mockup3_ko","mockup4_ko"]
        }
        loadContentView()
    }
    @objc func refresh(notification: NSNotification) {
        //handle appearing of keyboard here
        //btnForLogin.setTitle("Next", for: .normal)
        pageIndex = 0
        loadContentView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func initialSetup(){
        languageStrings = Global.readStrings()
        let title1 = languageStrings[Keys.title1] as? String ?? "TITLE_1"
        let title2 = languageStrings[Keys.title2] as? String ?? "TITLE_2"
        let title3 = languageStrings[Keys.title3] as? String ?? "TITLE_3"
        let title4 = languageStrings[Keys.title4] as? String ?? "TITLE_4"
        btnForLogin.setTitle(languageStrings[Keys.next] as? String, for: .normal)
        arraForTitle = [title1,title2,title3,title4]
    }
    
    func timerFunction() {
        if pageIndex < arraForImages.count - 1 {
            pageIndex = pageIndex + 1
            self.pagerFunction()
        }else{
            pageIndex = 0
            self.pagerFunction()
        }
    }
   func pagerFunction()  {
       if pageIndex == 3 {
       btnForLogin.setTitle(languageStrings[Keys.getStarted] as? String, for: .normal)
       }else{
       btnForLogin.setTitle(languageStrings[Keys.next] as? String, for: .normal)
       }
        let contentVC = self.storyboard?.instantiateViewController(withIdentifier: PageContentViewController.className) as! PageContentViewController
        contentVC.itemIndex = pageIndex
        contentVC.imageName =  arraForImages[pageIndex]
        contentVC.titleString = arraForTitle[pageIndex]
        let contentController = viewControllerAtIndex(index: pageIndex)
        pageControl.currentPage = pageIndex
        let contentControllers = [contentController]
        self.pageViewController.setViewControllers(contentControllers , direction: .forward, animated: true, completion: nil)
    }
    
    
    private func loadContentView(){
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        let contentController = viewControllerAtIndex(index: 0)
        let contentControllers = [contentController]
        self.pageViewController.setViewControllers(contentControllers as [UIViewController], direction: .forward, animated: true, completion: nil)
        self.addChild(self.pageViewController)
        self.pageViewController.didMove(toParent: self)
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.pageView.frame.size.width, height: self.pageView.frame.size.height)
        self.pageView.addSubview(self.pageViewController.view)
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer1) in
//            self.timerFunction()
//        })
    }
    
    private func viewControllerAtIndex(index:Int)-> PageContentViewController{
        let contentVC = self.storyboard?.instantiateViewController(withIdentifier: PageContentViewController.className) as! PageContentViewController
        contentVC.itemIndex = index
        contentVC.imageName =  arraForImages[index]
        contentVC.titleString = arraForTitle[index]
        //contentVC.subTitleString = arraForSubTitle[index]
        return contentVC
    }
    //MARK: All Actions:---
    
    @IBAction func actionForLogin(_ sender: Any) {
        if pageIndex == 3 {
       // timer?.invalidate()
        if let controller = LandingVC.getObject(){
                self.navigationController?.pushViewController(controller, animated: true)
          }
        }else{
        timerFunction()
        }
    }
    
    @IBAction func actionForCross(_ sender: Any) {
       // timer?.invalidate()
        if let controller = LandingVC.getObject(){
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}


//MARK:----------------------------Extentions----------------------------
extension InstructionScreenViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! PageContentViewController
        var index = contentVC.itemIndex
        pageIndex = contentVC.itemIndex
        if index ==  0 || index == NSNotFound{
            return nil
        }
        if index !=  0  {
            index = index-1
        }
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if pageIndex + 1 == 4 || pageIndex == NSNotFound{
            return nil
        }
        return viewControllerAtIndex(index: pageIndex + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed){
            return
        }
        let contentVC = pageViewController.viewControllers!.first as! PageContentViewController
        pageIndex = contentVC.itemIndex
        pageControl.currentPage = pageIndex
        if pageIndex == 3 {
        btnForLogin.setTitle(languageStrings[Keys.getStarted] as? String, for: .normal)
        }else{
        btnForLogin.setTitle(languageStrings[Keys.next] as? String, for: .normal)
        }
        
    }
}
