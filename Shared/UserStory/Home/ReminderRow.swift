//
//  ReminderRow.swift
//  Shared
//
//  Created by v.prusakov on 2/5/21.
//

import SwiftUI
import EventKit

struct ReminderRow: View {
    
    @Environment(\.eventStore) var eventStore
    
    let reminder: EKReminder
    
    var body: some View {
        HStack {
            Button(action: {
                reminder.isCompleted.toggle()
                try! self.eventStore.save(reminder, commit: true)
            }, label: {
                Image(systemName: "checkmark")
            })
            .buttonStyle(CircleButtonStyle(isCompleted: reminder.isCompleted))
                
            Text(reminder.title)
        }
    }
}
