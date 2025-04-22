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
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}
