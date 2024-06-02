//
//  DatePicker.swift
//  WeOut
//
//  Created by Jacquese Whitson on 5/31/24.
//

import SwiftUI

struct SelectDate: View {
    @State var startDate = Date()
    var body: some View {
        DatePicker(selection:$startDate,label:{ Text("Date")})
        
    }
}

#Preview {
    SelectDate()
}
