//
//  ContentView.swift
//  chargd
//
//

import SwiftUI
import UserNotifications


let defaults = UserDefaults.standard

struct ContentView: View {
    
    // get username from appstorage
    @AppStorage("username") var username = "Anonymous"
    @AppStorage("use_12h_clock") var use_12h_clock = true

    
    // update the feed
    @State var feed: [String: User]
    @State var feed_list: [String] = []
    
    var body: some View {
        NavigationStack {
            
        
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
                            
                            // sort the data by time posted (this code is messed up as hell)
                            feed_list = Array(feed.keys).sorted {
                                
                                let first_timestamp = Int(feed[$0]?.timestamp ?? "0")
                                let second_timestamp = Int(feed[$1]?.timestamp ?? "0")
                                
                                return first_timestamp ?? 0 > second_timestamp ?? 0
                            }
                        }
                    }
                }
                
                // show the feed
                VStack (spacing: 20){
                    ForEach(feed_list, id: \.self) {feedItem in
                        
                        VStack{
                            Divider()

                            // TODO: format this nicer i guess
                            Text(getTimestampText(timestamp_string: feed[feedItem]?.timestamp ?? "", use_12h_clock: use_12h_clock))
                            Group {
                                Text(feedItem).bold() + Text(" ") + Text((feed[feedItem]?.is_plugin == "true") ? "plugged in" : "unplugged") + Text(" their phone.")
                            }
                            Text((feed[feedItem]?.battery ?? "") + "%")
                                .font(.title)
                            Text(feed[feedItem]?.caption ?? "")
                        }
                    }
                }
            } // end of main feed
        }
        .padding([.leading, .trailing]) // padding around the entire zstack
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    FriendsView()
                } label: {
                    Image(systemName: "person.2.circle")
                        .font(.title)
                }
            }
            ToolbarItem {
                NavigationLink {
                    Settings()
                } label: {
                    Image(systemName: "gear")
                        .font(.title)
                }
            }
        }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(feed: ["bucketfish": User(battery: "90", is_plugin: "true", timestamp: "1672531200", caption: "test caption")], feed_list: ["bucketfish"])
    }
}
