//
//  ProfilePage.swift
//  XTracker
//
//  Created by hssn on 23/11/2024.
//

import SwiftUI

struct ProfilePage: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email : String = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("hssn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke( Color.text.opacity(0.5), lineWidth: 4)
                        }
                        .shadow(radius: 10)
                        .padding(.bottom, 10)
                    
                    Text("Edit Profile Picture")
                        .font(.footnote)
                        .foregroundColor(Color.button)
                        .padding(.bottom, 16)
                }
                
                
                Form {
                    Section("Profile Info") {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("Email", text: $email)
                        
                        Button {
                            
                        } label: {
                            Text("Save")
                        }
                        .foregroundStyle(Color.button)
                    }
                   
                    
                }
            }
            
        }
        
    }
        
}

#Preview {
    ProfilePage()
}
