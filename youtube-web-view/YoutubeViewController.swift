import UIKit

class YoutubeViewController: UIViewController {
    
    @IBOutlet var youtubeWebView: YoutubeWebView!
    var urlString: String?
    var relatedVideo: Bool = false
    var fullScreen: Bool = false
    var controlBar: Bool = false
    var videoInfo: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.translucent = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let urlString = urlString, let url = NSURL(string: urlString) else {
            showAlert("Error", message: "URL error.")
            return
        }
        
        do {
            try youtubeWebView.loadUrl(url, relatedVideo: relatedVideo, playInline: !fullScreen, controlBar: controlBar, showVideoInfo: videoInfo)
        } catch YoutubeWebView.YoutubeError.InvalidUrl {
            self.showAlert("Error", message: "Invalid url.")
        } catch YoutubeWebView.YoutubeError.InvalidVideoId {
            self.showAlert("Error", message: "Invalid video ID.")
        } catch YoutubeWebView.YoutubeError.FileNotFound {
            self.showAlert("Error", message: "youtube.html not found.")
        } catch YoutubeWebView.YoutubeError.FileReadFail {
            self.showAlert("Error", message: "Fail to read file.")
        } catch {
            self.showAlert("Error", message: "Load error.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        presentViewController(alert, animated: true, completion: nil)
    }
}