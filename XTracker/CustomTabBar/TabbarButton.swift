////
////  TabbarButton.swift
////  XTracker
////
////  Created by mac on 08/12/2024.
////
//
//import SwiftUI
//
//struct TabbarButton: View {
//    @Binding var selectedTab: Tabs?
//    
//    var tab: Tabs
//    var icon: String
//    var label: String
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//                    if selectedTab == tab {
//                        Rectangle()
//                            .foregroundColor(.selected)
//                            .frame(width: 20, height: 5)
//                            .offset(y: -10)
//                    }
//                    VStack(alignment: .center, spacing: 5) {
//                        Image(systemName: icon)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                        Text(label)
//                            .bold()
//                            .font(.system(size: 12))
//                    }
//                }
//                .onTapGesture {
//                    selectedTab = tab
//                }
//    }
//}
//
//#Preview {
//    // Sample preview with a constant binding value
//    TabbarButton(
//        selectedTab: .constant(.home),
//        tab: .home,
//        icon: "house.fill",
//        label: "Home"
//    )
//    
//}
