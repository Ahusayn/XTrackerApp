//
//  FollowDeveloper.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//

import SwiftUI

import SwiftUI

struct FollowDeveloper: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Image("abdul-hssn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.gray.opacity(0.4), lineWidth: 2)
                    )
                    .shadow(radius: 4)
                
                VStack {
                    Text("Hey there I'm Abdulrahman an aspiring Mobile developer. XTracker helps you track expenses and spend smarter- simple smarter and riight in your pocket.")
                    
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                List {
                    Section {
                        HStack {
                            Image("x") // Twitter/X logo
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)

                            Link("@husaynAbdul", destination: URL(string: "https://twitter.com/husaynAbdul_")!)
                                .font(.system(size: 15))
                                .foregroundStyle(Color.text)
                        }

                        HStack {
                            Image("x")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)

                            Link("@hssncodes", destination: URL(string: "https://instagram.com/hssncodes")!)
                                .font(.system(size: 15))
                                .foregroundStyle(Color.text)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .padding()
            .background(Color.backgroundcolor)
            .navigationTitle("Follow Me")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    FollowDeveloper()
}
