//
//  MainTabView.swift
//  auraapp
//
//  Created by İrfan Vural on 15.03.2026.
//

//  MainTabView.swift
import SwiftUI

struct MainTabView: View {
    // Profil sayfasında çıkış yapabilmek için ana VM'i buraya da alıyoruz
    @Bindable var mainVM: MainViewViewModel
    
    // Hangi sekmenin seçili olduğunu tutan state
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 1. SEKME: Alışkanlıklar & Todo
            NavigationStack {
                TodoListView()
            }
            .tabItem {
                Label("Habits", systemImage: "checkmark.circle.fill")
            }
            .tag(0)
            
            // 2. SEKME: Sağlık & HealthKit
            NavigationStack {
                HealthView()
            }
            .tabItem {
                Label("Health", systemImage: "heart.fill")
            }
            .tag(1)
            
            // 3. SEKME: Profil & Ayarlar
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(2)
        }
        .tint(.blue) // Seçili olan ikonun rengi (Aura'nın ana rengi yapabiliriz)
    }
}

#Preview {
    MainTabView(mainVM: MainViewViewModel())
}
