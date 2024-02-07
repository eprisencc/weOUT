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
    @ObservedObject var createTrip: CreateTripVM
    
    @State var myIndex: Int
    
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
                        createTrip.resetTripProperties()
                    }
                label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showTripInputSheet) {
                    TripsInputSheet(createTrip: createTrip)
                        .presentationDetents([.large])
                        .background(Color(hex: "1F1F1F").ignoresSafeArea())
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                }
                Spacer()
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(createTrip.tripArr.indices, id: \.self) { index in
                            
                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                //RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    //.foregroundColor(Color(hex: "#007EA7"))
                                VStack {
                                    createTrip.tripArr[index].tripImage
                                        .resizable()
                                        .scaledToFit()
                                }
                                VStack(alignment: .leading){
                                    HStack {
                                        Text(createTrip.tripArr[index].destination)
                                            .font(.title)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                        Spacer()
                                        Button() {
                                            
                                            //createItinerary.itineraryArr.remove(at: index)
                                            createTrip.destination = createTrip.tripArr[index].destination
                                            
                                            createTrip.tripImage = createTrip.tripArr[index].tripImage
                                            
                                            //createItinerary.agenda = createItinerary.itineraryArr[index].agenda
                                            
                                            //showEditItinearyInputSheet.toggle()
                                            myIndex = index
                                            
                                        } label: {
                                            Image(systemName: "ellipsis")
                                        }
                                        //.sheet(isPresented: $showEditItinearyInputSheet) {
                                            //EditItineraryInputSheet(index: myIndex)
                                                //.presentationDetents([.large])
                                        }
                                        .foregroundColor(Color.white)
                                    }
//                                    createTrip.tripArr[index].tripImage
//                                        .resizable()
//                                        .scaledToFit()
                                    
                                Text(createTrip.tripArr[index].details)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                }
                                .padding(20)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(25)
        }
    }


#Preview {
    TripsView(createTrip: CreateTripVM(), myIndex: -1)
        .environmentObject(CreateTripVM())
}
