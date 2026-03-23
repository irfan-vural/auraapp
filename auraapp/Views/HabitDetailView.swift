import SwiftUI

struct HabitDetailView: View {
    @State var viewModel: HabitDetailViewViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // SİHİRLİ SATIR: Sistem arka plan rengini kullanıyoruz.
                // Light'ta beyaz, Dark'ta siyah/çok koyu gri olacak.
                Color(.systemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // --- 1. ANA KART (İKON VE BAŞLIK) ---
                        HStack(spacing: 20) {
                            Image(systemName: viewModel.habit.icon)
                                .font(.system(size: 30))
                                // İkon rengi alışkanlığın kendi rengi (yeşil)
                                .foregroundColor(Color(hex: viewModel.habit.colorHex))
                                .frame(width: 70, height: 70)
                                // İkon arka planı Dark modda da açık bir katman olarak kalır
                                .background(Color(.tertiarySystemBackground))
                                .clipShape(Circle())
                            
                            // Başlık metni alışkanlığın renginde (yeşil)
                            // Hem Light hem de Dark'ta okunacaktır.
                            Text(viewModel.habit.title)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: viewModel.habit.colorHex))
                            
                            Spacer()
                        }
                        .padding()
                        // Kart arka planı Dark modda daha koyu gri olur (image_4.png'deki gibi çok koyu değil!)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(24)
                        
                        // --- 2. CHECKLIST (Eğer varsa) ---
                        if !viewModel.habit.checklist.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Checklist")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary) // Otomatik okunaklı metin
                                
                                ForEach(viewModel.habit.checklist) { item in
                                    HStack(spacing: 16) {
                                        // Custom Checkbox
                                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.title2)
                                            .foregroundColor(item.isCompleted ? Color(hex: viewModel.habit.colorHex) : .gray)
                                            .onTapGesture {
                                                withAnimation(.spring()) {
                                                    viewModel.toggleChecklistItem(id: item.id)
                                                }
                                            }
                                        
                                        // Soluk dikey çizgi detayı (image_2.png'deki gibi)
                                        Rectangle()
                                            .fill(item.isCompleted ? Color(hex: viewModel.habit.colorHex) : Color.clear)
                                            .frame(width: 2, height: 20)
                                        
                                        Text(item.title)
                                            .font(.body)
                                            .strikethrough(item.isCompleted, color: .gray)
                                            // Tamamlanmadıysa birincil metin rengi (Dark'ta beyaz)
                                            .foregroundColor(item.isCompleted ? .gray : .primary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        // --- 3. HEDEF VE KAYDIRICI (Görseldeki gibi) ---
                        if viewModel.habit.type == .counter {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Goal: ")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary) // Otomatik okunaklı metin
                                    + Text("\(Int(viewModel.habit.todayProgress))/\(Int(viewModel.habit.goalTargetValue)) \(viewModel.habit.goalUnit)")
                                        .font(.headline)
                                        .foregroundColor(.secondary) // Otomatik okunaklı metin (image_4.png'deki sorun çözüldü)
                                    Spacer()
                                }
                                
                                // Özel Kaydırıcı Kartı
                                HStack(spacing: 15) {
                                    Button(action: {
                                        withAnimation { viewModel.adjustProgress(by: -1) }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title)
                                            // X ikonu gibi otomatik okunaklı metin (Light'ta siyah, Dark'ta beyaz)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    // Özel Kaydırıcı
                                    Slider(value: Binding(
                                        get: { viewModel.habit.todayProgress },
                                        set: { newValue in
                                            viewModel.updateProgress(to: newValue)
                                        }
                                    ), in: 0...viewModel.habit.goalTargetValue, onEditingChanged: { editing in
                                        if !editing { viewModel.saveChanges() } // Parmağı çekince kaydet
                                    })
                                    .tint(Color(hex: viewModel.habit.colorHex)) // Kaydırıcı alışkanlığın renginde (yeşil)
                                    
                                    Button(action: {
                                        withAnimation { viewModel.adjustProgress(by: 1) }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                            }
                        }
                        
                        // --- 4. TEKRAR KARTI ---
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Repeat")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 16) {
                                Image(systemName: "calendar")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                    .frame(width: 50, height: 50)
                                    .background(Color.green.opacity(0.1))
                                    .clipShape(Circle())
                                
                                // "Daily" metni ikincil metin rengi (Dark'ta beyaz/açık gri)
                                Text(viewModel.habit.repeatCycle)
                                    .font(.body)
                                    .foregroundColor(.secondary) // image_4.png'deki sorun çözüldü
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(20)
                        }
                        
                        // --- 5. HATIRLATICI KARTI ---
                        if viewModel.habit.isReminderEnabled {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Reminder")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 16) {
                                    Image(systemName: "clock.fill")
                                        .font(.title2)
                                        // İkon alışkanlığın renginde (yeşil)
                                        .foregroundColor(Color(hex: viewModel.habit.colorHex))
                                        .frame(width: 50, height: 50)
                                        .background(Color(hex: viewModel.habit.colorHex).opacity(0.1))
                                        .clipShape(Circle())
                                    
                                    // "21:16" metni ikincil metin rengi (Dark'ta beyaz)
                                    Text(viewModel.habit.reminderTime ?? "")
                                        .font(.body)
                                        .foregroundColor(.secondary) // image_4.png'deki sorun çözüldü
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                            }
                        }
                        
                    }
                    .padding(24)
                }
            }
            // --- HEADER NAVİGASYON (Görseldeki gibi Çöp Kutusu ve X) ---
            .navigationTitle("View Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.deleteHabit { success in
                            if success { dismiss() }
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red) // Çöp kutusu kırmızı
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            // X ikonu otomatik okunaklı metin (Light'ta siyah, Dark'ta beyaz)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
