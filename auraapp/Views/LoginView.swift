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
    
    @Bindable var mainVM: MainViewViewModel

 
    
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
                    })
                    
                    Spacer() // Form ile footer'ı birbirinden uzaklaştırır
                    
                    // --- FOOTER ---
                    VStack(spacing: 8) {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                            .font(.callout)
                        
                        // Register sayfasına yönlendirme linki
                        NavigationLink(destination: RegisterView(
                            mainVM: mainVM
                        )) {
                            Text("Create an Account")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom , 30)
                }
                .padding()
                .ignoresSafeArea(.keyboard) // Klavye açıldığında tasarımın bozulmasını engeller
            }
        }
    }}

#Preview {
    LoginView(mainVM:   MainViewViewModel())
}
