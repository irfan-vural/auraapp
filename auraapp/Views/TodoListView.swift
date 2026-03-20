//
//  TodoListView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import SwiftUI

struct TodoListView: View {
    var body: some View {
        Text("Hello, todolist view")
        HabitCardView(habit: Habit(id: "1", title: "Read 10 Pages", createdAt: Date().timeIntervalSince1970, icon: "book.fill", colorHex: "#3498db", currentStreak: 5, longestStreak: 12, isReminderEnabled: false, frequency: []))
        HabitCardView(habit: Habit(id: "1", title: "Read 10 Pages", createdAt: Date().timeIntervalSince1970, icon: "book.fill", colorHex: "#3498db", currentStreak: 5, longestStreak: 12, isReminderEnabled: false, frequency: []))
        HabitCardView(habit: Habit(id: "1", title: "Read 10 Pages", createdAt: Date().timeIntervalSince1970, icon: "book.fill", colorHex: "#3498db", currentStreak: 5, longestStreak: 12, isReminderEnabled: false, frequency: []))
    }
}

#Preview {
    TodoListView()
}
