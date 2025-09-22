//
//  TLButton.swift
//  TodoListJim
//
//  Created by Alla on 03/06/2025.
//

import SwiftUI

struct TLButton: View {
    let title: String
    let backGround: Color
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(backGround)
                Text(title)
                    .foregroundStyle(Color.white)
                    .bold(true)
            }
        }
    }
}

#Preview {
    TLButton(title: "Log In", backGround: .green) { //
    }
}
