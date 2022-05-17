# mChat - Android
## _Chat SDK for Mehery_

mChat - Android is a an android SDK for enabling to add Mehery Chat in you application.

## Features

- Get the key and domain on Mehery and start a hassle free journey to add customer support chat to your application
- Customize the look and feel of the chat window , each and every element is customizable to your needs and app theme


## Setup

To start with the integration we would first need to setup our webchat. For this login to admin panel for Mehery. Go to channel and add a new WebChat channel.

![image description](https://raw.githubusercontent.com/mehery-soccom/mChat-Android/master/images/Readme1.PNG)

On clicking Webchat you would need to fill in some details.

![image description](https://raw.githubusercontent.com/mehery-soccom/mChat-Android/master/images/Readme2.PNG)

Once thats done please copy the content of script, you will require it.

![image description](https://raw.githubusercontent.com/mehery-soccom/mChat-Android/master/images/Readme3.PNG)

## Installation

mChat is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'mChat'
```

## Usage

To initialise and start mChat

```swift
MChat.init().start(domain: domainText, channelKey: channelKeyText, channelId: channelIdText,logo: UIImage.init(named: "logo")!,config: config, viewController: self)
```

For Config initialization : 

```swift
let config = MConfig.init(headerTitle: headerTitleText)
```

For further customization :

|Attribute|Description|Default Value
|headerColor|This is for chaning color of the header|#FFFFFF
|headerTitleColoe|This is for changing color of the title of the header|#000000
|chatBackgroundColor|This is for changing background color of tha chat message listing|#FFFFFF
|sentMessageBubbleColor|This is to change the bacground color of chat bubble for sent messages|#FE8BFF
|sentMessageTextColor|This is to change the text color of the sent messages|#FFFFFF
|receivedMessageBubbleColor|This is to change the bacground color of chat bubble for received messages|#ECECEC
|receivedMessageTextColor|This is to change the text color of the received messages|#000000
|userInputBackgroundColor|This is to change the background color of the user input box at bottom|#FFFFFF
|userInputTextColor|This is to change the text color of the user input box at bottom|#000000

To check the flow and test, please clone this repository and check out the sample app.

## Author

pranjal7163, pranjal.3vyas@gmail.com

## License

mChat is available under the MIT license. See the LICENSE file for more info.
