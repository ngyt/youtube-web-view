import UIKit

class YoutubeWebView: UIWebView {
    
    private let urlPrefix = "https://www.youtube.com/watch?v="
    
    enum YoutubeError: ErrorType {
        case InvalidUrl
        case InvalidVideoId
        case FileNotFound
        case FileReadFail
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func loadVideoIdOf(videoId: String, relatedVideo: Bool = false, playInline: Bool = false, controlBar: Bool = false, showVideoInfo: Bool = false) throws {
        if let url = videoIdToUrl(videoId) {
            return try load(videoId, url: url, relatedVideo: relatedVideo, playInline: playInline, controlBar: controlBar, showVideoInfo: showVideoInfo)
        } else {
            throw YoutubeError.InvalidVideoId
        }
    }
    
    func loadUrl(url: NSURL, relatedVideo: Bool = false, playInline: Bool = false, controlBar: Bool = false, showVideoInfo: Bool = false) throws {
        if let videoId = urlToVideoId(url) {
            return try load(videoId, url: url, relatedVideo: relatedVideo, playInline: playInline, controlBar: controlBar, showVideoInfo: showVideoInfo)
        } else {
            throw YoutubeError.InvalidUrl
        }
    }
    
    private func load(videoId: String, url: NSURL, relatedVideo: Bool = false, playInline: Bool = false, controlBar: Bool = false, showVideoInfo: Bool = false) throws {
        allowsInlineMediaPlayback = true
        mediaPlaybackRequiresUserAction = false
        scrollView.scrollEnabled = false
        
        // format html
        guard let htmlFilePath = NSBundle.mainBundle().pathForResource("youtube", ofType: "html") else {
            throw YoutubeError.FileNotFound
        }
        
        do {
            let html = try String(contentsOfFile: htmlFilePath)
            
            var result = html.stringByReplacingOccurrencesOfString("TBD_Width", withString: "\(frame.width)")
            result = result.stringByReplacingOccurrencesOfString("TBD_Height", withString: "\(frame.height)")
            result = result.stringByReplacingOccurrencesOfString("TBD_VideoId", withString: videoId)
            result = result.stringByReplacingOccurrencesOfString("TBD_Rel", withString: relatedVideo.logicValue)
            result = result.stringByReplacingOccurrencesOfString("TBD_PlayInline", withString: playInline.logicValue)
            result = result.stringByReplacingOccurrencesOfString("TBD_Control", withString: controlBar.logicValue)
            result = result.stringByReplacingOccurrencesOfString("TBD_ShowInfo", withString: showVideoInfo.logicValue)

            loadHTMLString(result, baseURL: url)
        } catch {
            throw YoutubeError.FileReadFail
        }
    }
    
    private func urlToVideoId(url: NSURL) -> String? {
        if url.absoluteString.hasPrefix(urlPrefix) {
            return url.absoluteString.substringFromIndex(urlPrefix.endIndex)
        } else {
            return nil
        }
    }
    
    private func videoIdToUrl(videoId: String) -> NSURL? {
        return NSURL(string: urlPrefix + videoId)
    }
}

extension Bool {
    var logicValue: String {
        return self ? "1" : "0"
    }
}