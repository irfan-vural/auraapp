//
//  RegisterView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import SwiftUI


struct RegisterView: View {
    // Form verilerini tutacağımız state değişkenleri
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Şifrelerin eşleşip eşleşmediğini kontrol eden hesaplanmış özellik
    var isFormValid: Bool {
        return !fullName.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmPassword
    }

    var body: some View {
        VStack(spacing: 30) {
            
            // --- HEADER ---
            VStack(alignment: .leading, spacing: 10) {
                Text("Join Aura")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("Start building better habits today.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.top, 40)
            
            // --- REGISTER FORMU ---
            VStack(spacing: 16) {
                // Ad Soyad Alanı
                TextField("Full Name", text: $fullName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                
                // Email Alanı
                TextField("Email Address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                
                // Şifre Alanı
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                
                // Şifre Tekrar Alanı
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                    // Şifreler uyuşmazsa hafif kırmızı bir uyarı verebiliriz
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(password != confirmPassword && !confirmPassword.isEmpty ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 30)
            
            // --- KAYIT OL BUTONU ---
            Button(action: {
                // TODO: Firebase Auth kayıt (createUser) işlemleri buraya gelecek
                print("Kayıt oluşturuluyor... Ad: \(fullName), Email: \(email)")
            }) {
                Text("Create Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    // Form geçerliyse mavi, değilse soluk gri renk
                    .background(isFormValid ? Color.blue : Color.blue.opacity(0.4))
                    .cornerRadius(14)
                    .shadow(color: isFormValid ? .blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
            }
            .disabled(!isFormValid) // Form geçersizse butona tıklanamaz
            .padding(.horizontal, 30)
            .padding(.top, 10)
            
            Spacer()
            
            // --- FOOTER ---
            // Zaten NavigationStack içinde olduğumuz için "Geri Dön" mantığıyla çalışacak
            HStack(spacing: 8) {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                    .font(.callout)
                
                // Register sayfasına yönlendirme linki
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline) // Tepedeki boşluğu küçültür
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
