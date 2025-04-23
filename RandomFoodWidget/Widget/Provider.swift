//
//  Provider.swift
//  RandomFoodWidgetExtension
//
//  Created by 조우현 on 4/23/25.
//

import Foundation
import WidgetKit

struct Provider: TimelineProvider {
    let foods = [
      "파스타","라면","피자","떡볶이","김밥",
      "강정","순대","꼬치","햄버거","비빔밥",
      "볶음밥", "샐러드", "전", "튀김", "삼겹살",
      "치킨", "샌드위치", "김치찌개", "된장찌개", "스테이크",
      "불고기", "해장국", "죽", "국수", "전골", 
      "리조또", "주먹밥", "카레", "부대찌개", "돈가스",
      "초밥", "떡갈비", "스프", "덮밥"
    ]
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), food: "파스타")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let random = foods.randomElement()!
        let entry = SimpleEntry(date: Date(), food: random)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let random = foods.randomElement()!
            let entry = SimpleEntry(date: entryDate, food: random)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
