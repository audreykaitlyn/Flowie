//
//  SplashScreen.swift
//  Flowie
//
//  Created by Audrey on 25/05/23.
//

import SwiftUI

struct SplashScreen: View {
    
    @State var isShowing = false
    var body: some View {
        NavigationView{
            GeometryReader{ geometry in
                ZStack{
                
                    Image("BackgroundImage")
                        .resizable()
                    
                    Image("BungaHome")
                        .resizable()
                        .scaledToFit()
                        .frame(width : 110)
                        .position(x: geometry.size.width * 0.78, y: geometry.size.height * 0.16)
                    
                    
                    VStack(alignment: .leading){
                        
                        Text("Flowie")
                            .titleStyle()
                        
                        
                        Text("Hello it's Flowie! Flowie will help you recognize flower and explore the language they speak")
                            .bodyStyle()
                            .padding(.bottom, 2)
                        
                    }
                    .frame(width: 200)
                    .position(x: geometry.size.width * 0.36, y: geometry.size.height * 0.35)
                    
                    
                    NavigationLink(destination: ContentView()){
                        RoundedRectangle(cornerRadius: 11)
                            .frame(width: 110,height: 40)
                            .foregroundColor(.white)
                            .overlay(
                                Text("Start")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                            )
                    }
                    .position(x: geometry.size.width * 0.25 , y: geometry.size.height * 0.53)
                    
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
