//
//  ContentView.swift
//  chargd
//
//  Created by Tongyu Jiang on 13/3/23.
//

import SwiftUI



struct Onboarding: View {
    
    @State private var register_username: String = ""
    
    var body: some View {
        
        ZStack{
            VStack {
                Text("Welcome to Chargd.")
                    .font(.largeTitle)
                Text("A new way to see your friends (??)")
                
                
                TextField(
                "What's your username?",
                text: $register_username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing, .top], 50)
                .multilineTextAlignment(.center)
                
                Text("You can't change your username after this (for now), so choose carefully.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Done!") {
                    UserDefaults.standard.set(register_username, forKey: "username")

                    print(register_username)
                }
                
                
            
            }
            
//            VStack (){
//                Button("ok whatever let's go") {
//                    postUpdate()
//                }
//            }.frame(
//                maxWidth: .infinity,
//                maxHeight: .infinity,
//                alignment: .bottom)
        }
        
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
