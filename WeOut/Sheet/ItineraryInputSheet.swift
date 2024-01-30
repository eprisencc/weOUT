//
//  ItineararyInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/30/24.
//

import SwiftUI

//Sheet that displays the input for the itinerary
struct ItineraryInputSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var dayOfTheTrip: String = ""
    
    var body: some View {
        ZStack {
            Color(hex: "1F1F1F")
                .ignoresSafeArea()
            //.opacity(0.8)
            VStack(alignment: .leading) {
                HStack {
                    Text("Title")
                        .font(.title)
                        .foregroundStyle(.white)
                        .presentationDetents([.medium])
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.white)
                }
                Spacer()
                
                Text("What day of the trip?")
                    .font(.title)
                    .foregroundStyle(.white)
                TextFieldButton(text: "", textFieldExampleMessage: "ex. Day 1")
                
                /*TextField("ex. Day 1", text: $dayOfTheTrip, axis: .vertical)
                    .foregroundStyle(.black)
                    .background(.white)*/
                
            }
            .padding(25)
        }
    }
}


#Preview {
    ItineraryInputSheet()
}
