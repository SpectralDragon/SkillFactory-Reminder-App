//
//  HomeView.swift
//  SkillFactory App (iOS)
//
//  Created by v.prusakov on 2/25/21.
//

import SwiftUI
import EventKit

struct HomeView: View {
    
    @Environment(\.eventStore) var eventStore
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State var isAddEventShown = false
    
    var body: some View {
        NavigationView {
            Group {
                if !self.viewModel.reminders.isEmpty {
                    List(self.viewModel.reminders, id: \.self, rowContent: { reminder in
                        NavigationLink(
                            destination: AddOrEditReminderView(reminder: reminder),
                            label: { ReminderRow(reminder: reminder) }
                        )
                    })
                    .listStyle(PlainListStyle())
                } else {
                    Button {
                        self.viewModel.refreshView()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: { self.isAddEventShown = true }, label: {
                        Image(systemName: "plus")
                    })
                })
            })
            .navigationTitle(Text("Reminders"))
            .sheet(isPresented: $isAddEventShown) {
                NavigationView {
                    AddOrEditReminderView()
                }
            }
        }
        .onAppear(perform: self.viewModel.checkAvailability)
        .onReceive(NotificationCenter.default.publisher(for: .EKEventStoreChanged, object: self.eventStore), perform: { _ in
            self.viewModel.refreshView()
        })
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.eventStore, EKEventStore())
    }
}
