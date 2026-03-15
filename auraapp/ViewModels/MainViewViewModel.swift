//
//  MainViewViewModel.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//


import SwiftUI
import Observation
import FirebaseAuth

@Observable
class MainViewViewModel{
    var currentUserId = ""
    private var handler: AuthStateDidChangeListenerHandle?
    var isRegistering = false // İşte bu bizim frenimiz kanka
    init() {
     // try? Auth.auth().signOut()
        
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
        DispatchQueue.main.async {
            // Burası değiştiği an SwiftUI tetiklenecek
            self?.currentUserId = user?.uid ?? ""
        }
    }
    }
    deinit {
            if let handler = handler {
                Auth.auth().removeStateDidChangeListener(handler)
            }
        }
    var showMainApp: Bool {
            return !currentUserId.isEmpty && !isRegistering
        }
    
}


