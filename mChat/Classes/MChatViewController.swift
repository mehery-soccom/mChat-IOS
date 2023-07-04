//
//  MChatViewController.swift
//  mChat
//
//  Created by Pranjal Vyas on 13/05/22.
//

import UIKit
import WebKit

class MChatViewController: UIViewController , WKUIDelegate, WKScriptMessageHandler,WKNavigationDelegate {
    
    
    @IBOutlet weak var loaderView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    

    
    private var webView: WKWebView?
    
    @IBOutlet weak var webViewContainer: UIView!
    var domain : String? = nil
    var channelKey : String? = nil
    var channelId : String? = nil
    var config : MConfig? = nil
    var logo : UIImage? = nil
    var url = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WEBView Started")
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
        addWebView()
        self.webView!.configuration.userContentController.add(self, name: "iosListener")
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
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
                
        let url = URL(string: "https://"+domain!+"/postman/ext/plugin/customer/app/chat/")
        print("https://"+domain!+"/postman/ext/plugin/customer/app/chat/")
//                let url = URL(string: "https://www.google.com")
        
        
        self.url = "https://"+domain!+"/postman/ext/plugin/customer/app/chat/"

        webView?.load(URLRequest(url: url!))
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        if (message.body as! String).contains("ON_CHAT_LOAD"){
            loaderView.isHidden = true
            print("Inside ON CHAT")
            print(config!.headerColor!.hexString!)
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
            script = script+", options : {\"domain\" : \""+domain!+"\""
            script = script+", \"channelId\" : \""+channelId!+"\""
            script = script+", \"channelKey\" : \""+channelKey!+"\""
            script = script+", \"config\" : "+lConfig+"}}"
            print("Script")
            print(script)
            self.webView?.evaluateJavaScript("console.log('Before mobile Listener')", completionHandler: nil)
            self.webView?.evaluateJavaScript("callMobileEventListener("+script+");", completionHandler: nil)
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       //load cookie of current domain
        self.webView!.loadDiskCookies(for: URL(string: self.url)!.host!){
            decisionHandler(.allow)
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
       //write cookie for current domain
        self.webView!.writeDiskCookies(for: URL(string: self.url)!.host!){
            decisionHandler(.allow)
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
    
    enum PrefKey {
        static let cookie = "cookies"
    }

    func writeDiskCookies(for domain: String, completion: @escaping () -> ()) {
        fetchInMemoryCookies(for: domain) { data in
            print("write data", data)
            UserDefaults.standard.setValue(data, forKey: PrefKey.cookie + domain)
            completion();
        }
    }


     func loadDiskCookies(for domain: String, completion: @escaping () -> ()) {
        if let diskCookie = UserDefaults.standard.dictionary(forKey: (PrefKey.cookie + domain)){
            fetchInMemoryCookies(for: domain) { freshCookie in

                let mergedCookie = diskCookie.merging(freshCookie) { (_, new) in new }

                for (_, cookieConfig) in mergedCookie {
                    let cookie = cookieConfig as! Dictionary<String, Any>

                    var expire : Any? = nil

                    if let expireTime = cookie["Expires"] as? Double{
                        expire = Date(timeIntervalSinceNow: expireTime)
                    }

                    let newCookie = HTTPCookie(properties: [
                        .domain: cookie["Domain"] as Any,
                        .path: cookie["Path"] as Any,
                        .name: cookie["Name"] as Any,
                        .value: cookie["Value"] as Any,
                        .secure: cookie["Secure"] as Any,
                        .expires: expire as Any
                    ])

                    if #available(iOS 11.0, *) {
                        self.configuration.websiteDataStore.httpCookieStore.setCookie(newCookie!)
                    } else {
                        // Fallback on earlier versions
                    }
                }

                completion()
            }

        }
        else{
            completion()
        }
    }

    func fetchInMemoryCookies(for domain: String, completion: @escaping ([String: Any]) -> ()) {
        var cookieDict = [String: AnyObject]()
        if #available(iOS 11.0, *) {
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
                for cookie in cookies {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                }
                completion(cookieDict)
            }
        } else {
            // Fallback on earlier versions
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
