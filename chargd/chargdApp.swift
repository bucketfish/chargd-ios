//
//  chargdApp.swift
//  chargd
//

import SwiftUI

var inForeground = true

// MARK: main
@main
struct chargdApp: App {
    
    @Environment(\.scenePhase) var scenePhase
        
    @AppStorage("username") var username = "Anonymous"
    @AppStorage("canCaption") var canCaption = false

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        print("yas")
        inForeground = true
    
    }
    
    var body: some Scene {
        WindowGroup {
            if (username == "Anonymous") {
                Onboarding()
            }
            else if (canCaption) {
                Caption()
            }
            else {
                ContentView()
            }
        }
        .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background:
                        inForeground = false
                        print("App is in background")
                    case .active:
                        inForeground = true
                        print("App is Active")
                    case .inactive:
                        inForeground = true
                        print("App is Inactive")
                    @unknown default:
                        inForeground = false
                        print("New App state not yet introduced")
                    }
                }
    }
    
}


// MARK: notifs

func sendCaptionNotif(is_plugin: Bool){
    let content = UNMutableNotificationContent()
    
    content.title = "You just plugged \(is_plugin ? "in" : "out") your phone!"
    content.body = "Post a caption?"
    
    UserDefaults.standard.set(true, forKey: "canCaption")

    // create the notification request
    let request = UNNotificationRequest(identifier: "postCaption", content: content, trigger: nil)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["postCaption"])
        
        if (inForeground == false) {
            UserDefaults.standard.set(false, forKey: "canCaption")
        }

    }
}


func requestNotifPerms(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}



// MARK: api calls

//
//func deleteOldUsername(_: oldUsername) {
//
//}


func postCaption(caption: String){
    @AppStorage("username") var username = "Anonymous"
    
    let parameters: NSDictionary = [
        "username": username,
        "caption": caption
    ]
    
    let url_string = "https://chargd.bucketfish.me/caption"
    
    apiPOST(parameters: parameters, url_string: url_string)
    
}

func postUpdate() {
    @AppStorage("username") var username = "Anonymous"
    
    let currentTime = Int(NSDate().timeIntervalSince1970)
    
    let battery_level = (UIDevice.current.batteryLevel) * 100
    let is_plugin = getPluggedState()
        
    
    let parameters: NSDictionary = [
        "username": username,
        "battery": String(battery_level),
        "is_plugin": String(is_plugin),
        "timestamp": String(currentTime)
    ]
    
    let url_string = "https://chargd.bucketfish.me/battery"
    
    apiPOST(parameters: parameters, url_string: url_string)
}



func apiPOST(parameters: NSDictionary, url_string: String) {
    let url = URL(string:url_string)!
    var request = URLRequest(url: url)
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.httpMethod = "POST"
    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return
        }
    request.httpBody = httpBody
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                
            }
     
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
            }
    }
    task.resume()
}



// MARK: small helpers
func getPluggedState() -> Bool {
    let plugged_state = UIDevice.current.batteryState
    var is_plugin = true
    
    switch plugged_state {
        case UIDevice.BatteryState.charging:
            is_plugin = true
        case UIDevice.BatteryState.full:
            is_plugin = true
    
        default:
            is_plugin = false
    }
        
    return is_plugin
}
