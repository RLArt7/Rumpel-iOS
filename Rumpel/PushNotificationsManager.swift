//
//  PushNotificationsManager.swift
//  Rumpel
//
//  Created by Harel Avikasis on 03/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation

//class PushNotificationsManager
//{
//    static let manager = PushNotificationsManager()
//    
//    let url = URL(string: "https://fcm.googleapis.com/fcm/send")
//    
//    lazy var defaultHeaders: [String: String] = {
//        return ["Content-Type": "application/json",
//                "Authorization": ""]
//    }()
//    
//    func sendPush(to notificationObject: PushNotificaionObject, completion: @escaping (_ success: Bool)->Void)  {
//        let params = notificationObject.getParams()
//        
//        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: defaultHeaders).responseJSON { (response) in
//            debugPrint(response)
//            
//            if let json = response.result.value {
//                print("JSON: \(json)")
//                completion(true)
//            }
//        }
//        
//    }
//}
//
//class PushNotificationObject
//{
//    
//}
