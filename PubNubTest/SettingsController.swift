//
//  SettingsController.swift
//  PubNubTest
//
//  Created by Scott Richards on 10/13/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import PubNub

class SettingsController: UIViewController, PNObjectEventListener, UITextFieldDelegate {
    @IBOutlet weak var userNameField: UITextField!

    var appDelegate : AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.appDelegate!.client.addListener(self)
        var currentRoom : String = ""
        currentRoom = (appDelegate?.appState.currentRoom)!
        self.appDelegate!.client.getUserName( channel: currentRoom,
                                              onSuccess: { userName in
                                                self.userNameField.text = userName
                                                self.userNameField.resignFirstResponder()
            }, onError: {}
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // invoked whne user clicks update to update the user name
    func updateUserName(userName:String) {
        var currentRoom : String = ""
        currentRoom = (appDelegate?.appState.currentRoom)!
        self.appDelegate!.client.setUserName(userName: userName, channel: currentRoom,
                                             onSuccess: {
                                                self.appDelegate?.appState.currentUserName = userName
                                                self.userNameField.resignFirstResponder()
                                                self.navigationController?.popViewController(animated: true)
        })
    }
    
    // --------------------------------
    // MARK: - Actions
    // --------------------------------
    
    
    @IBAction func updateSettings(_ sender: AnyObject) {
        if let userName = userNameField.text {
            updateUserName(userName: userName)
        }
    }
    

    // --------------------------------
    // MARK: - Text Field Handling
    // --------------------------------
    
    // Handle Return dismiss keyboard by resignFirstResponder on the textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // dismiss editing whenever user touches oustide of edit field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

}
