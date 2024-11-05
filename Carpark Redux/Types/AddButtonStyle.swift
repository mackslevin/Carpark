import SwiftUI

struct AddButtonStyle: ButtonStyle {
    @AppStorage(StorageKeys.customAccentColor.rawValue) var customAccentColor: CustomAccentColor = .indigo
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0) // Shrink slightly when pressed
            .foregroundStyle(configuration.isPressed ? Color.gray : Utility.color(forCustomAccentColor: customAccentColor))
    }
}
