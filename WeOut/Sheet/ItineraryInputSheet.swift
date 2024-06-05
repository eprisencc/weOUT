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
    //var index: Int = -1
    var destination: String = ""
    @State var itinerary: ItineraryModel
    @State var trip: TripModel
    @EnvironmentObject private var profileVm: ProfileViewModel
    @EnvironmentObject private var planVm: PlansViewModel
    @State var pending = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if !pending {
                    Color(hex: "1F1F1F")
                        .ignoresSafeArea()
                    
                    VStack {
                        itineraryInputHeading
                        itineraryInputDetails
                        itineraryInputSubmit
                        
                    }
                    .padding()
                } else {
                    ProgressView("Creating Your Agenda...")
                        .foregroundStyle(.white)
                        .font(.title)
                }
            }
        }
        
        .onChange(of: profileVm.photoPickerItem){
            _,_ in
            Task {
                if let _ = profileVm.photoPickerItem,
                   let data = try? await profileVm.photoPickerItem?.loadTransferable(type: Data.self){
                    
                    if let image = UIImage(data: data){
                        profileVm.eventImage = image
                        
                        print("💦\(profileVm.eventImage ?? UIImage())")
                        print("📸Succcesffullly selected image")
                        profileVm.newPhoto = Photo()
                        
                    }
                    
                    
                }
                
                profileVm.photoPickerItem = nil
            }
            profileVm.didSelectImage = true
        }
        .task {
            try? await profileVm.loadCurrentUser()
        }
    }
}


#Preview {
    ItineraryInputSheet(itinerary: ItineraryModel(), trip: TripModel())
        .environmentObject(ProfileViewModel())
}



private extension ItineraryInputSheet {
    
    var itineraryInputHeading: some View {
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
            .font(.title)
            .foregroundStyle(.white)
            .padding(15)
        }
    }
    
    var itineraryInputDetails: some View {
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
                    photoPicker
                }
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hex: "F5DFA3"))
                    .padding()
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
    }
    
    var itineraryInputSubmit: some View {
        VStack(alignment: .center) {
            Button("Submit") {
                pending = true
                if let _ = profileVm.currentUser {
                    Task{
                        let success =  await planVm.addItinerary(to: trip, with: itinerary, image: profileVm.eventImage ?? UIImage())
                        if success {
                            pending = false
                            dismiss()
                            
                        }
                        
                        
                    }
                }
                
            }
            .padding(15)
            .foregroundStyle(.white)
            .font(.title)
        }
    }
    
    var photoPicker : some View {
        VStack{
            PhotosPicker(selection: $profileVm.photoPickerItem,matching: .images) {
                if let selectedImage = profileVm.eventImage { // if there is a image selceteds display
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:50,height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {// show logo instead
                    Image("Logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50,height: 50)
                }
            }
            .buttonStyle(.plain)
        }.padding(.leading)
        //
    }
    
    
}
