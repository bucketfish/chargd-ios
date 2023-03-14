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
    
    var body: some View {
        
        ZStack{
            VStack (spacing: 20) {
            
                Group {
                    Text("your username is ") + Text(username).bold() + Text(".")
                }
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                
                
                Text("whoaaaa. you're logged in! try plugging in your phone.")
                    .multilineTextAlignment(.center)
            
            }
            
            VStack (){
                Button("request notif perms") {
                    requestNotifPerms()
                }
                
//                Button("test send a caption notif!") {
//                    sendCaptionNotif(is_plugin: true)
//                }
//                Button("test post a caption!") {
//                    postCaption(caption: "test caption")
//                }
            
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
        ContentView()
    }
}
