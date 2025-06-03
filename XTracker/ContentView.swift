//
//  ContentView.swift
//  XTracker
//
//  Created by hssn on 09/11/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @Environment(\.colorScheme) var ColorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()
                
                Image("Neurons")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .padding(.leading, 200)
                    .brightness(ColorScheme == .dark ? 1 : 0.0)
                VStack(alignment: .leading) {
                    
                    Spacer()
                    
                    Text("One\nPay\nStop\nFor\nAll.")
                        .font(.system(size: 92, weight: .bold))
                        .textCase(.uppercase)
                        .foregroundStyle(.text)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: NavigationTabView()) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.brown)
                                .cornerRadius(15)
                        }
                        
                        //                    .frame(height: 50)
                        .padding(.horizontal, 20)
                        
                    }
                    .padding(.bottom,50)
                    
                }
                .padding()
                
            }
        }
        
       
    }
    
   

   
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView( )
            
                .preferredColorScheme(.light)
            
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
