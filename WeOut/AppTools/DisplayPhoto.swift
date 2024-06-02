//
//  DisplayPhoto.swift
//  WeOut
//
//  Created by Jacquese Whitson on 5/30/24.
//

import SwiftUI

struct DisplayPhoto: View {
    @Binding var link: String
    @State private var imageURL: URL? = nil

    var height: CGFloat = 200
    var width: CGFloat = 400

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: width, height: height)
            }
        }
        .onAppear {
            imageURL = URL(string: link)
        }
        .onChange(of: link) { oldLink, newLink in
            imageURL = URL(string: newLink)
        }
    }
}

/*#Preview {
    DisplayPhoto(link: "")
}*/

 
