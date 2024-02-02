//
//  datePicker.swift
//  WeOut
//
//  Created by Kern Redd on 2/2/24.
//

import SwiftUI



struct ContentView3: View {
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = false

    var body: some View {
        VStack {
            Button(action: {
                isDatePickerVisible.toggle()
            }) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding()

            if isDatePickerVisible {
                DatePicker("Start date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
            }

            Text("Start Date: \(formattedDate)")
                .padding()
        }
    }

    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: selectedDate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
    }
}

