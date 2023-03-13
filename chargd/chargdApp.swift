//
//  chargdApp.swift
//  chargd
//

import SwiftUI

@main
struct chargdApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func postUpdate(){
    let url = URL(string: "https://chargd.bucketfish.me/battery")!
    var request = URLRequest(url: url)
    
//    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

    let parameters: NSDictionary = [
        "username": "bucketfish_test",
        "battery": "100",
        "is_plugin": "true",
        "timestamp": "test_data"
    ]
   
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
                return
            }
     
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
    }
    task.resume()
    

}
