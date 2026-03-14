//
//  CustomButtonView.swift
//  auraapp
//
//  Created by İrfan Vural on 14.03.2026.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    let isFormValid:  Bool
    
    
    var body: some View {
        Button(action: action) {
            Text(title)
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
        
    }
}

#Preview {
    CustomButton(
        title: "String", action: {}, isFormValid: false )
}
