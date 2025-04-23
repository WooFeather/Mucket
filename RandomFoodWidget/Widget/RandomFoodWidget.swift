//
//  RandomFoodWidget.swift
//  RandomFoodWidget
//
//  Created by 조우현 on 4/23/25.
//

import SwiftUI
import WidgetKit

struct RandomFoodWidget: Widget {
    let kind: String = "RandomFoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RandomFoodWidgetEntryView(entry: entry)
                    .containerBackground(.backgroundPrimary, for: .widget)
            } else {
                RandomFoodWidgetEntryView(entry: entry)
                    .padding()
                    .background(.backgroundPrimary)
            }
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("오늘 뭐먹지?")
        .description("추천 요리를 랜덤으로 보여줍니다. 레시피 검색하기 버튼을 통해 바로 검색할 수 있습니다.")
    }
}

#Preview(as: .systemSmall) {
    RandomFoodWidget()
} timeline: {
    SimpleEntry(date: .now, food: "파스타")
    SimpleEntry(date: .now, food: "족발")
}
