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
        
        ZStack {
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
                        }
                    }
                    posted = true

                }
                
                
            }
            
            
            
        }.padding([.leading, .trailing])
        
       
        
    }
}


struct Caption_Previews: PreviewProvider {
    static var previews: some View {
        Caption()
    }
}
