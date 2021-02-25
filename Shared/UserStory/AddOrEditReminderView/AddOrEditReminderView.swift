//
//  AddOrEditReminderView.swift
//  SkillFactory App (iOS)
//
//  Created by v.prusakov on 2/25/21.
//

import SwiftUI
import EventKit

struct AddOrEditReminderView: View {
    
    @Environment(\.eventStore) var eventStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var title: String = ""
    @State var notes: String = ""
    @State var alarms: [EKAlarm] = []
    
    let reminder: EKReminder?
    
    init(reminder: EKReminder) {
        self.reminder = reminder
        self._title = State(initialValue: reminder.title)
        self._notes = State(initialValue: reminder.notes ?? "")
        self._alarms = State(initialValue:  reminder.alarms ?? [])
    }
    
    init() {
        self.reminder = nil
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $title)
                TextField("Notes", text: $notes)
            }
            
            Section(header: Text("Alarms")) {
                ForEach(self.alarms, id: \.absoluteDate) { alarm in
                    DatePicker(
                        selection: Binding(get: {
                            return alarm.absoluteDate ?? Date()
                        }, set: {
                            alarm.absoluteDate = $0
                        }),
                        label: {
                            Text("Alarm \((self.alarms.firstIndex(where: { $0 === alarm }) ?? 0) + 1)")
                        })
                    
                }
                .onDelete { indexSet in
                    self.alarms.remove(atOffsets: indexSet)
                }
                
                Button(action: {
                    withAnimation {
                        self.alarms.append(EKAlarm(absoluteDate: Date()))
                    }
                }, label: {
                    Label("Add Alarm", systemImage: "plus")
                })
            }
        }
        .navigationBarTitle(self.reminder != nil ? "Edit Reminder" : "Add Reminder", displayMode: .inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(self.reminder != nil ? "Save" :"Add", action: self.addEvent)
                    .disabled(self.title.isEmpty)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Group {
                    if reminder == nil {
                        Button("Close", action: { self.presentationMode.wrappedValue.dismiss() })
                    } else {
                        EmptyView()
                    }
                }
            }
        })
    }
    
    func addEvent() {
        let reminderToSave: EKReminder
        
        if let reminder = self.reminder {
            reminderToSave = reminder
        } else {
            let reminder = EKReminder(eventStore: self.eventStore)
            reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
            reminderToSave = reminder
        }
        
        reminderToSave.title = self.title
        reminderToSave.notes = !self.notes.isEmpty ? self.notes : nil
        reminderToSave.alarms = self.alarms
        
        do {
            try self.eventStore.save(reminderToSave, commit: true)
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            print(error)
        }
    }
}
