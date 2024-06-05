//
//  ItineararyInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/30/24.
//

import SwiftUI
import PhotosUI
import Foundation
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import PhotosUI
import UIKit
import _PhotosUI_SwiftUI

//Sheet that displays the input for the itinerary
struct EditItineraryInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State var itineraryItem: ItineraryModel
    @State var trip: TripModel
    @EnvironmentObject var profileVm : ProfileViewModel
    @EnvironmentObject var planVm : PlansViewModel
    
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
    }
    
    
    
    
    
}




#Preview {
    EditItineraryInputSheet(itineraryItem: ItineraryModel(), trip: TripModel())
        .environmentObject(ProfileViewModel())
        .environmentObject(PlansViewModel())
    
}



private extension EditItineraryInputSheet{
    
    
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
                    
                    photoPicker
                    
                }
                
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hex: "F5DFA3"))
                    .padding()
                HStack(alignment: .bottom) {
                    
                    //                    itineraryItem.itineraryImage
                    //                        .resizable()
                    //                        .scaledToFit()
                    //                        .padding(25)
                    
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
    
    // new code
    var itinerarySaveDelete: some View {
        VStack(alignment: .center) {
            HStack {
                Button("Save") {
                    Task{
                        if let user = profileVm.currentUser{
                            let success =  await planVm.updateItinerary(user: user, trip: trip, plan: itineraryItem,  image: profileVm.eventImage ?? UIImage())
                            if success{
                                dismiss()
                            }
                        }
                    }
                    
                }
                .padding(15)
                Button("Delete") {
                    //
                    showingDeleteAlert = true
                }
                .alert("Do you want to delete this card?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        Task{
                            if let user = profileVm.currentUser{
                                let success =  try await planVm.deletePlan(userId: user.uid, tripID: trip.id ?? "", plan: profileVm.editItineraryItem ?? ItineraryModel())
                                if success{
                                    dismiss()
                                    
                                }
                                
                                
                            }
                            
                        }
                        //trip.removeItineraryItem(itineraryItem: itineraryItem)
                    }
                }
                .padding(15)

            }
            .padding(15)
            .font(.title)
            
            //.padding(15)
            //.font(.title)
        }
    }
    
    
    // new code
    @ViewBuilder
    func thumbNail(link: String) -> some View {
        VStack(alignment:.leading){
            let imageURL = URL(string: link) ?? URL(string: "")
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .overlay(Rectangle().foregroundStyle(.black).background(.black).opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
        }
        
    }
    
    var photoPicker : some View {
        VStack{
            PhotosPicker(selection: $planVm.photoPickerItem,matching: .images) {
                if let selectedImage = planVm.planImage { // if there is a image selceteds display
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .overlay(Rectangle().foregroundStyle(.black).background(.black).opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {// show logo instead
                    thumbNail(link:itineraryItem.itineraryImage )
                }
            }
            .buttonStyle(.plain)
        }.padding(.leading)
            .onChange(of: planVm.photoPickerItem){
                _,_ in
                Task {
                    if let _ = planVm.photoPickerItem,
                       let data = try? await planVm.photoPickerItem?.loadTransferable(type: Data.self){
                        
                        if let image = UIImage(data: data){
                            planVm.planImage = image
                            print("📸Succcesffullly selected image")
                            planVm.photoPickerItem = nil
                        }
                        
                        
                    }
                    
                }
                profileVm.didSelectImage = true
            }
        
        
        //
    }
    
    
    
    
}





