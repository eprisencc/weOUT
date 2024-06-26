//
//  DashboardView.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ZStack{
                //Color(hex: "#003459")
                Image("newCloudsBack")
                    .resizable()
                    .ignoresSafeArea(/*edges: .top*/)
//                Image("sandBottom")
//                    .resizable()
//                    .scaledToFit()
                VStack(alignment: .center) {
                    HStack {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .clipShape(Circle())
                        Text("Dashboard")
                            .font(.largeTitle)
                            .foregroundStyle(Color.titleheadings)
                            .bold()
                        Spacer()
                        //Bring up the Trip input sheet
                        Button {
                            
                        }
                    label: {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.titleheadings)
                    .font(.largeTitle)
                    }
                    .padding(25)
                    Spacer()
                    Text("Coming Soon")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
