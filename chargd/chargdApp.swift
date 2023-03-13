//
//  chargdApp.swift
//  chargd
//

import SwiftUI


@main
struct chargdApp: App {
        
    @AppStorage("username") var username = "Anonymous"

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            if (username == "Anonymous") {
                Onboarding()
            }
            else {
                ContentView()
            }
        }
    }
    
    

}
//
//func deleteOldUsername(_: oldUsername) {
//
//}

func postUpdate() {
    @AppStorage("username") var username = "Anonymous"
    
    let currentTime = Int(NSDate().timeIntervalSince1970)
    
    let battery_level = (UIDevice.current.batteryLevel) * 100
    
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
