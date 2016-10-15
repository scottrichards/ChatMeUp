//
//  PubNubExtension.swift
//  PubNubTest
//
//  Created by Scott Richards on 10/13/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import PubNub

// PubNub Extension Utility Functions to get and set user name
public extension PubNub {
    
    func getUUID() -> String {
        let configuration = self.currentConfiguration()
        return configuration.uuid
    }

    // returns the username for the specified uuid
    func getUserNameForUUID(uuid:String, channel:String, onSuccess:@escaping (String) -> (), onError:@escaping () -> ()) {
        self.stateForUUID(uuid,
                          onChannel: channel,
                          withCompletion:{
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

    // returns the current users UserName
    func getUserName(channel:String, onSuccess:@escaping (String) -> (), onError:@escaping () -> ()) {
        self.getUserNameForUUID(uuid: self.getUUID(), channel: channel, onSuccess: onSuccess, onError: onError)
    }
    
    // associate a username with the current user
    func setUserName(userName:String, channel:String, onSuccess:@escaping () -> ()) {
        let userNameState = [Constants.PubNubKeys.UserName : userName]
        let configuration = self.currentConfiguration()
        
        self.setState(userNameState,
                      forUUID: configuration.uuid,
                      onChannel: channel,
                      withCompletion:{
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
