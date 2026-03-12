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
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
