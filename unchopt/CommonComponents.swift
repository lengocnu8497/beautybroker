import SwiftUI

// MARK: - Common UI Components with Customized Design System

// MARK: - Navigation Components
struct CustomizedNavigationBar: View {
    let title: String
    let showBackButton: Bool
    let onBack: (() -> Void)?
    
    @Environment(\.colorScheme) var colorScheme
    
    init(title: String, showBackButton: Bool = false, onBack: (() -> Void)? = nil) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBack = onBack
    }
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: { onBack?() }) {
                    Image(systemName: "chevron.left")
                        .font(.navigationItem)
                        .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                }
            }
            
            Spacer()
            
            Text(title)
                .font(.navigationTitle)
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            Spacer()
            
            if showBackButton {
                // Invisible spacer to center title
                Image(systemName: "chevron.left")
                    .font(.navigationItem)
                    .opacity(0)
            }
        }
        .padding(.horizontal, Spacing.screenPadding)
        .frame(height: Layout.navigationHeight)
        .background(Color.adaptiveBackground(colorScheme))
    }
}

struct CustomizedExpandableNavItem: View {
    let title: String
    let items: [String]
    @State private var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Button(action: {
                withAnimation(.easeInOut(duration: AnimationTiming.medium)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.navigationItem)
                        .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    ForEach(items, id: \.self) { item in
                        Button(action: {}) {
                            Text(item)
                                .font(.bodySmall)
                                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                .padding(.leading, Spacing.md)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Button Components
struct CustomizedButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case ghost
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.buttonText)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: Layout.buttonHeight)
                .background(backgroundColor)
                .overlay(
                    Rectangle()
                        .stroke(borderColor, lineWidth: borderWidth)
                )
        }
        .buttonStyle(PressedButtonStyle())
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return colorScheme == .light ? .white : Color.lightPrimaryText
        case .secondary:
            return Color.adaptivePrimaryText(colorScheme)
        case .outline:
            return Color.adaptivePrimaryText(colorScheme)
        case .ghost:
            return Color.adaptiveSecondaryText(colorScheme)
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return Color.adaptiveAccent(colorScheme)
        case .secondary:
            return Color.adaptiveSecondaryBackground(colorScheme)
        case .outline, .ghost:
            return .clear
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary, .secondary:
            return .clear
        case .outline:
            return Color.adaptivePrimaryText(colorScheme)
        case .ghost:
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline:
            return 1
        default:
            return 0
        }
    }
}

struct PressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: AnimationTiming.buttonPress), value: configuration.isPressed)
    }
}

// MARK: - Card Components
struct CustomizedProductCard: View {
    let imageName: String
    let title: String
    let isNew: Bool
    let onTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                // Product Image
                Rectangle()
                    .fill(Color.adaptiveTertiaryBackground(colorScheme))
                    .aspectRatio(1/Layout.productCardAspectRatio, contentMode: .fit)
                    .overlay(
                        // Placeholder for actual image
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                    )
                
                // Product Info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    HStack {
                        Text(title)
                            .font(.productTitle)
                            .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if isNew {
                            Text("NEW")
                                .font(.labelSmall)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeOut(duration: AnimationTiming.cardHover), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct CustomizedInfoCard: View {
    let title: String
    let content: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(title)
                .font(.titleLarge)
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            Text(content)
                .font(.bodyMedium)
                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                .lineSpacing(4)
        }
        .padding(Spacing.cardPadding)
        .background(Color.adaptiveSecondaryBackground(colorScheme))
        .cornerRadius(CornerRadius.card)
    }
}

// MARK: - Input Components
struct CustomizedTextField: View {
    let placeholder: String
    @Binding var text: String
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            TextField(placeholder, text: $text)
                .font(.bodyMedium)
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                .focused($isFocused)
            
            Rectangle()
                .fill(isFocused ? Color.adaptivePrimaryText(colorScheme) : Color.adaptiveTertiaryText(colorScheme))
                .frame(height: 1)
                .animation(.easeInOut(duration: AnimationTiming.fast), value: isFocused)
        }
        .padding(.vertical, Spacing.sm)
    }
}

// MARK: - Layout Components
struct CustomizedGrid<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let columns: Int
    let spacing: CGFloat
    let content: (Item) -> Content
    
    private var gridItems: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
    }
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: spacing) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
}

struct CustomizedSectionHeader: View {
    let title: String
    let showViewAll: Bool
    let onViewAll: (() -> Void)?
    
    @Environment(\.colorScheme) var colorScheme
    
    init(title: String, showViewAll: Bool = false, onViewAll: (() -> Void)? = nil) {
        self.title = title
        self.showViewAll = showViewAll
        self.onViewAll = onViewAll
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headlineMedium)
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            Spacer()
            
            if showViewAll {
                Button(action: { onViewAll?() }) {
                    Text("View all")
                        .font(.bodySmall)
                        .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                        .underline()
                }
            }
        }
        .padding(.horizontal, Spacing.screenPadding)
    }
}

// MARK: - Utility Components
struct CustomizedDivider: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Rectangle()
            .fill(Color.adaptiveTertiaryBackground(colorScheme))
            .frame(height: 1)
    }
}

struct CustomizedTag: View {
    let text: String
    let style: TagStyle
    
    @Environment(\.colorScheme) var colorScheme
    
    enum TagStyle {
        case new
        case sale
        case category
    }
    
    var body: some View {
        Text(text)
            .font(.labelMedium)
            .foregroundColor(textColor)
            .padding(.horizontal, Spacing.xs)
            .padding(.vertical, Spacing.xxs)
            .background(backgroundColor)
            .cornerRadius(CornerRadius.xs)
    }
    
    private var textColor: Color {
        switch style {
        case .new:
            return .red
        case .sale:
            return .green
        case .category:
            return Color.adaptiveSecondaryText(colorScheme)
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .new:
            return .red.opacity(0.1)
        case .sale:
            return .green.opacity(0.1)
        case .category:
            return Color.adaptiveTertiaryBackground(colorScheme)
        }
    }
}

// MARK: - Date Components
struct CustomDateSelector: View {
    @Binding var selectedDate: Date
    let colorScheme: ColorScheme
    @State private var showingDatePicker = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        Button(action: {
            showingDatePicker = true
        }) {
            HStack {
                Text(dateFormatter.string(from: selectedDate))
                    .font(.bodyMedium)
                    .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                
                Spacer()
                
                Image(systemName: "calendar")
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
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDatePicker) {
            DatePickerModal(selectedDate: $selectedDate, isPresented: $showingDatePicker)
        }
    }
}

struct DatePickerModal: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: Spacing.lg) {
                Text("Select Date")
                    .font(.headlineMedium)
                    .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                    .padding(.top, Spacing.lg)
                
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                
                Spacer()
                
                VStack(spacing: Spacing.md) {
                    CustomizedButton(
                        title: "Done",
                        style: .primary,
                        action: {
                            isPresented = false
                        }
                    )
                    
                    CustomizedButton(
                        title: "Cancel",
                        style: .outline,
                        action: {
                            isPresented = false
                        }
                    )
                }
                .padding(.horizontal, Spacing.screenPadding)
            }
            .background(Color.adaptiveBackground(colorScheme))
            .navigationBarHidden(true)
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Loading States
struct CustomizedLoadingView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Circle()
                .stroke(Color.adaptiveTertiaryText(colorScheme), lineWidth: 2)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .trim(from: 0, to: 0.3)
                        .stroke(Color.adaptivePrimaryText(colorScheme), lineWidth: 2)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                )
            
            Text("Loading...")
                .font(.bodySmall)
                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
        }
        .onAppear {
            isAnimating = true
        }
    }
}