//
//  ViewController.swift
//  mChat
//
//  Created by pranjal7163 on 05/13/2022.
//  Copyright (c) 2022 pranjal7163. All rights reserved.
//

import UIKit
import mChat

@available(iOS 14.0, *)
class ViewController: UIViewController {
    
    @IBOutlet weak var domainTV: UITextField!
    @IBOutlet weak var channelIdTV: UITextField!
    @IBOutlet weak var channelKeyTV: UITextField!
    @IBOutlet weak var headerTitleTV: UITextField!
    
    @IBOutlet weak var headerColorButton: UIButton!
    @IBOutlet weak var headerTitleColorButton: UIButton!
    @IBOutlet weak var chatBackgroundButtonColor: UIButton!
    @IBOutlet weak var sentMessageBubbleColorButton: UIButton!
    @IBOutlet weak var receivedMessageBubbleColor: UIButton!
    @IBOutlet weak var sentMessageTextColor: UIButton!
    @IBOutlet weak var receivedMessageTextColor: UIButton!
    @IBOutlet weak var userInputBackgroundColor: UIButton!
    @IBOutlet weak var userInputTextColor: UIButton!
    let picker = UIColorPickerViewController()
    
    var selectedButton = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setView()
//        MChat.init().start(domain: "pranjal.mehery.io", channelKey: "1gnk3z3llr9dcBI0PWZRCLE", channelId: "web:pranjal.mehery.io", viewController: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setView(){
        domainTV.text = "pranjal.mehery.io"
        channelIdTV.text = "web:pranjal.mehery.io"
        channelKeyTV.text = "1gntxihfyriyq1CGRJX3SAM"
        headerTitleTV.text = "Support"
    }

    @IBAction func onHeaderColorClicked(_ sender: Any) {
        selectedButton = "HeaderTitle"
        invokeColorPicker(tappedView: self.view)
        
    }
    
    @IBAction func onHeaderTitleColorClicked(_ sender: Any) {
        selectedButton = "HeaderTitleColor"
        invokeColorPicker(tappedView: self.view)
    }
    
    
    @IBAction func onChatBackgroundColorClicked(_ sender: Any) {
        selectedButton = "ChatBackground"
        invokeColorPicker(tappedView: self.view)
    }
    
    
    @IBAction func onSentBubbleBackgroundColorClicked(_ sender: Any) {
        selectedButton = "sentBubbleBackground"
        invokeColorPicker(tappedView: self.view)
    }
    
    @IBAction func onSentBubbleTextColorClicked(_ sender: Any) {
        selectedButton = "sentBubbleText"
        invokeColorPicker(tappedView: self.view)
    }
    
    
    @IBAction func onReceivedBubbleBackgroundColorClicked(_ sender: Any) {
        selectedButton = "receivedBubbleBackground"
        invokeColorPicker(tappedView: self.view)
    }
    
    @IBAction func onReceivedBubbleTextColorClicked(_ sender: Any) {
        selectedButton = "receivedBubbleText"
        invokeColorPicker(tappedView: self.view)
    }
    
    @IBAction func onUserInputBubbleBackgroundColorClicked(_ sender: Any) {
        selectedButton = "userInputBubbleBackground"
        invokeColorPicker(tappedView: self.view)
    }
    
    @IBAction func onUserInputBubbleTextColorClicked(_ sender: Any) {
        selectedButton = "userInputBubbleText"
        invokeColorPicker(tappedView: self.view)
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        if domainTV.text != "" && channelIdTV.text != "" && channelKeyTV.text != "" && headerTitleTV.text != ""{
            let config = MConfig.init(headerTitle: headerTitleTV.text!)
            config.headerColor = headerColorButton.backgroundColor
            config.headerTitleColor = headerTitleColorButton.backgroundColor
            config.chatBackgroundColor = chatBackgroundButtonColor.backgroundColor
            config.sentMessageBubbleColor = sentMessageBubbleColorButton.backgroundColor
            config.sentMessageTextColor = sentMessageTextColor.backgroundColor
            config.receivedMessageBubbleColor = receivedMessageBubbleColor.backgroundColor
            config.receivedMessageTextColor = receivedMessageTextColor.backgroundColor
            config.userInputBackgroundColor = userInputBackgroundColor.backgroundColor
            config.userInputTextColor = userInputTextColor.backgroundColor
            
            MChat.init().start(domain: domainTV.text!, channelKey: channelKeyTV.text!, channelId: channelIdTV.text!,logo: UIImage.init(named: "robot")!,config: config, viewController: self)
        }
        
        
    }
    func invokeColorPicker(tappedView : UIView){
        picker.selectedColor = tappedView.backgroundColor!
        self.present(picker, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

@available(iOS 14.0, *)
extension ViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        switch(selectedButton){
            case "HeaderTitle":
                headerColorButton.backgroundColor = viewController.selectedColor
                break;
        case "HeaderTitleColor":
            headerTitleColorButton.backgroundColor = viewController.selectedColor
            break;
        case "ChatBackground":
            chatBackgroundButtonColor.backgroundColor = viewController.selectedColor
            break;
        case "sentBubbleBackground":
            sentMessageBubbleColorButton.backgroundColor = viewController.selectedColor
            break;
        case "sentBubbleText":
            sentMessageTextColor.backgroundColor = viewController.selectedColor
            break;
        case "receivedBubbleBackground":
            receivedMessageBubbleColor.backgroundColor = viewController.selectedColor
            break;
        case "receivedBubbleText":
            receivedMessageTextColor.backgroundColor = viewController.selectedColor
            break;
        case "userInputBubbleBackground":
            userInputBackgroundColor.backgroundColor = viewController.selectedColor
            break;
        case "userInputBubbleText":
            userInputTextColor.backgroundColor = viewController.selectedColor
            break;
            default:
                break;
        }
        
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        switch(selectedButton){
            case "HeaderTitle":
                headerColorButton.backgroundColor = viewController.selectedColor
                break;
        case "HeaderTitleColor":
            headerTitleColorButton.backgroundColor = viewController.selectedColor
            break;
        case "ChatBackground":
            chatBackgroundButtonColor.backgroundColor = viewController.selectedColor
            break;
        case "sentBubbleBackground":
            sentMessageBubbleColorButton.backgroundColor = viewController.selectedColor
            break;
        case "sentBubbleText":
            sentMessageTextColor.backgroundColor = viewController.selectedColor
            break;
        case "receivedBubbleBackground":
            receivedMessageBubbleColor.backgroundColor = viewController.selectedColor
            break;
        case "receivedBubbleText":
            receivedMessageTextColor.backgroundColor = viewController.selectedColor
            break;
        case "userInputBubbleBackground":
            userInputBackgroundColor.backgroundColor = viewController.selectedColor
            break;
        case "userInputBubbleText":
            userInputTextColor.backgroundColor = viewController.selectedColor
            break;
            default:
                break;
        }
    }
}

