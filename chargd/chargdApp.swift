//
//  chargdApp.swift
//  chargd
//

import Foundation
import SwiftUI
//import NSCalendar

var inForeground = true // i'm sure there's a better way to do this too

// MARK: main
@main
struct chargdApp: App {
    
    @Environment(\.scenePhase) var scenePhase
        
    @AppStorage("username") var username = "Anonymous"
    @AppStorage("canCaption") var canCaption = false

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
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
                ContentView(feed: [:])
            }
        }
        .onChange(of: scenePhase) { phase in
            // i'm sure there's a better way to do this
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
    
    // enable captioning in the app
    UserDefaults.standard.set(true, forKey: "canCaption")

    // create the notification request
    let request = UNNotificationRequest(identifier: "postCaption", content: content, trigger: nil)

    // send the notification request
    UNUserNotificationCenter.current().add(request)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        
        // after 10 seconds, turn it off. they must be fast!
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["postCaption"])
        
        // if the user didn't open the app before 10 seconds passed, they can't caption anymore
        if (inForeground == false) {
            UserDefaults.standard.set(false, forKey: "canCaption")
        }
    }
}


// request notification perms (to send notifications)
func requestNotifPerms(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}

// MARK: api get calls

func apiGET(completion: @escaping ([String: User]?) -> Void) {
    // i don't even know anymore. this works. don't touch it or i die
    let url = URL(string:"https://chargd.bucketfish.me/battery")!
    
    URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()
        
        if let data = data{
            do{
                let data = try decoder.decode([String: User].self, from: data)
                completion(data)
            
            }catch{
                print(error)
                completion([:])
            }
        }
    }.resume()
}



// MARK: api post calls

// TODO: change username/delete user
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
    print(plugged_state)
    
    switch plugged_state {
        case UIDevice.BatteryState.unplugged:
            is_plugin = false
    
        default:
            is_plugin = true
    }
        
    return is_plugin
}


func getTimestampText(timestamp_string: String, use_12h_clock: Bool = false) -> String {

    let time = Date(timeIntervalSince1970: Double(timestamp_string) ?? 0.0)
    let timestamp = (Int(timestamp_string) ?? 0) * 1000 // milliseconds
    
    let calendar = Calendar.current
    
    
    let dateFormatter = DateFormatter()
    if (use_12h_clock) {
        dateFormatter.dateFormat = "h:mma"
    } else {
        dateFormatter.dateFormat = "HH:mm"

    }
    let formatted_time = dateFormatter.string(from: time)
    
    if (use_12h_clock) {
        dateFormatter.dateFormat = "MMM d, h:mma"
    } else{
        dateFormatter.dateFormat = "MMM d, HH:mm"
    }
    
    let formatted_date_time = dateFormatter.string(from: time)
    
    let current_timestamp = Int(NSDate().timeIntervalSince1970) * 1000;
    
    let milliseconds_elapsed = current_timestamp - timestamp;
    let msPerMinute = 60 * 1000;
    let msPerHour = msPerMinute * 60;
    let msPerDay = msPerHour * 24;
    
    
    if (milliseconds_elapsed < msPerMinute) {
        let time_num = String(milliseconds_elapsed/1000)
        if (time_num == "1"){
            return time_num + " second ago"
        }
        return time_num + " seconds ago";
    }
    
    else if (milliseconds_elapsed < msPerHour) {
        let time_num = String(milliseconds_elapsed/msPerMinute)
        if (time_num == "1"){
            return time_num + "minute ago";
        }
        return time_num + " minutes ago";
    }
    
    else if (milliseconds_elapsed < msPerDay ) {
        
        if (calendar.isDateInToday(time)) {
            return "today at " + formatted_time;
        }
        else {
            return "yesterday at " + formatted_time;
        }
        // TODO: what if it's "yesterday"
        
    }
    
    else {
        return formatted_date_time;
    }
    
}
