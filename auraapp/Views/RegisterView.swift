//
//  RegisterView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import SwiftUI


struct RegisterView: View {
    // Form verilerini tutacağımız state değişkenleri
@State var viewModel = RegisterViewViewModel()
@Bindable var mainVM: MainViewViewModel

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
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                // Ad Soyad Alanı
                TextField("Full Name", text: $viewModel.name)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                
                // Email Alanı
                TextField("Email Address", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                
                // Şifre Alanı
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                
                // Şifre Tekrar Alanı
                SecureField("Confirm Password", text: $viewModel.confirmPasssword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                    // Şifreler uyuşmazsa hafif kırmızı bir
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(viewModel.password != viewModel.confirmPasssword && !viewModel.confirmPasssword.isEmpty ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 30)
            
            // --- KAYIT OL BUTONU ---
            
             CustomButton(title: "Create Account", action: {
                 mainVM.isRegistering = true
                 viewModel.register()
             }).padding(.horizontal,30)
            Spacer()
            
            // --- FOOTER ---
            HStack(spacing: 8) {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                    .font(.callout)
                
                // Login sayfasına yönlendirme linki
                NavigationLink(destination: LoginView(
                    mainVM: mainVM
                )) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
        .alert("Succesful!", isPresented: $viewModel.showSuccessAlert) {
            Button("Let's Start", role: .cancel) {
                mainVM.isRegistering = false
            }
        } message: {
            Text("You Are All Set! Welcome To AURA").bold()
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(mainVM : MainViewViewModel())
    }
}
