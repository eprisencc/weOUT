//
//  ItineararyInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/30/24.
//

import SwiftUI
import PhotosUI

//Sheet that displays the input for the itinerary
struct EditItineraryInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingDeleteAlert = false
    @Binding var itineraryItem: ItineraryModel
    @Binding var trip: TripModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1F1F1F")
                    .ignoresSafeArea()
                VStack {
                    itineraryHeading
                    itineraryDetails
                    itinerarySaveDelete
                }
                .padding()
            }
        }
        //.navigationTitle("Test")
        .onChange(of: inputImage) { loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    var itineraryHeading: some View {
        HStack {
            Text("Edit")
                .font(.title)
                .foregroundStyle(.white)
                .padding(15)
            //.presentationDetents([.medium, .large])
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
        
    }
    var itineraryDetails: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Spacer()
                
                Text("What day of the trip?")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(15)
                
                TextFieldButton(text: $itineraryItem.dayOfTheTrip ,textFieldExampleMessage: "ex. Day 1")
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
                HStack(alignment: .bottom) {
                    
                    itineraryItem.itineraryImage
                        .resizable()
                        .scaledToFit()
                        .padding(25)
                    
                }
                Spacer()
                Text("Agenda?")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(15)
                
                TextFieldButton(text: $itineraryItem.agenda,textFieldExampleMessage: "ex. Things that are scheduled")
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hex: "F5DFA3"))
                    .padding()
                
            }
        }
    }
    var itinerarySaveDelete: some View {
        VStack(alignment: .center) {
            HStack {
                Button("Save") {
                    dismiss()
                }
                .padding(15)
                .font(.title)
                
                Button("Delete") {
                    showingDeleteAlert = true
                    
                }
                .alert("Do you want to delete this card?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        dismiss()
                        trip.removeItineraryItem(itineraryItem: itineraryItem)
                    }
                }
                .padding(15)
                .font(.title)
            }
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        itineraryItem.itineraryImage = Image(uiImage: inputImage)
        
    }
}




#Preview {
    EditItineraryInputSheet(itineraryItem: .constant(ItineraryModel(dayOfTheTrip: "", itineraryImage: Image("blankImage"), agenda: "", destination: "")), trip: .constant(TripModel(startDate: Date.now, endDate: Date.now, destination: "", tripImage: Image("blankImage"))))
}
