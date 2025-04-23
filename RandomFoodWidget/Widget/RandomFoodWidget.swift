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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    RandomFoodWidget()
} timeline: {
    SimpleEntry(date: .now, food: "파스타")
    SimpleEntry(date: .now, food: "족발")
}
