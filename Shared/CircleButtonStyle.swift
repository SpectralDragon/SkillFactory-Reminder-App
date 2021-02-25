//
//  CircleButtonStyle.swift
//  SkillFactory App (iOS)
//
//  Created by v.prusakov on 2/25/21.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    
    let isCompleted: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 3)
            .background(
                ZStack {
                    Circle()
                        .stroke(Color.green, lineWidth: 1)
                    
                    Circle()
                        .fill(self.backgroundView(configuration: configuration))
                }
            )
            .frame(width: 32, height: 32)
            .foregroundColor(isCompleted ? .white : .clear)
    }
    
    private func backgroundView(configuration: Configuration) -> Color {
        if self.isCompleted {
            return configuration.isPressed ? Color.green.opacity(0.1) : Color.green
        } else {
            return configuration.isPressed ? Color.green.opacity(0.1) : Color.clear
        }
    }
}
