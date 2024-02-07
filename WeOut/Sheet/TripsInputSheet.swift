//
//  TripsInputSheet.swift
//  WeOut
//
//  Created by Jonathan Loving on 2/4/24.
//

import SwiftUI

struct TripsInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var createTrip: CreateTripVM
    
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State private var startSelectedDate = Date()
    @State private var endSelectedDate = Date()
    @State private var isStartDatePickerVisible = true
    @State private var isEndDatePickerVisible = true

    var index: Int = -1
    let startDate = Date.now
    var formatter1: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "E, MMM d, y"
        return df
    }
    
    var body: some View {
        
        //Text("Hello World!!!")
//        Text(formatter1.string(from: startDate))
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
                            
                            Text("Destination")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)
                            
                            //TextFieldButton(text: $createTrip.destination ,textFieldExampleMessage: "ex. New York")
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
                            Spacer()
                            

                            Text("Dates")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(15)


                            HStack {
                                      CompactDatePickerView(selectedDate: $startSelectedDate)
                                    .background(Color.white)
                                    .frame(width: 150, height: 50)
                                          .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                          .padding()
                              
                                      CompactDatePickerView(selectedDate: $endSelectedDate)
                                    .background(Color.white)
                                          .frame(width: 150, height: 50)
                                          .border(Color.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                          .padding()
                                  }
                              }
                        Divider()
                            .frame(height: 1)
                            .overlay(Color(hex: "F5DFA3"))
                            .padding()
                                
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
                        
                                HStack(alignment: .center) {
                                    
                                    createTrip.TripImage
                                        .resizable()
                                        .scaledToFit()
                                        .padding(25)
                                    
                                }
                          }

                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(hex: "F5DFA3"))
                                .padding()
                    
                    
                    VStack(alignment: .center) {
                        Button("Submit") {
                            //createItinerary.addToItineraryArray()
                            
                            dismiss()
                        }
                        .padding(15)
                        .font(.title)
                    }
                            
                        }
                    }
            
            
                }
                .padding()
            }
        }
        
 

struct CompactDatePickerView: View {
    @Binding var selectedDate: Date

    var body: some View {
        ZStack {
            //Color.black
                //.ignoresSafeArea()
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(CompactDatePickerStyle())
                .background(.date)
        }
    }
}
   
#Preview {
    TripsInputSheet(createTrip: CreateTripVM())
        .environmentObject(CreateTripVM())
}
