import SwiftUI

struct ProcedureInfoTabView: View {
    let procedure: Procedure
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Overview Section
                InfoSectionCard(title: "Overview", icon: "doc.text") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(procedure.description)
                            .font(.thinBody)
                        
                        Text(getProcedureOverview(for: procedure.name))
                            .font(.thinSubheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Duration & Recovery
                InfoSectionCard(title: "Duration & Recovery", icon: "clock") {
                    VStack(spacing: 12) {
                        InfoRow(title: "Procedure Duration", value: getProcedureDuration(for: procedure.name))
                        Divider()
                        InfoRow(title: "Recovery Time", value: getRecoveryTime(for: procedure.name))
                        Divider()
                        InfoRow(title: "Return to Work", value: getReturnToWork(for: procedure.name))
                    }
                }
                
                // Risks & Considerations
                InfoSectionCard(title: "Risks & Considerations", icon: "exclamationmark.triangle") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(getRisks(for: procedure.name), id: \.self) { risk in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "circle.fill")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                                    .padding(.top, 6)
                                
                                Text(risk)
                                    .font(.thinSubheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                        }
                    }
                }
                
                // Before/After Care
                InfoSectionCard(title: "Pre & Post Care Instructions", icon: "heart.text.square") {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Before Procedure:")
                                .font(.thinMediumSubheadline)
                            
                            ForEach(getPreCareInstructions(for: procedure.name), id: \.self) { instruction in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                        .padding(.top, 2)
                                    
                                    Text(instruction)
                                        .font(.thinCaption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("After Procedure:")
                                .font(.thinMediumSubheadline)
                            
                            ForEach(getPostCareInstructions(for: procedure.name), id: \.self) { instruction in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .padding(.top, 2)
                                    
                                    Text(instruction)
                                        .font(.thinCaption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // Helper functions to generate content based on procedure type
    private func getProcedureOverview(for procedureName: String) -> String {
        switch procedureName {
        case "Rhinoplasty":
            return "A surgical procedure to reshape the nose, improving both appearance and function. Can address issues like size, shape, or breathing problems."
        case "Breast Augmentation":
            return "Surgical enhancement of breast size and shape using implants or fat transfer. One of the most popular cosmetic procedures worldwide."
        case "Facelift":
            return "Comprehensive facial rejuvenation procedure that addresses sagging skin, wrinkles, and loss of facial volume."
        default:
            return "A carefully planned cosmetic procedure designed to enhance your natural features and boost confidence."
        }
    }
    
    private func getProcedureDuration(for procedureName: String) -> String {
        switch procedureName {
        case "Rhinoplasty": return "2-4 hours"
        case "Breast Augmentation": return "1-2 hours"
        case "Facelift": return "4-6 hours"
        case "Liposuction": return "1-3 hours"
        case "Brazilian Butt Lift": return "2-4 hours"
        default: return "1-3 hours"
        }
    }
    
    private func getRecoveryTime(for procedureName: String) -> String {
        switch procedureName {
        case "Rhinoplasty": return "1-2 weeks"
        case "Breast Augmentation": return "2-4 weeks"
        case "Facelift": return "2-3 weeks"
        case "Liposuction": return "1-2 weeks"
        case "Brazilian Butt Lift": return "3-4 weeks"
        default: return "1-3 weeks"
        }
    }
    
    private func getReturnToWork(for procedureName: String) -> String {
        switch procedureName {
        case "Rhinoplasty": return "7-10 days"
        case "Breast Augmentation": return "5-7 days"
        case "Facelift": return "10-14 days"
        case "Liposuction": return "3-5 days"
        default: return "5-10 days"
        }
    }
    
    private func getRisks(for procedureName: String) -> [String] {
        return [
            "Bleeding or infection at surgical site",
            "Reaction to anesthesia",
            "Scarring or changes in skin sensation",
            "Need for additional procedures",
            "Temporary swelling and bruising"
        ]
    }
    
    private func getPreCareInstructions(for procedureName: String) -> [String] {
        return [
            "Stop smoking at least 2 weeks before surgery",
            "Avoid blood-thinning medications",
            "Arrange for someone to drive you home",
            "Follow fasting instructions if general anesthesia is used"
        ]
    }
    
    private func getPostCareInstructions(for procedureName: String) -> [String] {
        return [
            "Keep surgical area clean and dry",
            "Take prescribed medications as directed",
            "Avoid strenuous activities for recommended period",
            "Attend all follow-up appointments",
            "Contact clinic immediately if you notice signs of infection"
        ]
    }
}

struct InfoSectionCard<Content: View>: View {
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
                    .foregroundColor(.blue)
                
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

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.thinSubheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.thinMediumSubheadline)
                .foregroundColor(.blue)
        }
    }
}