//
//  TripsView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import SwiftUI

struct TripsView: View {
    var body: some View {
        ZStack{
            Color(hex: "#003459")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Text("Trips")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                        .bold()
                    Spacer()
                    //Bring up the itinerary input sheet
                    Button {
                    }
                label: {
                    Image(systemName: "plus")
                } 
                .foregroundColor(.white)
                .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(25)
        }
    }
}

#Preview {
    TripsView()
}
