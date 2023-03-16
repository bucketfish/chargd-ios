//
//  ContentView.swift
//  chargd
//
//

import SwiftUI



struct Onboarding: View {
    
    // the onboarding view.
    /* todo:
     - idk auth and login and all
     - teach user how to set up shortcut
     - request notif perms here instead of using a button in contentview
     */
    
    @State private var register_username: String = ""
    
    var body: some View {
        
        ZStack{
            VStack {
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
                }  
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
