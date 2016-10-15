//
//  PubNubExtension.swift
//  PubNubTest
//
//  Created by Scott Richards on 10/13/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import PubNub

public extension PubNub {
//    static let UserNameKey : String = "userName"    // Key to save away the user name
    
    func getUUID() -> String {
        let configuration = self.currentConfiguration()
        return configuration.uuid
    }
    
    func getUserNameForUUID(uuid:String, onSuccess:@escaping (String) -> (), onError:@escaping () -> ()) {
        self.stateForUUID(uuid, onChannel: "cycling", withCompletion:{
            (result, status) in
            
            if status == nil {
                
                // Handle downloaded state information using: result.data.state
                print("result: \(result?.data.state)")
                if let resultDictionary = result?.data.state {
                    if let userName = resultDictionary[Constants.PubNubKeys.UserName] as? String {
                        onSuccess(userName)
                        //return userName
                    } else {
                        onError()
                    }
                } else {
                    onError()
                }
            }
            else{
                onError()
            }
        })
    }

    
    func getUserName(onSuccess:@escaping (String) -> (), onError:@escaping () -> ()) {
        self.getUserNameForUUID(uuid: self.getUUID(), onSuccess: onSuccess, onError: onError)
    }
    
    func setUserName(userName:String, onSuccess:@escaping () -> ()) {
        let userNameState = [Constants.PubNubKeys.UserName : userName]
        let configuration = self.currentConfiguration()
        
        self.setState(userNameState, forUUID: configuration.uuid, onChannel: "cycling", withCompletion:{
            (status) in
            
            if !status.isError {
                print("success setting user name")
                onSuccess()
                // Client state successfully modified on specified channel.
            }
            else {
                print("ERROR: setting user name")
                /**
                 Handle client state modification error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 
                 Request can be resent using: status.retry()
                 */
            }
            
        })
    }
    
    
}
