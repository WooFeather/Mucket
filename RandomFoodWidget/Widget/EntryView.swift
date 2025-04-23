//
//  EntryView.swift
//  RandomFoodWidgetExtension
//
//  Created by 조우현 on 4/23/25.
//

import SwiftUI

struct RandomFoodWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            titleView()
            Spacer()
            randomFoodView()
            Spacer()
            linkView()
        }
    }
    
    
    // MARK: - Function
    private func titleView() -> some View {
        Text("오늘 뭐먹지?")
            .foregroundStyle(.textPrimary)
    }
    
    private func randomFoodView() -> some View {
        Text(entry.foods.randomElement() ?? "파스타")
            .foregroundStyle(.textPrimary)
            .font(.title.bold())
    }
    
    private func linkView() -> some View {
        Link(destination: URL(string: "mucket://search")!) {
            Capsule()
                .fill(.themePrimary)
                .overlay {
                    Text("레시피 검색하기")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
        }
    }
}
