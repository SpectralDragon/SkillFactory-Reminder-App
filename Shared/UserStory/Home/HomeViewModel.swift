//
//  HomeViewModel.swift
//  SkillFactory App (iOS)
//
//  Created by v.prusakov on 2/25/21.
//

import Combine
import EventKit

class HomeViewModel: ObservableObject {
    
    @Published var reminders: [EKReminder] = []
    
    private let eventStore: EKEventStore
    
    init(eventStore: EKEventStore) {
        self.eventStore = eventStore
    }
    
    func refreshView() {
        self.getData()
    }
    
    func checkAvailability() {
        self.eventStore.requestAccess(to: .reminder) { (finish, error) in
            self.getData()
        }
    }
    
    private func getData() {
        guard let calendar = self.eventStore.defaultCalendarForNewReminders() else { return }
        let predicate = self.eventStore.predicateForReminders(in: [calendar])
        
        self.eventStore.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = reminders ?? []
            }
        }
    }
}
