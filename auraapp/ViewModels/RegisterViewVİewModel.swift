//
//  RegisterViewVİewModel.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import SwiftUI
import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
class RegisterViewViewModel {
    var name = ""
    var email = ""
    var password = ""
    var confirmPasssword = ""
    var errorMessage = ""
    var showSuccessAlert = false // Başarı mesajı için
    
    init(name: String = "", email: String = "", password: String = "", confirmPasssword: String = "") {
        self.name = name
        self.email = email
        self.password = password
        self.confirmPasssword = confirmPasssword
    }
    func register() {
        self.errorMessage = "" // Her denemede eski hatayı temizle
        
        guard validate() else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            // 1. HATA VAR MI KONTROL ET
            if let error = error {
                DispatchQueue.main.async {
                    // İşte o aradığın "mesaj" alanı tam olarak bu:
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            // 2. HATA YOKSA DEVAM ET
            guard let userID = result?.user.uid else { return }
            self?.insertUserToDatabase(id: userID)
            
            DispatchQueue.main.async {
                self?.showSuccessAlert = true // Yeşil alerti yakıyoruz
            }
        }
    }
    private func insertUserToDatabase(id: String){
        let newUser = User(
            id: id ,name: name, email: email, joined: Date().timeIntervalSince1970
        )
        let db = Firestore.firestore()
        
        db.collection("users").document(id).setData(newUser.asDictionary())
        
    }
    
    
    private func validate ()-> Bool{
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty ,!email.trimmingCharacters(in: .whitespaces).isEmpty ,!password.trimmingCharacters(in: .whitespaces).isEmpty, !confirmPasssword.trimmingCharacters(in: .whitespaces).isEmpty else {
        errorMessage = "All fields are required"
        return false
        }
    guard email.contains("@"), email.contains(".") else {
            errorMessage = "Invalid email"
        return false
        }
    guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
        return false
        }
        
        guard password == confirmPasssword else {
         errorMessage = "Password does not match"
        return false
        }
        return true
    }
}
