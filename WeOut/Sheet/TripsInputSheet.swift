//
//  TripsInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 2/4/24.
//

import SwiftUI

struct TripsInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State private var startSelectedDate: Date = Date.now
    @State private var endSelectedDate: Date = Date.now
    @State private var isStartDatePickerVisible = true
    @State private var isEndDatePickerVisible = true
    var destination: String = ""
    var index: Int = -1
    
    @EnvironmentObject var createTrip: CreateTripVM
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1F1F1F")
                    .ignoresSafeArea()
                
                VStack {
                    createDestinationHeading
                    createDestinationDetails
                    
                    VStack(alignment: .center) {
                        divider
                        Button("Submit") {
                            //createTrip.startDate = startSelectedDate
                            //createTrip.endDate = endSelectedDate
                            createTrip.addToTripArray()
                            print("Elements of trip array \(createTrip.tripArr)")
                            dismiss()
                        }
                        .padding(15)
                        .font(.title)
                    }
                    
                }
            }
            
            
        }
        //.navigationTitle("Test")
        .onChange(of: inputImage) { loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    var createDestinationHeading: some View {
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
    }
    
    var createDestinationDetails: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                Spacer()
                Text("Destination")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(15)
                
                TextFieldButton(text: $createTrip.destination ,textFieldExampleMessage: "ex. New York")
                divider
                Spacer()
                
                
                Text("Dates")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(15)
                
                
                HStack {
                    CompactDatePickerView(selectedDate: $createTrip.startDate)
                        .background(Color.white)
                        .frame(width: 150, height: 50)
                        .padding()
                    
                    CompactDatePickerView(selectedDate: $createTrip.endDate)
                        .background(Color.white)
                        .frame(width: 150, height: 50)
                        .padding()
                }
                divider
                
                HStack {
                    Text("Location Photo (optional)")
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
            }
            
            HStack(alignment: .center) {
                createTrip.tripImage
                    .resizable()
                    .scaledToFit()
                    .padding(25)
                
            }
        }
    }
    
    var divider: some View {
        Divider()
            .frame(height: 1)
            .overlay(Color(hex: "F5DFA3"))
            .padding()
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        createTrip.tripImage = Image(uiImage: inputImage)
        
    }
}

#Preview {
    TripsInputSheet()
        .environmentObject(CreateTripVM())
}
