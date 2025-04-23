//
//  Entry.swift
//  RandomFoodWidgetExtension
//
//  Created by 조우현 on 4/23/25.
//

import Foundation
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let foods: [String] = ["파스타", "라면", "피자", "떡볶이", "김밥", "닭강정", "순대", "닭꼬치", "오뎅", "족발"]
}
