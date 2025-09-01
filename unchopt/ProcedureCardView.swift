import SwiftUI

struct ProcedureCardView: View {
    let procedure: Procedure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Photo collage card
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemGray5))
                .frame(height: 200)
                .overlay(
                    BeforeAfterPhotoCollage(procedure: procedure)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Information below card
            VStack(alignment: .leading, spacing: 8) {
                // First line: Procedure name from Dr. Name
                Text("\(procedure.name) from \(procedure.doctorName)")
                    .font(.custom("HelveticaNeue", size: 16))
                    .lineLimit(1)
                
                // Second line: Price and Rating
                HStack {
                    Text("Estimated $ \(procedure.price)")
                        .font(.custom("HelveticaNeue-Medium", size: 14))
                        .foregroundColor(Color.gray.opacity(0.55))
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", procedure.rating))
                            .font(.custom("HelveticaNeue-Medium", size: 12))
                            .foregroundColor(Color.gray.opacity(0.7))
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct BeforeAfterPhotoCollage: View {
    let procedure: Procedure
    
    // Sample before/after image system names based on procedure
    private var beforeImageName: String {
        switch procedure.name {
        case "Rhinoplasty": return "face.dashed"
        case "Breast Augmentation": return "heart"
        case "Facelift": return "face.smiling"
        case "Liposuction": return "figure.walk"
        case "Brazilian Butt Lift": return "figure.stand"
        case "Tummy Tuck": return "figure.run"
        case "Mommy Makeover": return "star"
        case "Lip Augmentation": return "mouth"
        case "Blepharoplasty": return "eye"
        case "Double Eyelid Surgery": return "eyes"
        case "V-Line Surgery": return "diamond"
        case "Nose Thread Lift": return "arrow.up.circle"
        case "Jawline Contouring": return "square.and.pencil"
        case "Breast Lift": return "arrow.up.heart"
        case "Cheek Augmentation": return "face.dashed"
        default: return "photo"
        }
    }
    
    private var afterImageName: String {
        switch procedure.name {
        case "Rhinoplasty": return "face.smiling.fill"
        case "Breast Augmentation": return "heart.fill"
        case "Facelift": return "face.smiling.fill"
        case "Liposuction": return "figure.walk.circle.fill"
        case "Brazilian Butt Lift": return "figure.stand.line.dotted.figure.stand"
        case "Tummy Tuck": return "figure.run.circle.fill"
        case "Mommy Makeover": return "star.fill"
        case "Lip Augmentation": return "mouth.fill"
        case "Blepharoplasty": return "eye.fill"
        case "Double Eyelid Surgery": return "eyes.inverse"
        case "V-Line Surgery": return "diamond.fill"
        case "Nose Thread Lift": return "arrow.up.circle.fill"
        case "Jawline Contouring": return "square.fill"
        case "Breast Lift": return "arrow.up.heart.fill"
        case "Cheek Augmentation": return "face.smiling.fill"
        default: return "photo.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Before photo (left half)
            VStack {
                Spacer()
                Image(systemName: beforeImageName)
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                Text("BEFORE")
                    .font(.thinCaption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            
            // Divider line
            Rectangle()
                .fill(Color.white)
                .frame(width: 2)
            
            // After photo (right half)
            VStack {
                Spacer()
                Image(systemName: afterImageName)
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                Text("AFTER")
                    .font(.thinCaption)
                    .foregroundColor(.green)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.1))
        }
    }
}