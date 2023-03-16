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
            
            
            List{
                // MARK: main feed
                
                
                HStack {
                    Spacer()
                    Text("chargd")
                        .font(Font.system(size: 64, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color("ShinyPurple"), Color("ShinyBlue"), Color("ShinyGreen")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Spacer()
                }
                .listRowSeparator(.hidden)
                
                ForEach(feed_list, id: \.self) { feedItem in
                    
                    VStack (alignment: .leading, spacing: 10){
                        // TODO: format this nicer i guess
                        
                        Text(getTimestampText(timestamp_string: feed[feedItem]?.timestamp ?? "", use_12h_clock: use_12h_clock)).foregroundColor(.gray)
                        Text(feedItem).bold() + Text(" ") + Text((feed[feedItem]?.is_plugin == "true") ? "plugged in" : "unplugged").foregroundColor(.gray) + Text(" their phone.").foregroundColor(.gray)
                        Text((feed[feedItem]?.battery ?? "") + "%")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("ShinyPurple"))
                        
                        Text(feed[feedItem]?.caption ?? "")
                        
                        HStack {
                            Spacer()
                            Image(systemName: "bolt")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 32.0)
                                .foregroundColor(Color("PastelGreen"))
                            Spacer()
                        }.padding([.top, .bottom], -10)
                        
                    }.listRowSeparator(.hidden)
                    
                    
                } // end of main feed
            }
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem (placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button (action: {
                        
                        apiGET { results in
                            if let fetchedData = results {
                                // update feed with new data
                                feed = fetchedData
                                
                                // sort the data by time posted
                                feed_list = Array(feed.keys).sorted {
                                    
                                    let first_timestamp = Int(feed[$0]?.timestamp ?? "0")
                                    let second_timestamp = Int(feed[$1]?.timestamp ?? "0")
                                    
                                    return first_timestamp ?? 0 > second_timestamp ?? 0
                                }
                            }
                        }
                    }){
                        Image(systemName:"arrow.clockwise" )
                    }
                    
                }
                ToolbarItem {
                    NavigationLink {
                        FriendsView()
                    } label: {
                        Image(systemName: "person.2.circle")
                    }
                }
                ToolbarItem {
                    NavigationLink {
                        Settings()
                    } label: {
                        Image(systemName: "gear")
                    }
                }

            }
        }.onAppear {
            apiGET { results in
                if let fetchedData = results {
                    // update feed with new data
                    feed = fetchedData
                    
                    // sort the data by time posted
                    feed_list = Array(feed.keys).sorted {
                        
                        let first_timestamp = Int(feed[$0]?.timestamp ?? "0")
                        let second_timestamp = Int(feed[$1]?.timestamp ?? "0")
                        
                        return first_timestamp ?? 0 > second_timestamp ?? 0
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

