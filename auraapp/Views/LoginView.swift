//
//  LoginView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import SwiftUI

struct LoginView: View {
     // Form verilerini tutacağımız state değişkenleri
    // @State private var email = ""
   // @State private var password = ""
    
    @State var viewModel = LoginViewViewModel()
    
    
    var isFormValid: Bool {
        return !viewModel.email.isEmpty && !viewModel.password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                
                // --- HEADER ---
                HeaderView()
                
                // --- FORM ---
                VStack(spacing: 20) {
                    // Email Alanı
                    if(!viewModel.errorMessage.isEmpty){
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                    TextField("Email Address", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none) // Emaillerde ilk harf büyük olmamalı
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                    
                    // Şifre Alanı
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                    
                    // Giriş Butonu
                    CustomButton(title: "Sign in", action: {
                        viewModel.login()
                    }, isFormValid: isFormValid)
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
    }}

#Preview {
    LoginView()
}
