//
//  OnboardingView.swift
//  WeOut
//
//  Created by Jonathan Loving on 6/13/24.
//

import SwiftUI

struct OnboardingView: View {
    let title: String
    let image: String
    let description: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .padding()
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(title: "Fun Fact", image: "paperplane.fill", description: "Space travel isn't for the faint-hearted.")
  }
}
