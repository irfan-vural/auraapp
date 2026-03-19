//
//  HealthView.swift
//  auraapp
//
//  Created by İrfan Vural on 15.03.2026.
//
import SwiftUI

struct HealthView: View {
    @State var viewModel = HealthViewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // Dev bir adım sayısı göstergesi
                VStack(spacing: 10) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("\(Int(viewModel.stepCount))")
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                    
                    Text("Steps Today")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal, 30)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .navigationTitle("Activity")
            .onAppear {
                // Ekran açılır açılmaz izin iste ve veriyi çek
                viewModel.requestAuthorization()
            }
        }
    }
}

#Preview {
    HealthView()
}
