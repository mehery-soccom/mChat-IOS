//
//  MChat.swift
//  mChat
//
//  Created by Pranjal Vyas on 13/05/22.
//

import Foundation

public class MChat{
    
    public init(){
        
    }
    
    public func start(domain : String, channelKey : String, channelId : String,logo : UIImage,config : MConfig,viewController : UIViewController){
         let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "mChatStoryboard", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "mChatVC") as? MChatViewController
         vc!.domain = domain
         vc!.channelId = channelId
         vc!.channelKey = channelKey
         vc!.config = config
         vc!.logo = logo
         vc!.modalPresentationStyle = .fullScreen
         
         DispatchQueue.main.async {
             viewController.present(vc!, animated: true)
         }
    }
    
}
