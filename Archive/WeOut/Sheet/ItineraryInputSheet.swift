//
//  ItineararyInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/30/24.
//

import SwiftUI
import PhotosUI

//Sheet that displays the input for the itinerary
struct ItineraryInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    var index: Int = -1
    var destination: String = ""
    @State var itinerary: ItineraryModel = ItineraryModel(dayOfTheTrip: "", itineraryImage: Image("blankImage"), agenda: "", destination: "")
    @Binding var trip: TripModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1F1F1F")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Create")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(15)
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .padding(15)
                    }
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            Spacer()
                            
                            Text("What day of the trip?")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)
                            
                            TextFieldButton(text: $itinerary.dayOfTheTrip ,textFieldExampleMessage: "ex. Day 1")
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
                            Spacer()
                            
                            HStack {
                                Text("Thumbnail (optional)")
                                    .foregroundStyle(.white)
                                    .font(.title)
                                    .padding(15)
                                
                                Button(role: .cancel, action: {
                                    showingImagePicker = true
                                }) {
                                    Image(systemName: "plus")
                                }
                                .foregroundColor(Color.white)
                            }
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
                            HStack(alignment: .center) {
                                itinerary.itineraryImage
                                    .resizable()
                                    .scaledToFit()
                                    .padding(25)
                                
                            }
                            Spacer()
                            Text("Agenda?")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)
                            
                            TextFieldButton(text: $itinerary.agenda,textFieldExampleMessage: "ex. Things that are scheduled")
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
                            
                        }
                    } 
                    VStack(alignment: .center) {
                        Button("Submit") {
                            //trip.itineraryArr.append(itinerary)
                            dismiss()
                        }
                        .padding(15)
                        
                        .font(.title)
                    }
                }
                .padding()
            }
        }
        .onChange(of: inputImage) { loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onAppear() {
            itinerary.destination = destination
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        itinerary.itineraryImage = Image(uiImage: inputImage)
        
    }
}




#Preview {
    ItineraryInputSheet(trip: .constant(TripModel(startDate: Date.now, endDate: Date.now, destination: ""/*, tripImage: Image("blankImage")*/)))
}
