import SwiftUI

struct SearchView: View {
    @State private var selectedCity: City? = nil
    @State private var procedures: [Procedure] = []
    @State private var searchText: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 16) {
                    // Search bar at the top with enhanced styling
                    HStack {
                        TextField("Search procedures...", text: $searchText)
                            .font(.bodyMedium)
                            .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                            .onChange(of: searchText) { _ in
                                updateProcedures()
                            }
                        
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
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
                    
                    CitySelectionView(selectedCity: $selectedCity)
                        .onChange(of: selectedCity) { city in
                            updateProcedures()
                        }
                    
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if procedures.isEmpty && selectedCity != nil {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No procedures found")
                            .font(.headlineMedium)
                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                            .multilineTextAlignment(.center)
                        
                        Text("Try searching in a different city")
                            .font(.bodySmall)
                            .foregroundColor(Color.adaptiveTertiaryText(colorScheme))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                } else if procedures.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Select a procedure to get started")
                            .font(.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                            .multilineTextAlignment(.center)
                        
                        Text("Embrace your rebirth, own your beauty.")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(procedures) { procedure in
                                NavigationLink(destination: ProcedureDetailView(procedure: procedure)) {
                                    ProcedureCardView(procedure: procedure)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(
                ZStack {
                    // Gradient background inspired by Mediterranean aesthetics
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.85, blue: 0.8),
                            Color(red: 0.85, green: 0.75, blue: 0.7),
                            Color(red: 0.8, green: 0.7, blue: 0.65)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea(.all)
                    
                    // Overlay for content readability
                    Color.adaptiveBackground(colorScheme).opacity(0.75)
                        .ignoresSafeArea(.all)
                }
            )
        }
    }
    
    private func updateProcedures() {
        guard let city = selectedCity else {
            procedures = []
            return
        }
        
        var filteredProcedures = ProcedureData.procedures(for: city)
        
        if !searchText.isEmpty {
            filteredProcedures = filteredProcedures.filter { procedure in
                procedure.name.localizedCaseInsensitiveContains(searchText) ||
                procedure.description.localizedCaseInsensitiveContains(searchText) ||
                procedure.doctorName.localizedCaseInsensitiveContains(searchText) ||
                procedure.clinicName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        procedures = filteredProcedures
    }
}