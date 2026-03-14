//
//  HeaderView.swift
//  auraapp
//
//  Created by İrfan Vural on 14.03.2026.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
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
    }
}

#Preview {
    HeaderView()
}
