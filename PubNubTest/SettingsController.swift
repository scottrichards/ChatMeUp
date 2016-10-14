//
//  SettingsController.swift
//  PubNubTest
//
//  Created by Scott Richards on 10/13/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import PubNub

class SettingsController: UIViewController, PNObjectEventListener {
    @IBOutlet weak var userNameField: UITextField!

    var appDelegate : AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.appDelegate!.client.addListener(self)
        self.appDelegate!.client.getUserName( onSuccess: { userName in
            self.userNameField.text = userName
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func updateSettings(_ sender: AnyObject) {
        if let userName = userNameField.text {
            updateUserName(userName: userName)
        }
    }
    
    func updateUserName(userName:String) {
//        let userNameState = ["userName" : userName]
//        let configuration = self.appDelegate!.client.currentConfiguration()
        
        self.appDelegate!.client.setUserName(userName: userName)
        
//        self.appDelegate!.client.setState(userNameState, forUUID: configuration.uuid, onChannel: "cycling", withCompletion:{
//            (status) in
//            
//            if !status.isError {
//                print("success setting user name")
//                // Client state successfully modified on specified channel.
//            }
//            else {
//                print("ERROR: setting user name")
//                /**
//                 Handle client state modification error. Check 'category' property
//                 to find out possible reason because of which request did fail.
//                 Review 'errorData' property (which has PNErrorData data type) of status
//                 object to get additional information about issue.
//                 
//                 Request can be resent using: status.retry()
//                 */
//            }
//        
//        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
