//
//  LoginView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import SwiftUI

struct LoginView: View {
    // Form verilerini tutacağımız state değişkenleri
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                
                // --- HEADER ---
                VStack(spacing: 12) {
                    Image("aura-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 24)) // Logoya modern bir ovallik
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    Text("Aura")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    
                    Text("Daily Routine & ADHD Focus")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                // --- FORM ---
                VStack(spacing: 20) {
                    // Email Alanı
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none) // Emaillerde ilk harf büyük olmamalı
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                    
                    // Şifre Alanı
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                    
                    // Giriş Butonu
                    Button(action: {
                        // TODO: Firebase Auth giriş işlemleri buraya gelecek
                        print("Giriş yapılıyor... Email: \(email)")
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue) // İleride Aura'nın ana rengiyle değiştirebiliriz
                            .cornerRadius(14)
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 30) // Kenarlardan nefes alma boşluğu
                
                Spacer() // Form ile footer'ı birbirinden uzaklaştırır
                
                // --- FOOTER ---
                VStack(spacing: 8) {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                    // Register sayfasına yönlendirme linki
                    NavigationLink(destination: RegisterView()) {
                        Text("Create an Account")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 20)
            }
            .ignoresSafeArea(.keyboard) // Klavye açıldığında tasarımın bozulmasını engeller
        }
    }
}

#Preview {
    LoginView()
}
