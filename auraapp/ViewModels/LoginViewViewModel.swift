

import FirebaseAuth
import SwiftUI
import Observation // Combine yerine bunu kullanıyoruz

@Observable // Sınıfın başına bunu koy, protokolü (ObservableObject) sil
class LoginViewViewModel {
    var email = "" // @Published yazmana gerek kalmadı
    var password = ""
    var errorMessage = ""
    
    init() {}
    
    func login(){
        errorMessage = ""
        guard validate() else { return }
        // --- FIREBASE GİRİŞ İŞLEMİ ---
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            // Kayıt ekranında olduğu gibi mesajı direkt kullanıcıya basıyoruz
                            self?.errorMessage = error.localizedDescription
                        }
                        return
                    }
                    print("Giriş başarılı: \(result?.user.uid ?? "")")
                }
    }
    
  private  func validate() -> Bool{
        
            errorMessage = ""
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else{
                errorMessage = "Please fill all the fields"
                return false
            }
            
            guard email.contains("@") && email.contains(".") else {
                errorMessage = "Invalid email"
                return false
            }
      guard password.count >= 6 else {
          errorMessage = "Password must be at least 6 characters"
          return false
      }
        
        return true
    }
    
    
}
