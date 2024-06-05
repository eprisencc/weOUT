//
//  TripsInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 2/4/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import _PhotosUI_SwiftUI

struct TripsInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isStartDatePickerVisible = true
    @State private var isEndDatePickerVisible = true
    
    @State private var trip: TripModel = TripModel()
    
    @EnvironmentObject var profileVm: ProfileViewModel
    @State var pending = false
    
    @EnvironmentObject var myTrips: Trips
    //MARK: ~JW
    
    @State private var allowImage = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if !pending {
                    Color(hex: "1F1F1F")
                        .ignoresSafeArea()
                    
                    VStack {
                        createDestinationHeading
                        createDestinationDetails
                        VStack(alignment: .center) {
                            divider
                            submitButton
                            
                        }
                        
                    }
                } else {
                    ProgressView("Creating Your Trip...")
                        .foregroundStyle(.white)
                        .font(.title)
                }
                
            }
            .onChange(of: trip.endDate) { oldValue, newValue in
                allowImage = true
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
                            //                                showPhotoViewSheet.toggle()
                            
                        }
                        
                        
                        
                    }
                    
                    profileVm.photoPickerItem = nil
                }
                profileVm.didSelectImage = true
            }
            .task{
                try? await  profileVm.loadCurrentUser()
            } //MARK: ~JW
            
        }
        
    }
    
    
    
    
    
    
    
}

#Preview {
    TripsInputSheet()
        .environmentObject(Trips())
        .environmentObject(ProfileViewModel())
    //MARK: ~JW
    
    
}



private extension TripsInputSheet {
    
    //MARK: Views Builders
    var createDestinationHeading: some View {
        HStack {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "x.circle.fill")
            }
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .foregroundStyle(.white)
            .padding(15)
            Spacer()
            
            submitButton
            
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
                
                TextFieldButton(text: $trip.destination ,textFieldExampleMessage: "ex. New York")
                divider
                Spacer()
                
                
                Text("Dates")
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
                divider
                VStack{
                    
                    photoPicker.disabled(!allowImage)
                        .padding()
                }
            }
            
            
        }
    }
    
    var divider: some View {
        Divider()
            .frame(height: 1)
            .overlay(Color(hex: "F5DFA3"))
            .padding()
    }
    
    var photoPicker : some View {
        VStack {
            PhotosPicker(selection: $profileVm.photoPickerItem,matching: .images) {
                if let selectedImage = profileVm.eventImage { // if there is a image selceteds display is
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:350,height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {// show logo instead
                    ZStack{
                        Image("Logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width:350,height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .blur(radius: 4)
                         HStack{// yellow button on top
                            Image(systemName: "photo")
                                .imageScale(.small)
                            Text ("Pick Cover Photo")
                                .font(.headline)
                                .lineLimit(1)
                        }
                        .padding()
                        .frame(height:40) 
                        .frame(width:210)
                        .foregroundColor(.black)
                        .background(.yellow)
                        .cornerRadius(10)
                        .offset(y:-3)
                    }
                    .bold()
                }
            }
            .buttonStyle(.plain)
        }
             
        //
    }
    func isDateSelected() -> Bool {
        if (trip.startDate == Date.now || trip.endDate == Date.now) {
            return true
        }
        else {
            return false
        }
    }
    
    var submitButton : some View {
        VStack {
            if let user = profileVm.currentUser{
                Button("Create") {
                    pending = true
                    Task{
                        let success =   await  profileVm.saveTrip(user: user, trip: trip, photo: profileVm.newPhoto, image:profileVm.eventImage ?? UIImage())
                        if success{
                            pending = false
                            dismiss()
                            
                        }
                    }
                    
                }
                
                .padding(15)
                .font(.title)
                .foregroundStyle(.white)
            }
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
