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
        let food = entry.food
        let encoded = food.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "mucket://search?query=\(encoded)")!
        
        VStack {
            titleView()
            Spacer()
            randomFoodView(food)
            Spacer()
            linkView(url)
        }
    }
    
    
    // MARK: - Function
    private func titleView() -> some View {
        Text("오늘 뭐먹지?")
            .foregroundStyle(.textPrimary)
    }
    
    private func randomFoodView(_ food: String) -> some View {
        Text(food)
            .foregroundStyle(.textPrimary)
            .font(.title.bold())
    }
    
    private func linkView(_ url: URL) -> some View {
        Link(destination: url) {
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
