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
   // @State private var dayOfTheTrip: String = ""
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    //@State private var agendaText = ""
    //@Binding var itinerary: [ItineraryModel]
    //@State var itineraryIndex = -1
    //@State var tripDay: Int = 0
    
    @EnvironmentObject var createItinerary: CreateItineraryVM
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1F1F1F")
                    .ignoresSafeArea()
                //.opacity(0.8)
                
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
                            HStack {
                                /*Text("")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                //.presentationDetents([.medium])
                                Spacer()
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                }
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(.white)*/
                            }
                            
                            Spacer()
                            
                            Text("What day of the trip?")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)
                            //.bold()
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
                                //.bold()
                                
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
                                    //.frame(width: .infinity, height: 100.0)
                                
                            }
                            Spacer()
                            Text("Agenda?")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)
                            //.bold()
                            TextFieldButton(text: $createItinerary.agenda,textFieldExampleMessage: "ex. Things that are scheduled")
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
                            
                        }
                        VStack(alignment: .center) {
                            Button("Submit") {
                                createItinerary.addToItineraryArray()
                                //itinerary.append(ItineraryModel(dayOfTheTrip: dayOfTheTrip, tripImage: image ?? Image(""), agenda: agendaText, tripDay: (itineraryIndex + 1)))
                                
                               
                                
                                //print("Day of the trip \(itinerary[itineraryIndex].dayOfTheTrip) and agenda \(itinerary[itineraryIndex].agenda)")
                                
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
    ItineraryInputSheet()
        .environmentObject(CreateItineraryVM())
}
