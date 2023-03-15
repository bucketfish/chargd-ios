//
//  ContentView.swift
//  chargd
//

import SwiftUI

struct Caption: View {
    
    @AppStorage("username") var username = "Anonymous"
    
    @State var is_plugin = true
    @State var caption = ""
    
    @State var posted = false
    
    var body: some View {
        
        ZStack { // there's no reason for there to be a zstack here (yet)
            
            // MARK: captioning textfield
            VStack{
                Text("Just plugged \(is_plugin ? "in" : "out")!")
                    .font(.title)
                
                TextField(
                    "Write a caption. What's up?",
                    text: $caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                
                Button(posted ? "Posted!!" : "Post") {
                    if (!posted) {
                        postCaption(caption: caption)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            UserDefaults.standard.set(false, forKey: "canCaption")
                            // go back to the main page after 1 second
                        }
                    }
                    posted = true
                    
                }
            }
            
            
            
        }.padding([.leading, .trailing])
            .onAppear {
                is_plugin = getPluggedState()
                // i love .onappear
            }
        
        
        
    }
}


struct Caption_Previews: PreviewProvider {
    static var previews: some View {
        Caption()
    }
}
