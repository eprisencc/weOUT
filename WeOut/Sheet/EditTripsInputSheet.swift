//
//  EditTripsInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 2/12/24.
//

import SwiftUI

struct EditTripsInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State var index: Int = -1
    @State private var showingDeleteAlert = false
    
    @EnvironmentObject var createTrip: CreateTripVM
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1F1F1F")
                    .ignoresSafeArea()
                
                
                VStack {
                    tripheading
                    tripDetails
                    tripSaveDelete
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
    var tripheading: some View {
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
            .font(.title)
            .foregroundStyle(.white)
            .padding(15)
        }
    }
    var tripDetails: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer()
                Text("Destination?")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(15)
                
                TextFieldButton(text: $createTrip.destination ,textFieldExampleMessage: "ex. New York")
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hex: "F5DFA3"))
                    .padding()
                
                Spacer()
                Text("Dates?")
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
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hex: "F5DFA3"))
                    .padding()
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
                HStack(alignment: .center) {
                    
                    createTrip.tripImage
                        .resizable()
                        .scaledToFit()
                        .padding(25)
                    
                }
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hex: "F5DFA3"))
                    .padding()
                
            }
        }
    }
    var tripSaveDelete: some View {
        VStack(alignment: .center) {
            HStack {
                Button("Save") {
                    createTrip.addToExistingTripArray(index: index)
                    dismiss()
                }
                .padding(15)
                .font(.title)
                
                Button("Delete") {
                    showingDeleteAlert = true
                    
                }
                .alert("Do you want to delete this card?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) { 
                        createTrip.tripArr.remove(at: index)
                        dismiss()
                    }
                }
                .padding(15)
                .font(.title)
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
    EditTripsInputSheet()
    //.environmentObject(CreateItineraryVM())
        .environmentObject(CreateTripVM())
}
