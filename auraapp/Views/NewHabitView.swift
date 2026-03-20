import SwiftUI

struct NewHabitView: View {
    @State var viewModel = NewHabitViewViewModel()
    
    // Açılan pencereyi (sheet) kapatmak için SwiftUI'ın kendi çevresel değişkenini kullanıyoruz
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // --- 1. İSİM BÖLÜMÜ ---
                Section(header: Text("Habit Name")) {
                    TextField("e.g. Read 10 Pages", text: $viewModel.title)
                        .autocorrectionDisabled()
                }
                
                // --- 2. İKON SEÇİMİ ---
                Section(header: Text("Choose an Icon")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.icons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .font(.title2)
                                    .frame(width: 50, height: 50)
                                    // Seçiliyse rengi mavi yap, değilse gri kalır
                                    .foregroundColor(viewModel.selectedIcon == icon ? .white : .primary)
                                    .background(viewModel.selectedIcon == icon ? Color.blue : Color(.systemGray5))
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.selectedIcon = icon
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // --- 3. RENK SEÇİMİ ---
                Section(header: Text("Choose a Color")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.colors, id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex)) // Yazdığımız Extension burada devreye giriyor!
                                    .frame(width: 50, height: 50)
                                    // Seçiliyse etrafına şık bir çerçeve (stroke) çiziyoruz
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: viewModel.selectedColorHex == hex ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.selectedColorHex = hex
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            // Üst barda İptal ve Kaydet butonları
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss() // Ekranı direkt kapatır
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save { success in
                            if success {
                                dismiss() // Başarılıysa ekranı kapat, TodoListView zaten Firebase'i dinlediği için anında güncellenecek!
                            }
                        }
                    }
                    .fontWeight(.bold)
                }
            }
            // Hata olursa alert göster
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview {
    NewHabitView()
}
