import SwiftUI

// MARK: - Main App Selector
struct MainAppView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedApp = 0
    
    var body: some View {
        ZStack {
            Group {
                if selectedApp == 0 {
                    SearchView()
                } else if selectedApp == 1 {
                    CameraView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80)
            }
            
            // Custom bottom menu bar
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    // Top border
                    Rectangle()
                        .fill(Color.adaptiveTertiaryText(themeManager.currentTheme.colorScheme ?? .light))
                        .frame(height: 1)
                    
                    // Menu bar background
                    Rectangle()
                        .fill(Color.adaptiveBackground(themeManager.currentTheme.colorScheme ?? .light))
                        .frame(height: 80)
                        .overlay(
                            HStack(spacing: 80) {
                                // Explore Tab
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedApp = 0
                                    }
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: selectedApp == 0 ? "magnifyingglass" : "magnifyingglass")
                                            .font(.system(size: 24))
                                            .foregroundColor(selectedApp == 0 ? Color.adaptiveAccent(themeManager.currentTheme.colorScheme ?? .light) : Color.adaptiveSecondaryText(themeManager.currentTheme.colorScheme ?? .light))
                                        
                                        Text("Explore")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(selectedApp == 0 ? Color.adaptiveAccent(themeManager.currentTheme.colorScheme ?? .light) : Color.adaptiveSecondaryText(themeManager.currentTheme.colorScheme ?? .light))
                                    }
                                    .frame(width: 60, height: 60)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Camera Tab
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedApp = 1
                                    }
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: selectedApp == 1 ? "camera.fill" : "camera")
                                            .font(.system(size: 24))
                                            .foregroundColor(selectedApp == 1 ? Color.adaptiveAccent(themeManager.currentTheme.colorScheme ?? .light) : Color.adaptiveSecondaryText(themeManager.currentTheme.colorScheme ?? .light))
                                        
                                        Text("Camera")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(selectedApp == 1 ? Color.adaptiveAccent(themeManager.currentTheme.colorScheme ?? .light) : Color.adaptiveSecondaryText(themeManager.currentTheme.colorScheme ?? .light))
                                    }
                                    .frame(width: 60, height: 60)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.bottom, 16)
                        )
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}