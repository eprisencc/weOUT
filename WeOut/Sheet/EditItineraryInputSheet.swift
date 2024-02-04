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
    @State var index: Int
    
    @EnvironmentObject var createItinerary: CreateItineraryVM
    
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
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            Spacer()
                            
                            Text("What day of the trip?")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)
                            
                            TextFieldButton(text: $createItinerary.dayOfTheTrip ,textFieldExampleMessage: "ex. Day 1")
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
                                
                                createItinerary.tripImage
                                    .resizable()
                                    .scaledToFit()
                                    .padding(25)
                                
                            }
                            Spacer()
                            Text("Agenda?")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)
                            
                            TextFieldButton(text: $createItinerary.agenda,textFieldExampleMessage: "ex. Things that are scheduled")
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
                            
                        }
                        VStack(alignment: .center) {
                            Button("Edit") {
                                    createItinerary.addToExistingItineraryArray(index: index)
                                    dismiss()
                            }
                            .padding(15)
                            
                            .font(.title)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Test")
        .onChange(of: inputImage) { loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        createItinerary.tripImage = Image(uiImage: inputImage)
        
    }
}




#Preview {
    EditItineraryInputSheet(index: -1)
        .environmentObject(CreateItineraryVM())
}
