import SwiftUI

struct PricingBreakdownTabView: View {
    let procedure: Procedure
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Total Price Header
                PricingSectionCard(title: "Total Estimated Cost", icon: "dollarsign.circle") {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Total Package")
                                .font(.thinMediumTitle2)
                            
                            Spacer()
                            
                            Text(procedure.price)
                                .font(.thinMediumTitle)
                                .foregroundColor(.green)
                        }
                        
                        Text("*Final cost may vary based on individual consultation and specific requirements")
                            .font(.thinCaption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                
                // Detailed Breakdown
                PricingSectionCard(title: "Cost Breakdown", icon: "list.bullet.clipboard") {
                    VStack(spacing: 0) {
                        ForEach(Array(getPricingBreakdown(for: procedure).enumerated()), id: \.offset) { index, item in
                            PricingItemRow(title: item.title, price: item.price, description: item.description)
                            
                            if index < getPricingBreakdown(for: procedure).count - 1 {
                                Divider()
                                    .padding(.vertical, 8)
                            }
                        }
                    }
                }
                
                // Payment Options
                PricingSectionCard(title: "Payment Options", icon: "creditcard") {
                    VStack(alignment: .leading, spacing: 16) {
                        PaymentOptionRow(
                            title: "Full Payment",
                            description: "Pay entire amount upfront",
                            benefit: "5% discount applied",
                            price: getDiscountedPrice(for: procedure.price)
                        )
                        
                        Divider()
                        
                        PaymentOptionRow(
                            title: "Monthly Financing",
                            description: "0% APR for qualified applicants",
                            benefit: "As low as $\(getMonthlyPayment(for: procedure.price))/month",
                            price: procedure.price
                        )
                        
                        Divider()
                        
                        PaymentOptionRow(
                            title: "Consultation Package",
                            description: "Initial consultation + planning",
                            benefit: "Applied toward procedure cost",
                            price: "$200"
                        )
                    }
                }
                
                // Insurance & Additional Info
                PricingSectionCard(title: "Important Information", icon: "info.circle") {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoBulletPoint(
                            icon: "exclamationmark.triangle",
                            text: "Most cosmetic procedures are not covered by insurance",
                            color: .orange
                        )
                        
                        InfoBulletPoint(
                            icon: "checkmark.circle",
                            text: "HSA/FSA funds may be eligible for certain procedures",
                            color: .green
                        )
                        
                        InfoBulletPoint(
                            icon: "calendar",
                            text: "Prices subject to change - valid for 30 days from quote",
                            color: .blue
                        )
                        
                        InfoBulletPoint(
                            icon: "person.2",
                            text: "Group packages available for multiple procedures",
                            color: .purple
                        )
                    }
                }
                
                // CTA Button
                Button(action: {
                    // Action for booking consultation
                }) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("Book Free Consultation")
                            .font(.thinMediumSubheadline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func getPricingBreakdown(for procedure: Procedure) -> [PricingItem] {
        let basePrice = getNumericPrice(from: procedure.price)
        
        switch procedure.name {
        case "Rhinoplasty":
            return [
                PricingItem(title: "Surgeon Fee", price: "$\(Int(basePrice * 0.6))", description: "Professional surgical services"),
                PricingItem(title: "Anesthesia", price: "$\(Int(basePrice * 0.15))", description: "Licensed anesthesiologist"),
                PricingItem(title: "Facility Fee", price: "$\(Int(basePrice * 0.15))", description: "Operating room and equipment"),
                PricingItem(title: "Post-Op Care", price: "$\(Int(basePrice * 0.1))", description: "Follow-up visits and materials")
            ]
        case "Breast Augmentation":
            return [
                PricingItem(title: "Surgeon Fee", price: "$\(Int(basePrice * 0.5))", description: "Professional surgical services"),
                PricingItem(title: "Implants", price: "$\(Int(basePrice * 0.25))", description: "Premium silicone implants"),
                PricingItem(title: "Anesthesia", price: "$\(Int(basePrice * 0.12))", description: "Licensed anesthesiologist"),
                PricingItem(title: "Facility Fee", price: "$\(Int(basePrice * 0.13))", description: "Operating room and equipment")
            ]
        default:
            return [
                PricingItem(title: "Surgeon Fee", price: "$\(Int(basePrice * 0.65))", description: "Professional surgical services"),
                PricingItem(title: "Anesthesia", price: "$\(Int(basePrice * 0.15))", description: "Licensed anesthesiologist"),
                PricingItem(title: "Facility Fee", price: "$\(Int(basePrice * 0.15))", description: "Operating room and equipment"),
                PricingItem(title: "Aftercare", price: "$\(Int(basePrice * 0.05))", description: "Post-procedure support")
            ]
        }
    }
    
    private func getNumericPrice(from priceString: String) -> Double {
        let cleanPrice = priceString.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        return Double(cleanPrice) ?? 8500.0
    }
    
    private func getDiscountedPrice(for priceString: String) -> String {
        let basePrice = getNumericPrice(from: priceString)
        let discountedPrice = basePrice * 0.95
        return "$\(Int(discountedPrice))"
    }
    
    private func getMonthlyPayment(for priceString: String) -> String {
        let basePrice = getNumericPrice(from: priceString)
        let monthlyPayment = basePrice / 24 // 24 months
        return "\(Int(monthlyPayment))"
    }
}

struct PricingItem {
    let title: String
    let price: String
    let description: String
}

struct PricingSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.green)
                
                Text(title)
                    .font(.thinMediumHeadline)
                
                Spacer()
            }
            
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}

struct PricingItemRow: View {
    let title: String
    let price: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.thinMediumSubheadline)
                
                Spacer()
                
                Text(price)
                    .font(.thinMediumSubheadline)
                    .foregroundColor(.green)
            }
            
            Text(description)
                .font(.thinCaption)
                .foregroundColor(.secondary)
        }
    }
}

struct PaymentOptionRow: View {
    let title: String
    let description: String
    let benefit: String
    let price: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.thinMediumSubheadline)
                
                Spacer()
                
                Text(price)
                    .font(.thinMediumSubheadline)
                    .foregroundColor(.blue)
            }
            
            Text(description)
                .font(.thinCaption)
                .foregroundColor(.secondary)
            
            Text(benefit)
                .font(.thinCaption)
                .foregroundColor(.green)
        }
    }
}

struct InfoBulletPoint: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
                .padding(.top, 2)
            
            Text(text)
                .font(.thinCaption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}