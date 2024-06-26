//
//  EditTripsInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 2/12/24.
//
import Foundation
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import PhotosUI
import SwiftUI
import UIKit
import _PhotosUI_SwiftUI


struct EditTripsInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State var trip: TripModel
    @EnvironmentObject var profileVm: ProfileViewModel
    @EnvironmentObject var myTrips: Trips
    @State var pending = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if !pending {
                    Color(hex: "1F1F1F")
                        .ignoresSafeArea()
                    
                    VStack {
                        tripheading
                        tripDetails
                        tripSaveDelete
                    }
                    .padding()
                } else {
                    ProgressView("Editing Your Trip...")
                        .foregroundStyle(.white)
                        .font(.title)
                }
            }
        }
    }
    var tripheading: some View {
        HStack {
            Text("Edit")
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
    var tripDetails: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer()
                Text("Destination?")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(15)
                
                Group {
                    TextFieldButton(text: $trip.destination ,textFieldExampleMessage: "ex. New York")
                }
                
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
                    CompactDatePickerView(selectedDate: $trip.startDate)
                        .background(Color.white)
                        .frame(width: 150, height: 50)
                        .padding()
                        .onChange(of: trip.startDate) {
                            tripEndDateValidation()
                            tripStartDateValidation()
                        }
                    
                    CompactDatePickerView(selectedDate: $trip.endDate)
                        .background(Color.white)
                        .frame(width: 150, height: 50)
                        .padding()
                        .onChange(of: trip.endDate) {
                            tripEndDateValidation()
                            tripStartDateValidation()
                        }
                }
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hex: "F5DFA3"))
                    .padding()
                //                HStack {
                Text("Location Photo (optional)")
                    .foregroundStyle(.white)
                    .font(.title)
                    .padding(15)
                photoPicker
                
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
                    pending = true
                    Task{
                        if let user = profileVm.currentUser {
                            let successs = await profileVm.updateTrip(user: user, trip: trip)
                            
                            if successs{
                                pending = false
                                dismiss()
                            }
                        }
                    }
                }
                .padding(15)
                .font(.title)
                .foregroundStyle(.white)
                
                Button("Delete") {
                    pending = true
                    Task{
                        if let user = profileVm.currentUser {
                            let success = try await profileVm.deleteTrip(userId: user.uid, tripID: trip.id ?? "")
                            if success{
                                pending = false
                                dismiss()
                            }
                        }
                    }
                    
                    
                }
                .alert("Do you want to delete this card?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        myTrips.removeFromTripArray(trip: trip)
                        dismiss()
                    }
                }
                .padding(15)
                .font(.title)
                .foregroundStyle(.white)
            }
        }
    }
    var divider: some View {
        Divider()
            .frame(height: 1)
            .overlay(Color(hex: "F5DFA3"))
            .padding()
    }
    
    
    
    
    
    @ViewBuilder
    func coverPhoto(link: String) -> some View {
        VStack(alignment:.leading){
            let imageURL = URL(string: link) ?? URL(string: "")
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 150)
                    .overlay(Rectangle().foregroundStyle(.black).background(.black).opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                
            } placeholder: {
                ProgressView()
                    .frame(width: 350, height: 150)
            }
        }
        
    }
    
    
    var photoPicker : some View {
        VStack{
            PhotosPicker(selection: $profileVm.photoPickerItem,matching: .images) {
                if let selectedImage = profileVm.eventImage { // if there is a image selceteds display
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:350,height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {// show logo instead
                    Text("Empty")
                    coverPhoto(link: trip.coverPhoto ?? "")
                }
            }
            .buttonStyle(.plain)
        }.padding(.leading)
            .onChange(of: profileVm.photoPickerItem){
                _,_ in
                Task {
                    if let _ = profileVm.photoPickerItem,
                       let data = try? await profileVm.photoPickerItem?.loadTransferable(type: Data.self){
                        
                        if let image = UIImage(data: data){
                            profileVm.eventImage = image
                            print("📸Succcesffullly selected image")
                            
                            profileVm.newPhoto = Photo()
                            profileVm.photoPickerItem = nil
                            
                        }
                        
                        
                    }
                    
                }
                profileVm.didSelectImage = true
            }
    }
    
    private func tripEndDateValidation() {
        if trip.endDate < trip.startDate {
            trip.endDate = trip.startDate
        }
    }
    
    private func tripStartDateValidation() {
        if trip.startDate < Date.now {
            trip.startDate = Date.now
        }
    }
    
}

#Preview {
    EditTripsInputSheet(trip: TripModel())
        .environmentObject(ProfileViewModel())
}
