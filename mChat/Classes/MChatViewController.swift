//
//  MChatViewController.swift
//  mChat
//
//  Created by Pranjal Vyas on 13/05/22.
//

import UIKit
import WebKit
import SystemConfiguration

class MChatViewController: UIViewController , WKUIDelegate, WKScriptMessageHandler,WKNavigationDelegate {
    
    
    @IBOutlet weak var loaderView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    
    var isPresenting = false
    

    
    private var webView: WKWebView?
    
    @IBOutlet weak var webViewContainer: UIView!
    var domainString : String? = nil
    var channelKey : String? = nil
    var channelId : String? = nil
    var config : MConfig? = nil
    var logo : UIImage? = nil
    var proxyUrl = "";
    var closeIcon : UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WEBView Started")
        let userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")! + "WebViewApp " + UIDevice.modelName;
        UserDefaults.standard.register(defaults: ["UserAgent" : userAgent])
        if config?.headerColor != nil{
            headerView.backgroundColor = config!.headerColor!
        }
        if config?.headerTitleColor != nil{
            headerTitle.textColor = config!.headerTitleColor!
        }
        if config?.headerTitle != nil{
            headerTitle.text = config!.headerTitle!
        }
        if logo != nil{
            headerImage.image = logo
        }
        if closeIcon != nil{
            closeButton.setImage(closeIcon, for: .normal)
        }
        addWebView()
        self.webView!.configuration.userContentController.add(self, name: "iosListener")
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        if proxyUrl != ""{
            let cookie = HTTPCookie(properties: [
                .domain: domainString,
                .path: "/",
                .name: "CDN_URL",
                .value: proxyUrl,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31556926)
            ])!

            if #available(iOS 11.0, *) {
                self.webView!.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            } else {
                // Fallback on earlier versions
            }
        }
        if #available(iOS 14, *) {
            let preferences = WKWebpagePreferences()
            preferences.allowsContentJavaScript = true
            webView?.configuration.defaultWebpagePreferences = preferences
        }
        else {
            webView?.configuration.preferences.javaScriptEnabled = true
            /// user interaction없이 윈도우 창을 열 수 있는지 여부를 나타냄. iOS에서는 기본값이 false이다.
            webView?.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        }
        
        
        
                
        let url = URL(string: "https://"+domainString!+"/postman/ext/plugin/customer/app/chat/")
        print("https://"+domainString!+"/postman/ext/plugin/customer/app/chat/")
//                let url = URL(string: "https://www.google.com")
        
        
        

        webView?.load(URLRequest(url: url!))
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        isPresenting = false
        if (message.body as! String).contains("DOWNLOAD_FILE"){
            let data = (message.body as! String).data(using: .utf8)!
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? NSDictionary
                {
                   print(jsonObject) // use the json here
                    let myChatEvent = jsonObject.object(forKey: "myChatEvent") as? NSDictionary
                    let url = myChatEvent?.object(forKey: "url") as? String
                    loaderView.isHidden = false
                    DispatchQueue.main.async {
                        FileDownloader.loadFileAsync(url: URL(string: url!)!) { (path, error) in
                            print("PDF File downloaded to : \(path!)")
                            let fileURL = NSURL(fileURLWithPath: path!)

                            // Create the Array which includes the files you want to share
                            var filesToShare = [Any]()

                            // Add the path of the file to the Array
                            filesToShare.append(fileURL)

                            // Make the activityViewContoller which shows the share-view
                            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

                            // Show the share-view
                            DispatchQueue.main.async {
                                if !self.isPresenting{
                                    self.isPresenting = true
                                    self.present(activityViewController, animated: true, completion: {
                                        self.loaderView.isHidden = true
                                    })
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        if (message.body as! String).contains("ON_CHAT_LOAD"){
            loaderView.isHidden = true
            print("Inside ON CHAT")
//            print(config!.headerColor!.hexString!)
            var lConfig = "{\"header.disabled\" : true, \"launcher.open\" : true"
            if config != nil{
                
                if config?.chatBackgroundColor != nil{
                    lConfig = lConfig+",\"messageList.bg.color\" : \""+config!.chatBackgroundColor!.hexString!+"\""
                }
                if config?.sentMessageBubbleColor != nil{
                    lConfig = lConfig+",\"sentMessage.bg.color\" : \""+config!.sentMessageBubbleColor!.hexString!+"\""
                }
                if config?.sentMessageTextColor != nil{
                    lConfig = lConfig+",\"sentMessage.text.color\" : \""+config!.sentMessageTextColor!.hexString!+"\""
                }
                if config?.receivedMessageBubbleColor != nil{
                    lConfig = lConfig+",\"receivedMessage.bg.color\" : \""+config!.receivedMessageBubbleColor!.hexString!+"\""
                }
                
                if config?.receivedMessageTextColor != nil{
                    lConfig = lConfig+",\"receivedMessage.text.color\" : \""+config!.receivedMessageTextColor!.hexString!+"\""
                }
                if config?.userInputBackgroundColor != nil{
                    lConfig = lConfig+",\"userInput.bg.color\" : \""+config!.userInputBackgroundColor!.hexString!+"\""
                }
                if config?.userInputTextColor != nil{
                    lConfig = lConfig+",\"userInput.text.color\" : \""+config!.userInputTextColor!.hexString!+"\""
                }
                
            }
            lConfig = lConfig+"}"
            var script = "{event : \"SET_OPTIONS\""
            script = script+", options : {\"domain\" : \""+domainString!+"\""
            script = script+", \"channelId\" : \""+channelId!+"\""
            script = script+", \"channelKey\" : \""+channelKey!+"\""
            script = script+", \"config\" : "+lConfig+"}}"
            print("Script")
            print(script)
            self.webView?.evaluateJavaScript("console.log('Before mobile Listener')", completionHandler: nil)
            self.webView?.evaluateJavaScript("callMobileEventListener("+script+");", completionHandler: nil)
        }
        
    }
    
    @IBAction func onCloseClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        let source = "console.log('defining'); window.parent.postMessage = function(message,star) { console.log(message,star); webkit.messageHandlers.iosListener.postMessage(message,star)}"
        self.webView?.evaluateJavaScript(source, completionHandler: { (result, err) in
            if (err != nil) {
                // show error feedback to user.
            }
        })
        
        self.webView?.evaluateJavaScript("window.parent.postMessage('test','*');", completionHandler: { (result, err) in
            if (err != nil) {
                // show error feedback to user.
            }
        })
    }
    
    private func addWebView() {
            let webConfiguration = WKWebViewConfiguration()
            let size = CGSize.init(width: 0.0, height: self.webViewContainer.frame.size.height)
            let customFrame = CGRect.init(origin: CGPoint.zero, size: size)
            self.webView = WKWebView (frame: customFrame, configuration: webConfiguration)
            if let webView = self.webView {
                webView.translatesAutoresizingMaskIntoConstraints = false
                self.webViewContainer.addSubview(webView)
                webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
                webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
                webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
                webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
                webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor).isActive = true
                webView.uiDelegate = self
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WKWebView {

    func addInitialScaleMetaTag() {
        evaluateJavaScript(
        """
            var meta = document.createElement("meta");
            meta.name = "viewport";
            meta.content = "initial-scale=1.0";
            document.getElementsByTagName('head')[0].appendChild(meta);
        """) { result, error in
            // handle error
        }
    }
}

extension UIColor {
    var hexString: String? {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
}

public extension UIDevice {
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    func mapToDevice(identifier: String) -> String {
      #if os(iOS)
      switch identifier {
      case "iPod5,1":                                 return "iPod Touch 5"
      case "iPod7,1":                                 return "iPod Touch 6"
      case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
      case "iPhone4,1":                               return "iPhone 4s"
      case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
      case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
      case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
      case "iPhone7,2":                               return "iPhone 6"
      case "iPhone7,1":                               return "iPhone 6 Plus"
      case "iPhone8,1":                               return "iPhone 6s"
      case "iPhone8,2":                               return "iPhone 6s Plus"
      case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
      case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
      case "iPhone8,4":                               return "iPhone SE"
      case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
      case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
      case "iPhone10,3", "iPhone10,6":                return "iPhone X"
      case "iPhone11,2":                              return "iPhone XS"
      case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
      case "iPhone11,8":                              return "iPhone XR"
      case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
      case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
      case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
      case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
      case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
      case "iPad6,11", "iPad6,12":                    return "iPad 5"
      case "iPad7,5", "iPad7,6":                      return "iPad 6"
      case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
      case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
      case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
      case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
      case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
      case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
      case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
      case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
      case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
      case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
      case "AppleTV5,3":                              return "Apple TV"
      case "AppleTV6,2":                              return "Apple TV 4K"
      case "AudioAccessory1,1":                       return "HomePod"
      case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
      default:                                        return identifier
      }
      #elseif os(tvOS)
      switch identifier {
      case "AppleTV5,3": return "Apple TV 4"
      case "AppleTV6,2": return "Apple TV 4K"
      case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
      default: return identifier
      }
      #endif
    }
    
    return mapToDevice(identifier: identifier)
  }()
}


class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}
