import SwiftUI

// MARK: - Jacquemus-Inspired Style Guide

// MARK: - Color System
extension Color {
    
    // MARK: - Primary Colors
    static let primaryBackground = Color("PrimaryBackground")
    static let secondaryBackground = Color("SecondaryBackground")
    static let tertiaryBackground = Color("TertiaryBackground")
    
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")
    static let tertiaryText = Color("TertiaryText")
    
    // MARK: - Accent Colors
    static let accent = Color("Accent")
    static let accentSecondary = Color("AccentSecondary")
    
    // MARK: - System Colors
    static let success = Color("Success")
    static let warning = Color("Warning")
    static let error = Color("Error")
    
    // MARK: - Light Theme Colors
    static let lightTheme = ColorScheme.light
    
    // Primary
    static let lightBackground = Color(red: 0.98, green: 0.98, blue: 0.98) // #FAFAFA
    static let lightSecondaryBackground = Color(red: 0.95, green: 0.95, blue: 0.95) // #F2F2F2
    static let lightTertiaryBackground = Color(red: 0.92, green: 0.92, blue: 0.92) // #EBEBEB
    
    // Text
    static let lightPrimaryText = Color(red: 0.15, green: 0.15, blue: 0.15) // #262626
    static let lightSecondaryText = Color(red: 0.45, green: 0.45, blue: 0.45) // #737373
    static let lightTertiaryText = Color(red: 0.65, green: 0.65, blue: 0.65) // #A6A6A6
    
    // Accent
    static let lightAccent = Color(red: 0.15, green: 0.15, blue: 0.15) // #262626 - Black accent
    static let lightAccentSecondary = Color(red: 0.55, green: 0.45, blue: 0.35) // #8C7356 - Brown accent
    
    // MARK: - Dark Theme Colors
    static let darkTheme = ColorScheme.dark
    
    // Primary
    static let darkBackground = Color(red: 0.08, green: 0.08, blue: 0.08) // #141414
    static let darkSecondaryBackground = Color(red: 0.12, green: 0.12, blue: 0.12) // #1F1F1F
    static let darkTertiaryBackground = Color(red: 0.16, green: 0.16, blue: 0.16) // #292929
    
    // Text
    static let darkPrimaryText = Color(red: 0.95, green: 0.95, blue: 0.95) // #F2F2F2
    static let darkSecondaryText = Color(red: 0.75, green: 0.75, blue: 0.75) // #BFBFBF
    static let darkTertiaryText = Color(red: 0.55, green: 0.55, blue: 0.55) // #8C8C8C
    
    // Accent
    static let darkAccent = Color(red: 0.95, green: 0.95, blue: 0.95) // #F2F2F2 - Light accent
    static let darkAccentSecondary = Color(red: 0.75, green: 0.65, blue: 0.55) // #BFA68C - Warm accent
    
    // MARK: - Adaptive Colors (changes with theme)
    static func adaptiveBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightBackground : darkBackground
    }
    
    static func adaptiveSecondaryBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightSecondaryBackground : darkSecondaryBackground
    }
    
    static func adaptiveTertiaryBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightTertiaryBackground : darkTertiaryBackground
    }
    
    static func adaptivePrimaryText(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightPrimaryText : darkPrimaryText
    }
    
    static func adaptiveSecondaryText(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightSecondaryText : darkSecondaryText
    }
    
    static func adaptiveTertiaryText(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightTertiaryText : darkTertiaryText
    }
    
    static func adaptiveAccent(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightAccent : darkAccent
    }
    
    static func adaptiveAccentSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? lightAccentSecondary : darkAccentSecondary
    }
}

// MARK: - Typography System
extension Font {
    
    // MARK: - Jacquemus Typography Scale
    // Ultra thin, elegant sans-serif inspired by luxury fashion
    
    // Display Fonts - For hero sections and major headlines
    static let displayLarge: Font = .system(size: 40, weight: .ultraLight, design: .default)
    static let displayMedium: Font = .system(size: 36, weight: .ultraLight, design: .default)
    static let displaySmall: Font = .system(size: 32, weight: .thin, design: .default)
    
    // Headlines - For section headers
    static let headlineLarge: Font = .system(size: 24, weight: .thin, design: .default)
    static let headlineMedium: Font = .system(size: 20, weight: .thin, design: .default)
    static let headlineSmall: Font = .system(size: 18, weight: .light, design: .default)
    
    // Titles - For content titles
    static let titleLarge: Font = .system(size: 16, weight: .light, design: .default)
    static let titleMedium: Font = .system(size: 14, weight: .regular, design: .default)
    static let titleSmall: Font = .system(size: 13, weight: .regular, design: .default)
    
    // Body Text
    static let bodyLarge: Font = .system(size: 16, weight: .light, design: .default)
    static let bodyMedium: Font = .system(size: 14, weight: .light, design: .default)
    static let bodySmall: Font = .system(size: 12, weight: .light, design: .default)
    
    // Labels and captions
    static let labelLarge: Font = .system(size: 12, weight: .regular, design: .default)
    static let labelMedium: Font = .system(size: 11, weight: .medium, design: .default)
    static let labelSmall: Font = .system(size: 10, weight: .medium, design: .default)
    
    // MARK: - Specialized Fonts
    static let navigationTitle: Font = .system(size: 18, weight: .light, design: .default)
    static let navigationItem: Font = .system(size: 14, weight: .light, design: .default)
    static let buttonText: Font = .system(size: 14, weight: .regular, design: .default)
    static let priceText: Font = .system(size: 16, weight: .medium, design: .default)
    static let productTitle: Font = .system(size: 14, weight: .light, design: .default)
}

// MARK: - Spacing System
struct Spacing {
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
    static let xxxxl: CGFloat = 48
    
    // Specific use cases
    static let cardPadding: CGFloat = md
    static let screenPadding: CGFloat = lg
    static let sectionSpacing: CGFloat = xxxl
    static let itemSpacing: CGFloat = md
}

// MARK: - Corner Radius System
struct CornerRadius {
    static let none: CGFloat = 0
    static let xs: CGFloat = 2
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let xxl: CGFloat = 20
    
    // Specific use cases
    static let button: CGFloat = none // Jacquemus uses sharp corners
    static let card: CGFloat = xs
    static let input: CGFloat = none
    static let modal: CGFloat = md
}

// MARK: - Shadow System
struct ShadowStyle {
    static let subtle = Color.black.opacity(0.02)
    static let soft = Color.black.opacity(0.05)
    static let medium = Color.black.opacity(0.08)
    static let strong = Color.black.opacity(0.12)
    
    static let subtleRadius: CGFloat = 2
    static let softRadius: CGFloat = 4
    static let mediumRadius: CGFloat = 8
    static let strongRadius: CGFloat = 12
}

// MARK: - Animation System
struct AnimationTiming {
    static let fast: Double = 0.2
    static let medium: Double = 0.3
    static let slow: Double = 0.5
    static let verySlow: Double = 0.8
    
    // Specific animations
    static let buttonPress: Double = fast
    static let cardHover: Double = medium
    static let pageTransition: Double = slow
    static let modalPresent: Double = medium
}

// MARK: - Layout Constants
struct Layout {
    // Grid System
    static let gridColumns: Int = 12
    static let maxContentWidth: CGFloat = 1200
    static let mobileBreakpoint: CGFloat = 768
    static let tabletBreakpoint: CGFloat = 1024
    
    // Component Sizes
    static let buttonHeight: CGFloat = 44
    static let inputHeight: CGFloat = 44
    static let navigationHeight: CGFloat = 60
    static let tabBarHeight: CGFloat = 80
    
    // Card dimensions
    static let productCardAspectRatio: CGFloat = 1.2 // Height/Width
    static let heroCardAspectRatio: CGFloat = 0.6
}

// MARK: - Elevation System (Z-Index)
struct Elevation {
    static let surface: Double = 0
    static let raised: Double = 1
    static let overlay: Double = 2
    static let modal: Double = 3
    static let popover: Double = 4
    static let tooltip: Double = 5
}