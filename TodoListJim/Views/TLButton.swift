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
        .frame(width: UIScreen.main.bounds.width - 70, height: 50)
        
    }
}

#Preview {
    TLButton(title: "Log In", backGround: .green) { //
    }
}
