//
//  ContentView.swift
//  chargd
//
//  Created by Tongyu Jiang on 13/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack{
            VStack {
            
                Text("Welcome to Chargd.")
                    .font(.title)
                Text("A new way to see your friends.")
            
            }
            
            VStack (){
                Button("ok whatever let's go") {
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
