//
//  ContentView.swift
//  chargd
//
//  Created by Tongyu Jiang on 13/3/23.
//

import SwiftUI
import UserNotifications


let defaults = UserDefaults.standard

struct ContentView: View {
    
    @AppStorage("username") var username = "Anonymous"
    @State var update_feed = true
    @State var feed: [String: User]
    @State var feed_list: [String] = []
    
    var body: some View {
        
        ZStack{
            VStack (spacing: 20) {
            
                Group {
                    Text("hello, ") + Text(username).bold()
                }
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                
                Button("refresh feed") {
                    apiGET { results in
                        if let fetchedData = results {
                            feed = fetchedData
                            feed_list = Array(feed.keys)
                            print(feed_list)
                        }
                    }
                }
                
                VStack (spacing: 20){
                    ForEach(feed_list, id: \.self) {feedItem in
                        
                        VStack{
                            Divider()

                            Text(getTimestampText(timestamp_string: feed[feedItem]?.timestamp ?? ""))
                           
                            Group {
                                Text(feedItem).bold() + Text(" plugged their phone ") + Text((feed[feedItem]?.is_plugin == "true") ? "in" : "out") + Text(".")
                            }
                            Text((feed[feedItem]?.battery ?? "") + "%")
                                .font(.title)
                            Text(feed[feedItem]?.caption ?? "")
                            
                            
                        }
                        

                    }
                }
            
            }
            
            VStack (){
                Button("request notif perms") {
                    requestNotifPerms()
                }
                

            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottom)
        }
        .padding([.leading, .trailing])
        
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(feed: ["bucketfish": User(battery: "90", is_plugin: "true", timestamp: "1234", caption: "test caption")])
    }
}
