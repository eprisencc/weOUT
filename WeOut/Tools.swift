//
//  Tools.swift
//  WeOut
//
//  Created by Jonathan Loving on 1/26/24.
//

import Foundation
import SwiftUI

/*extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}*/

extension Color {

    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor: uiColor)
    }

    func toHexString(includeAlpha: Bool = false) -> String? {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }

}


//Reference for creating hexidecimal colors > https://ditto.live/blog/swift-hex-color-extension
extension UIColor {
    // Initializes a new UIColor instance from a hex string
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        let scanner = Scanner(string: hexString)

        var rgbValue: UInt64 = 0
        guard scanner.scanHexInt64(&rgbValue) else {
            return nil
        }

        var red, green, blue, alpha: UInt64
        switch hexString.count {
        case 6:
            red = (rgbValue >> 16)
            green = (rgbValue >> 8 & 0xFF)
            blue = (rgbValue & 0xFF)
            alpha = 255
        case 8:
            red = (rgbValue >> 16)
            green = (rgbValue >> 8 & 0xFF)
            blue = (rgbValue & 0xFF)
            alpha = rgbValue >> 24
        default:
            return nil
        }

        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }

    // Returns a hex string representation of the UIColor instance
    func toHexString(includeAlpha: Bool = false) -> String? {
        // Get the red, green, and blue components of the UIColor as floats between 0 and 1
        guard let components = self.cgColor.components else {
            // If the UIColor's color space doesn't support RGB components, return nil
            return nil
        }

        // Convert the red, green, and blue components to integers between 0 and 255
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)

        // Create a hex string with the RGB values and, optionally, the alpha value
        let hexString: String
        if includeAlpha, let alpha = components.last {
            let alphaValue = Int(alpha * 255.0)
            hexString = String(format: "#%02X%02X%02X%02X", red, green, blue, alphaValue)
        } else {
            hexString = String(format: "#%02X%02X%02X", red, green, blue)
        }

        // Return the hex string
        return hexString
    }
}

struct TextFieldClearButton: ViewModifier {
    @Binding var fieldText: String

    func body(content: Content) -> some View {
        content
            .overlay {
                if !fieldText.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            fieldText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(fieldText: text))
    }
}

struct TextFieldButton: View {

    @State var text: String
    var textFieldExampleMessage: String
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .showClearButton($text)
        }
        .padding()
        .background(Color.purple)
    }
}
