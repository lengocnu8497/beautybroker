import Foundation

enum City: String, CaseIterable {
    case newYork = "New York"
    case losAngeles = "Los Angeles"
    case miami = "Miami"
    case seoul = "Seoul"
    case shanghai = "Shanghai"
}

struct Procedure: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
    let rating: Double
    let doctorName: String
    let clinicName: String
    let city: City
    let imageSystemName: String
}

class ProcedureData {
    static let sampleProcedures: [Procedure] = [
        // New York
        Procedure(name: "Rhinoplasty", description: "Nose reshaping surgery", price: "$8,500", rating: 4.8, doctorName: "Dr. Sarah Johnson", clinicName: "Manhattan Plastic Surgery", city: .newYork, imageSystemName: "face.smiling"),
        Procedure(name: "Breast Augmentation", description: "Breast enhancement surgery", price: "$12,000", rating: 4.9, doctorName: "Dr. Michael Chen", clinicName: "NYC Aesthetic Center", city: .newYork, imageSystemName: "heart.circle"),
        Procedure(name: "Facelift", description: "Facial rejuvenation procedure", price: "$15,000", rating: 4.7, doctorName: "Dr. Emily Rodriguez", clinicName: "Elite Cosmetic Surgery", city: .newYork, imageSystemName: "sparkles"),
        
        // Los Angeles
        Procedure(name: "Brazilian Butt Lift", description: "Buttock enhancement using fat transfer", price: "$9,500", rating: 4.6, doctorName: "Dr. James Wilson", clinicName: "Beverly Hills Beauty", city: .losAngeles, imageSystemName: "figure.walk"),
        Procedure(name: "Liposuction", description: "Fat removal procedure", price: "$6,000", rating: 4.8, doctorName: "Dr. Maria Garcia", clinicName: "Hollywood Aesthetics", city: .losAngeles, imageSystemName: "wand.and.stars"),
        Procedure(name: "Tummy Tuck", description: "Abdominal contouring surgery", price: "$10,000", rating: 4.5, doctorName: "Dr. Robert Kim", clinicName: "West Coast Surgery", city: .losAngeles, imageSystemName: "figure.run"),
        
        // Miami
        Procedure(name: "Mommy Makeover", description: "Combined breast and body procedures", price: "$16,000", rating: 4.9, doctorName: "Dr. Carlos Martinez", clinicName: "Miami Beach Plastic Surgery", city: .miami, imageSystemName: "star.circle"),
        Procedure(name: "Lip Augmentation", description: "Lip enhancement procedure", price: "$2,500", rating: 4.4, doctorName: "Dr. Isabella Lopez", clinicName: "South Beach Aesthetics", city: .miami, imageSystemName: "mouth"),
        Procedure(name: "Blepharoplasty", description: "Eyelid surgery", price: "$5,500", rating: 4.7, doctorName: "Dr. Antonio Silva", clinicName: "Ocean Drive Cosmetics", city: .miami, imageSystemName: "eye"),
        
        // Seoul
        Procedure(name: "Double Eyelid Surgery", description: "Asian eyelid enhancement", price: "$3,000", rating: 4.9, doctorName: "Dr. Kim Min-jun", clinicName: "Gangnam Beauty Clinic", city: .seoul, imageSystemName: "eyes"),
        Procedure(name: "V-Line Surgery", description: "Jaw contouring for V-shaped face", price: "$7,000", rating: 4.8, doctorName: "Dr. Park Su-jin", clinicName: "Seoul Facial Contouring", city: .seoul, imageSystemName: "diamond"),
        Procedure(name: "Nose Thread Lift", description: "Non-surgical nose enhancement", price: "$1,200", rating: 4.6, doctorName: "Dr. Lee Hyun-woo", clinicName: "K-Beauty Medical", city: .seoul, imageSystemName: "arrow.up.circle"),
        
        // Shanghai
        Procedure(name: "Jawline Contouring", description: "Facial bone reshaping", price: "$5,800", rating: 4.7, doctorName: "Dr. Wang Lei", clinicName: "Shanghai International Aesthetics", city: .shanghai, imageSystemName: "square.and.pencil"),
        Procedure(name: "Breast Lift", description: "Breast repositioning surgery", price: "$8,000", rating: 4.6, doctorName: "Dr. Zhang Wei", clinicName: "Pudong Medical Beauty", city: .shanghai, imageSystemName: "arrow.up.heart"),
        Procedure(name: "Cheek Augmentation", description: "Cheek enhancement procedure", price: "$4,200", rating: 4.5, doctorName: "Dr. Li Ming", clinicName: "East China Beauty Center", city: .shanghai, imageSystemName: "face.dashed")
    ]
    
    static func procedures(for city: City) -> [Procedure] {
        return sampleProcedures.filter { $0.city == city }
    }
}