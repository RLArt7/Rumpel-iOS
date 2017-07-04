//
//  PushNotificationsManager.swift
//  Rumpel
//
//  Created by Harel Avikasis on 03/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation
import Alamofire

class PushNotificationsManager
{
    static let manager = PushNotificationsManager()
    
    let url = URL(string: "https://fcm.googleapis.com/fcm/send")
    
    lazy var defaultHeaders: [String: String] = {
        return ["Content-Type": "application/json",
                "Authorization": "key=AAAAXx-VQUg:APA91bFU6v8k4KfT1EMhTJY7Rw7BEBeV6uS5sG_MJvAQ487mmaI2FQ93xNCtAUGTJaq5iXvlapYclxScEG6HOdx483xq8oGTM2OpQMU0ycnBUlLdQKLYLIine2FqCuD2Xwq4zczW4Zeb"]
    }()
    
    func sendPush(to notificationObject: PushNotificaionObject, completion: @escaping (_ success: Bool)->Void)  {
        let params = notificationObject.getParams()
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: defaultHeaders).responseJSON { (response) in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                completion(true)
            }
        }
    }
}

struct NotificationPayload {
    var title : String = ""
    var userName: String = ""
    var body : String?
//    var action: PushActions?
    
    func getParams() -> [String : Any] {
        var dict = [String: Any]()
        dict["title"] = self.title
        dict["sound"] = "default"
        dict["badge"] = "1"
        dict["body"] = userName + " Just Send You A Riddle"
//        if let action = self.action{
//            switch action {
//            case .friendRequest:
//                dict["body"] = self.userName + action.actionTitleString()
//                break
//            case .openNotifications:
//                dict["body"] = action.actionTitleString()
//                break
//            case .openSearchUser:
//                dict["body"] = self.userName + action.actionTitleString()
//                break
//            default :
//                break
//            }
//        }
        
        return dict
    }
}

struct PushNotificaionObject {
    var to : String?
//    var data: NotificationData?
    var notificationPayload : NotificationPayload?
    
    func getParams() -> [String : Any] {
        var dict = [String: Any]()
        dict["to"] = self.to
        dict["notification"] = self.notificationPayload?.getParams()
        dict["data"] = ["Hello": "World"]
        
        return dict
    }
}
