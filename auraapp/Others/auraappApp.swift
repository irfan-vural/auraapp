//
//  auraappApp.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//
import FirebaseCore
import SwiftUI


@main
struct auraappApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
