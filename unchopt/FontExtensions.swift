import SwiftUI

// MARK: - Legacy Font Extensions (For Backward Compatibility)
extension Font {
    static let thinTitle: Font = .system(size: 28, weight: .thin, design: .default)
    static let thinTitle2: Font = .system(size: 22, weight: .thin, design: .default)
    static let thinTitle3: Font = .system(size: 20, weight: .thin, design: .default)
    static let thinHeadline: Font = .system(size: 17, weight: .thin, design: .default)
    static let thinSubheadline: Font = .system(size: 15, weight: .thin, design: .default)
    static let thinBody: Font = .system(size: 17, weight: .thin, design: .default)
    static let thinCallout: Font = .system(size: 16, weight: .thin, design: .default)
    static let thinFootnote: Font = .system(size: 13, weight: .thin, design: .default)
    static let thinCaption: Font = .system(size: 12, weight: .thin, design: .default)
    static let thinCaption2: Font = .system(size: 11, weight: .thin, design: .default)
    
    // Medium weights for emphasis
    static let thinMediumTitle: Font = .system(size: 28, weight: .medium, design: .default)
    static let thinMediumTitle2: Font = .system(size: 22, weight: .medium, design: .default)
    static let thinMediumHeadline: Font = .system(size: 17, weight: .medium, design: .default)
    static let thinMediumSubheadline: Font = .system(size: 15, weight: .medium, design: .default)
}

// Note: New comprehensive typography system is available in StyleGuide.swift
// Use Font.displayLarge, Font.headlineMedium, Font.bodyLarge, etc. for new components