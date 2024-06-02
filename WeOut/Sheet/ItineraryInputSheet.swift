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
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    var index: Int = -1
    var destination: String = ""
    @State var itinerary: ItineraryModel
    @State var trip: TripModel
    @EnvironmentObject private var profileVm: ProfileViewModel
    @EnvironmentObject private var planVm: PlansViewModel

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
//                                Button(role: .cancel, action: {
//                                    showingImagePicker = true
//                                }) {
//                                    Image(systemName: "plus")
//                                }
//                                .foregroundColor(Color.white)
                            }
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
//                            HStack(alignment: .center) {
//                                itinerary.itineraryImage
//                                    .resizable()
//                                    .scaledToFit()
//                                    .padding(25)
//                                
//                            }
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
                    VStack(alignment: .center) {
                        Button("Submit") {
                            if let user = profileVm.currentUser{
                                Task{
                                    let success =  await profileVm.saveTrip(user: user, trip: trip, photo: Photo(), image: profileVm.eventImage ?? UIImage())
                                    if success {
                                        dismiss()

                                    }
                                    
                                    
                                  }
                            }
                           
                         }
                        .padding(15)
                        
                        .font(.title)
                    }
                }
                .padding()
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
//                                showPhotoViewSheet.toggle()

                  }
           
            
              }
              
profileVm.photoPickerItem = nil
          }
          profileVm.didSelectImage = true
      }

        
//         .sheet(isPresented: $showingImagePicker) {
//            ImagePicker(image: $inputImage)
//        }
//        .onAppear() {
//            itinerary.destination = destination
//        }
        .task {
            try? await profileVm.loadCurrentUser()
        }
    }
 }


#Preview {
    ItineraryInputSheet(itinerary: ItineraryModel(), trip: TripModel())
        .environmentObject(ProfileViewModel())
 }

 

private extension ItineraryInputSheet{
    
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
