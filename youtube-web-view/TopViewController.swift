import UIKit

class TopViewController: UIViewController {
    private let segueId = "toYoutubeWebViewController"
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var fullScreenSwitch: UISwitch!
    @IBOutlet weak var controlBarSwitch: UISwitch!
    @IBOutlet weak var relatedVideoSwitch: UISwitch!
    @IBOutlet weak var videoInfoSwitch: UISwitch!
    
    @IBAction func onStartButton(sender: UIButton) {
        performSegueWithIdentifier(segueId, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueId {
            let des = segue.destinationViewController as! YoutubeViewController
            des.urlString = urlTextField.text
            des.relatedVideo = relatedVideoSwitch.on
            des.fullScreen = fullScreenSwitch.on
            des.controlBar = controlBarSwitch.on
            des.videoInfo = videoInfoSwitch.on
        }
    }
}
