//
//  DatePickerTool.swift
//  WeOut
//
//  Created by Jonathan Loving on 2/6/24.
//

import SwiftUI

struct DatePickerTool: View {
        @State private var selectedDateCompact = Date()
        @State private var isDatePickerVisible = true

        var body: some View {
            VStack {
//                Button(action: {
//                    isDatePickerVisible.toggle()
//                }) {
//                    Image(systemName: "calendar")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .padding()*/
//                }

//                if isDatePickerVisible {
                    CompactDatePickerView(selectedDate: $selectedDateCompact)
                        .padding()
//                    
//                }

//                Text("Start Date: \(formattedDate(selectedDateCompact))")
//                    .padding()
//                    .onTapGesture {
//                        isDatePickerVisible.toggle()
//                    }
            }
        }

        private func formattedDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: date)
        }

    struct CompactDatePickerView: View {
        @Binding var selectedDate: Date
        //var dateText: String 
            var body: some View {
            DatePicker("Select a Date",selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(CompactDatePickerStyle())
                .padding(45)
        }
    }
}

#Preview {
    DatePickerTool()
}
