//
//  ViewController.swift
//  PubNubTest
//
//  Created by Scott Richards on 10/13/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import PubNub

class ViewController: UIViewController, PNObjectEventListener {
    @IBOutlet weak var conversationView: UITextView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var helloUserName: UILabel!
    var appDelegate : AppDelegate?
    var outDateFormatter : DateFormatter = DateFormatter()
    var currentChannel : String = "cycling"
    var firstPost : Bool = true
    var userList : UserList?
    var currentUserName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.appDelegate!.client.addListener(self)
        outDateFormatter.dateStyle = .short
        outDateFormatter.timeStyle = .medium
        if (userList == nil) {
            userList = UserList(client: appDelegate!.client)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate!.client.getUserName(
            onSuccess: {userName in
                self.title = userName
                if (userName.isEmpty) {
                    self.performSegue(withIdentifier: "userSettings", sender: self)
                } else {
                    self.helloUserName.text = "Hello, \(userName)"
                    print("Hello, \(userName)")
                }
            }, onError: {
                self.helloUserName.text = "LogIn"
                self.performSegue(withIdentifier: "userSettings", sender: self)
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSendMessage(_ sender: AnyObject) {
        if let message : String = messageField.text {
            postMessage(message: message)
        }
        
    }
    
    func postMessage(message:String) {
        // Select last object from list of channels and send message to it.
        let targetChannel = appDelegate!.client.channels().last!
        appDelegate!.client.publish(message, toChannel: targetChannel,
                                    compressed: false, withCompletion: { (publishStatus) -> Void in
                                        
                                        if !publishStatus.isError {
                                            self.messageField.text = ""
                                            // Message successfully published to specified channel.
                                        }
                                        else {
                                            
                                            /**
                                             Handle message publish error. Check 'category' property to find out
                                             possible reason because of which request did fail.
                                             Review 'errorData' property (which has PNErrorData data type) of status
                                             object to get additional information about issue.
                                             
                                             Request can be resent using: publishStatus.retry()
                                             */
                                        }
        })

    }

    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        let channel = message.data.channel
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            
            // Message has been received on channel group stored in message.data.subscription.
        }
        else {
            
            // Message has been received on channel stored in message.data.channel.
        }
        if let messageData = message.data.message {
            var postDateStr: String = ""
            let uuid = message.uuid
            var userName : String = ""
            if let userNameFromId = userList?.getUserNameByUUID(uuid: uuid) {
                userName = userNameFromId
            }
            if let timeToken : Double = message.data.timetoken as Double? {
                let timeSince1970 = timeToken / 10000000
                let timeInterval : TimeInterval = TimeInterval(timeSince1970)
                let postDate = Date(timeIntervalSince1970: timeInterval)
                postDateStr = outDateFormatter.string(from: postDate)
            }
            let newMessage : String = userName + " at " + postDateStr + " said:\n" + String(describing:messageData)
            if (!firstPost) {
                self.conversationView.text = self.conversationView.text + "\n"
            }
            self.conversationView.text = self.conversationView.text + newMessage
            firstPost = false
            print("Received message: \(newMessage) on channel '\(message.data.channel)' " +
                "at \(postDateStr)")
        }
    }
    
    // New presence event handling.
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.channel != event.data.subscription {
            
            // Presence event has been received on channel group stored in event.data.subscription.
        }
        else {
            
            // Presence event has been received on channel stored in event.data.channel.
        }
        
        if event.data.presenceEvent != "state-change" {
            if (event.data.presenceEvent == "join") {   // if user joined then add user id
                if let uuid = event.data.presence.uuid {
                    userList?.addUserByUUID(uuid: uuid)
                }
            }
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {  // This is a state change
            
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) on \(event.data.channel) to:\n" +
                "\(event.data.presence.state)");
            if let uuid = event.data.presence.uuid {
                userList?.addUserByUUID(uuid: uuid)
            }
        }
    }

}

