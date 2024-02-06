//
//  TripsView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import SwiftUI

struct TripsView: View {
    @State private var showTripInputSheet = false
    
    // Trip object with all the trips in it
    @EnvironmentObject var createTrip: CreateTripVM
    
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
                    //Bring up the Trip input sheet
                    Button {
                        showTripInputSheet.toggle()
                    }
                label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showTripInputSheet) {
                    TripsInputSheet()
                        .presentationDetents([.large])
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(25)
        }
    }
}

#Preview {
    TripsView()
        .environmentObject(CreateTripVM())
}
