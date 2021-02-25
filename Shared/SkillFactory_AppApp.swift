//
//  SkillFactory_AppApp.swift
//  Shared
//
//  Created by v.prusakov on 2/5/21.
//

import SwiftUI
import EventKit

struct EventEnvironmentKey: EnvironmentKey {
    static var defaultValue: EKEventStore = EKEventStore()
}

extension EnvironmentValues {
    var eventStore: EKEventStore {
        get {
            self[EventEnvironmentKey.self]
        }
        
        set {
            self[EventEnvironmentKey.self] = newValue
        }
    }
}

private var eventStore = EKEventStore()

@main
struct SkillFactory_AppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.eventStore, eventStore)
                .environmentObject(HomeViewModel(eventStore: eventStore))
        }
    }
}
