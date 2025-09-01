import SwiftUI

struct CitySelectionView: View {
    @Binding var selectedCity: City?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Menu {
            ForEach(City.allCases, id: \.self) { city in
                Button(action: {
                    selectedCity = city
                }) {
                    HStack {
                        Text(city.rawValue)
                        if selectedCity == city {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedCity?.rawValue ?? "Select City")
                    .font(.bodyMedium)
                    .foregroundColor(selectedCity == nil ? Color.adaptiveSecondaryText(colorScheme) : Color.adaptivePrimaryText(colorScheme))
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                    .font(.body)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.adaptiveSecondaryBackground(colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.adaptiveTertiaryText(colorScheme), lineWidth: 1)
            )
        }
    }
}