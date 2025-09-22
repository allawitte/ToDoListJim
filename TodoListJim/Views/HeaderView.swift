//
//  HeaderView.swift
//  TodoListJim
//
//  Created by Alla on 02/06/2025.
//

import SwiftUI

struct HeaderView: View {
    var title: String
    var subtitle: String
    var angle: Double
    var background: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(background)
                .rotationEffect(Angle(degrees: angle))
               
            VStack {
                Text(title)
                    .font(.system(size: 50, weight: .semibold))
                    .padding(.top, 80)
                Text(subtitle)
                    .font(.system(size: 30))
            }
            .foregroundStyle(Color.white)
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 350)
        .offset(y: -135)
    }
}

#Preview {
    HeaderView(title: "Todo List", subtitle: "Get your tasks done!", angle: 15, background: .pink)
}
