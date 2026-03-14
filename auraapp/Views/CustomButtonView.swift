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
    
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue )
                .cornerRadius(14)
                .shadow(color: .blue.opacity(0.3),radius: 10
                )
        }
        // Form geçersizse butona tıklanamaz
        
        .padding(.top, 10)
        
    }
}

#Preview {
    CustomButton(
        title: "String", action: {} )
}
