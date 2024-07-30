
import UIKit

class PageContentViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblForSubtitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var itemIndex:Int = 0
    var imageName:String?
    var titleString:String = ""
    var subTitleString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentImage = imageName {
            imageView.image = UIImage(named: currentImage)
        }
        lblTitle.text = titleString
       // lblForSubtitle.text = subTitleString
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
