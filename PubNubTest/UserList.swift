//
//  UserList.swift
//  PubNubTest
//
//  Created by Scott Richards on 10/13/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import PubNub

class UserList: NSObject {
    var pubNubClient : PubNub!
    var users : [String : String] = [String : String]()
    
    init(client:PubNub) {
        self.pubNubClient = client
    }
    
    func addUserByUUID(uuid:String) {
        print("uuid: \(uuid)")
        pubNubClient.getUserNameForUUID(uuid:uuid, onSuccess: {userName in
            self.users[uuid] = userName
            print("updated userlist: \(self.users)")
            }, onError: {})
    }
    
    func getUserNameByUUID(uuid:String) -> String {
        if let userId = users[uuid] {
            return userId
        } else {
            return ""
        }
    }
}
