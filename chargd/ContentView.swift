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
    
    // get username from appstorage
    @AppStorage("username") var username = "Anonymous"
    
    // update the feed
    @State var feed: [String: User]
    @State var feed_list: [String] = []
    
    var body: some View {
        ZStack{
            
            // MARK: main feed
            VStack (spacing: 20) {
            
                // greeting
                Group {
                    Text("hello, ") + Text(username).bold()
                }
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                
                // refresh feed
                Button("refresh feed") {
                    apiGET { results in
                        
                        if let fetchedData = results {
                            // update feed with new data
                            feed = fetchedData
                            feed_list = Array(feed.keys)
                            // TODO: sort feed here
                        }
                    }
                    
                }
                
                // show the feed
                VStack (spacing: 20){
                    ForEach(feed_list, id: \.self) {feedItem in
                        
                        
                        VStack{
                            Divider()

                            // TODO: format this nicer i guess
                            Text(getTimestampText(timestamp_string: feed[feedItem]?.timestamp ?? ""))
                            Group {
                                // TODO: changed 'plugged out' to 'unplugged'
                                Text(feedItem).bold() + Text(" plugged their phone ") + Text((feed[feedItem]?.is_plugin == "true") ? "in" : "out") + Text(".")
                            }
                            Text((feed[feedItem]?.battery ?? "") + "%")
                                .font(.title)
                            Text(feed[feedItem]?.caption ?? "")
                        }
                    }
                }
                
            } // end of main feed
            
            // MARK: debugging buttons
            VStack (){
                Button("request notif perms") {
                    requestNotifPerms()
                }
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottom)
        }
        .padding([.leading, .trailing]) // padding around the entire zstack
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(feed: ["bucketfish": User(battery: "90", is_plugin: "true", timestamp: "1234", caption: "test caption")])
    }
}
