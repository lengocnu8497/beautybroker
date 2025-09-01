import SwiftUI

// MARK: - Theme Management System

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .system
    @Published var accentColor: Color = .lightAccent
    
    enum AppTheme: CaseIterable {
        case light
        case dark
        case system
        
        var displayName: String {
            switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .system: return "System"
            }
        }
        
        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            case .system: return nil
            }
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
    
    init() {
        if let savedTheme = UserDefaults.standard.object(forKey: "selectedTheme") as? String,
           let theme = AppTheme(rawValue: savedTheme) {
            currentTheme = theme
        }
    }
}

// MARK: - Theme Extension for AppTheme
extension ThemeManager.AppTheme: RawRepresentable {
    var rawValue: String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        case .system: return "system"
        }
    }
    
    init?(rawValue: String) {
        switch rawValue {
        case "light": self = .light
        case "dark": self = .dark
        case "system": self = .system
        default: return nil
        }
    }
}

// MARK: - Theme Environment
struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue = ThemeManager()
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Theme Modifier
struct ThemedView: ViewModifier {
    @StateObject private var themeManager = ThemeManager()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(themeManager)
            .environment(\.themeManager, themeManager)
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

extension View {
    func withTheme() -> some View {
        self.modifier(ThemedView())
    }
}

// MARK: - Customized-Specific Components

// MARK: - Navigation Menu (Inspired by sidebar)
struct CustomizedSidebarMenu: View {
    @State private var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    
    private let menuItems = [
        MenuItem(title: "New In - Women", hasSubmenu: true, items: [
            "Fall Winter 25 - New In",
            "Summer Resort",
            "In-Store Exclusive",
            "Gifts",
            "Les Classiques"
        ]),
        MenuItem(title: "Bags", hasSubmenu: true, items: [
            "View all",
            "New In",
            "Must-Have Handbags",
            "Baskets & Raffia",
            "Crossbody & Handbags",
            "Shoulder bags",
            "Mini",
            "The Bambinos",
            "The Ronds Carrés"
        ]),
        MenuItem(title: "Ready-to-wear", hasSubmenu: true, items: []),
        MenuItem(title: "Accessories & Shoes", hasSubmenu: true, items: []),
        MenuItem(title: "Objects", hasSubmenu: false, items: []),
        MenuItem(title: "Kids", hasSubmenu: true, items: []),
        MenuItem(title: "\"La Croisière\" - Sales", hasSubmenu: false, items: [])
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menuItems) { item in
                if item.hasSubmenu && !item.items.isEmpty {
                    CustomizedExpandableNavItem(title: item.title, items: item.items)
                } else {
                    Button(action: {}) {
                        HStack {
                            Text(item.title)
                                .font(.navigationItem)
                                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                            Spacer()
                        }
                        .padding(.vertical, Spacing.xs)
                    }
                }
                
                CustomizedDivider()
                    .padding(.vertical, Spacing.xxs)
            }
        }
        .padding(.horizontal, Spacing.screenPadding)
        .background(Color.adaptiveBackground(colorScheme))
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let hasSubmenu: Bool
    let items: [String]
}

// MARK: - Product Collection View
struct CustomizedProductCollection: View {
    let title: String
    let products: [ProductItem]
    let columns: Int
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            CustomizedSectionHeader(
                title: title,
                showViewAll: true,
                onViewAll: {}
            )
            
            CustomizedGrid(items: products, columns: columns, spacing: Spacing.md) { product in
                CustomizedProductCard(
                    imageName: product.imageName,
                    title: product.title,
                    isNew: product.isNew,
                    onTap: {}
                )
            }
            .padding(.horizontal, Spacing.screenPadding)
        }
    }
}

struct ProductItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let isNew: Bool
}

// MARK: - Newsletter Subscription (From footer)
struct CustomizedNewsletterSubscription: View {
    @State private var email = ""
    @State private var isSubscribed = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Subscribe to the newsletter")
                    .font(.headlineSmall)
                    .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                
                Text("Subscribe to receive all the information by email on our latest collections, our products, our fashion shows and our projects.")
                    .font(.bodySmall)
                    .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                    .lineSpacing(2)
            }
            
            VStack(alignment: .leading, spacing: Spacing.md) {
                CustomizedTextField(placeholder: "Email", text: $email)
                
                Text("I'd like to sign up to the newsletter. My email won't be shared with third parties.")
                    .font(.labelSmall)
                    .foregroundColor(Color.adaptiveTertiaryText(colorScheme))
                
                CustomizedButton(
                    title: "Subscribe",
                    style: .primary,
                    action: {
                        isSubscribed = true
                    }
                )
            }
        }
        .padding(Spacing.screenPadding)
        .background(Color.adaptiveSecondaryBackground(colorScheme))
    }
}

// MARK: - Footer Links Section
struct CustomizedFooterSection: View {
    let title: String
    let links: [String]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(title)
                .font(.titleMedium)
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(links, id: \.self) { link in
                    Button(action: {}) {
                        Text(link)
                            .font(.bodySmall)
                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
    }
}

// MARK: - Shopping Cart Badge
struct CustomizedShoppingCartButton: View {
    let itemCount: Int
    let onTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "bag")
                    .font(.navigationItem)
                    .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                
                Text("Shopping cart")
                    .font(.navigationItem)
                    .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                
                if itemCount > 0 {
                    Circle()
                        .fill(Color.adaptiveAccent(colorScheme))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

// MARK: - Hero Banner Component
struct CustomizedHeroBanner: View {
    let title: String
    let subtitle: String?
    let backgroundImageName: String?
    let onAction: (() -> Void)?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Rectangle()
                    .fill(Color.adaptiveTertiaryBackground(colorScheme))
                    .aspectRatio(1/Layout.heroCardAspectRatio, contentMode: .fit)
                
                // Content
                VStack(spacing: Spacing.lg) {
                    Spacer()
                    
                    VStack(spacing: Spacing.sm) {
                        Text(title)
                            .font(.displayMedium)
                            .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                            .multilineTextAlignment(.center)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.bodyLarge)
                                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    if onAction != nil {
                        CustomizedButton(
                            title: "Explore Collection",
                            style: .outline,
                            action: { onAction?() }
                        )
                        .frame(maxWidth: 200)
                    }
                    
                    Spacer()
                }
                .padding(Spacing.screenPadding)
            }
        }
        .aspectRatio(1/Layout.heroCardAspectRatio, contentMode: .fit)
    }
}
