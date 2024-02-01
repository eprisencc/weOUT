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
    @State private var dayOfTheTrip: String = ""
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var agendaText = ""
    @State var itinerary: [ItineraryModel] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1F1F1F")
                    .ignoresSafeArea()
                //.opacity(0.8)
                
                VStack(alignment: .center) {
                    HStack {
                        Text("")
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
                        .foregroundStyle(.white)
                    }
                    Divider()
                    Spacer()
                    
                    Section {
                        Text("What day of the trip?")
                            .font(.title)
                            .foregroundStyle(.white)
                        //.bold()

                        //TextFieldButton(text: $dayOfTheTrip,textFieldExampleMessage: "ex. Day 1")

                        Spacer()
                    }
                    
                    HStack {
                        Text("Thumbnail (optional)")
                            .foregroundStyle(.white)
                            .font(.title)
                        //.bold()
                        
                        Button(role: .cancel, action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: "plus")
                        }
                        .foregroundColor(Color.white)
                    }
                    HStack(alignment: .center) {
                        if let image {
                            image
                                .resizable()
                                .scaledToFit()
                            //.frame(width: .infinity, height: 100.0)
                        }
                    }
                    Spacer()
                    Text("Agenda?")
                        .font(.title)
                        .foregroundStyle(.white)
                    //.bold()

                   // TextFieldButton(text: $agendaText,textFieldExampleMessage: "ex. Things that are scheduled")

                    
                    Button("Submit") {
                        itinerary.append(ItineraryModel(dayOfTheTrip: dayOfTheTrip, tripImage: image ?? Image("Chicago"), agenda: agendaText))
                    }
                    .font(.title)
                }
                .padding(25)
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
        image = Image(uiImage: inputImage)
    }
}




#Preview {
    ItineraryInputSheet()
}
