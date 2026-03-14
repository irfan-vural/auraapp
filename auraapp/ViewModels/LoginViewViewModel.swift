


import SwiftUI
import Observation // Combine yerine bunu kullanıyoruz

@Observable // Sınıfın başına bunu koy, protokolü (ObservableObject) sil
class LoginViewViewModel {
    var email = "" // @Published yazmana gerek kalmadı
    var password = ""
    var errorMessage = ""
    
    init() {}
    
    func login(){
        guard validate() else { return }
    }
    
    func validate() -> Bool{
        
            errorMessage = ""
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else{
                errorMessage = "Please fill all the fields"
                return false
            }
            
            guard email.contains("@") && email.contains(".") else {
                errorMessage = "Invalid email"
                return false
            }
        
        return true
    }
    
    
}
