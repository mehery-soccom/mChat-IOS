//
//  MConfig.swift
//  mChat
//
//  Created by Pranjal Vyas on 16/05/22.
//

import Foundation


public class MConfig{
    public var headerTitle : String?
    public var headerColor : UIColor?
    public var headerTitleColor : UIColor?
    public var chatBackgroundColor : UIColor?
    public var sentMessageBubbleColor : UIColor?
    public var receivedMessageBubbleColor : UIColor?
    public var sentMessageTextColor : UIColor?
    public var receivedMessageTextColor : UIColor?
    public var userInputBackgroundColor : UIColor?
    public var userInputTextColor : UIColor?
    
    
    public init(headerTitle : String){
        self.headerTitle = headerTitle
    }        
    
}
