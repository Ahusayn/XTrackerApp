//
//  ProfilePage.swift
//  XTracker
//
//  Created by hssn on 23/11/2024.
//

import SwiftUI
import SwiftData

struct ProfilePage: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""

    @Environment(\.modelContext) private var context

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
                                .stroke(Color.text.opacity(0.5), lineWidth: 4)
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
                            saveProfile()
                        } label: {
                            Text("Save")
                        }
                        .foregroundStyle(Color.button)
                        .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty)
                    }
                }
            }
        }
    }

    func saveProfile() {
        // Fetch existing profiles and delete them
        let fetchDescriptor = FetchDescriptor<ProfileModel>()
        let existingProfiles = (try? context.fetch(fetchDescriptor)) ?? []
        existingProfiles.forEach { context.delete($0) }

        // Create and save the new profile
        let profile = ProfileModel(firstName: firstName, lastName: lastName, email: email)
        context.insert(profile)

        do {
            try context.save()
            print("Profile saved successfully!")
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProfilePage()
}
