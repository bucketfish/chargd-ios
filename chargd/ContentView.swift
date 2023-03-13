//
//  ContentView.swift
//  chargd
//
//  Created by Tongyu Jiang on 13/3/23.
//

import SwiftUI

let defaults = UserDefaults.standard

struct ContentView: View {
    
    @AppStorage("username") var username = "Anonymous"
    
    var body: some View {
        
        ZStack{
            VStack {
            
                Text("some content screen idk.")
                    .font(.title)
                Text("whoaaaa. you're logged in!")
            
            }
            
            VStack (){
                Button("test post an update!") {
                    print(username)
                    postUpdate()
                }
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottom)
        }
        
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
