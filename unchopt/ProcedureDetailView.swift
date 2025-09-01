import SwiftUI

struct ProcedureDetailView: View {
    let procedure: Procedure
    @State private var selectedTab = 0
    @State private var showingReviewSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: procedure.imageSystemName)
                        .font(.title)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(Color.blue.opacity(0.1)))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(procedure.name)
                            .font(.thinMediumTitle2)
                        
                        HStack {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text(String(format: "%.1f", procedure.rating))
                                    .font(.thinCaption)
                            }
                            
                            Text("•")
                                .foregroundColor(.gray)
                            
                            Text(procedure.city.rawValue)
                                .font(.thinCaption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Text(procedure.price)
                        .font(.thinMediumTitle2)
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(procedure.doctorName)
                        .font(.thinMediumSubheadline)
                    
                    Text(procedure.clinicName)
                        .font(.thinCaption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            
            // Tab Selector
            HStack(spacing: 0) {
                TabButton(title: "Photos", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                TabButton(title: "Info", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                TabButton(title: "Pricing", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .background(Color(UIColor.systemGray6))
            
            // Tab Content
            TabView(selection: $selectedTab) {
                PhotoAlbumTabView(procedure: procedure)
                    .tag(0)
                
                ProcedureInfoTabView(procedure: procedure)
                    .tag(1)
                
                PricingBreakdownTabView(procedure: procedure)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Review Button
            VStack {
                CustomizedButton(
                    title: "Write a Review",
                    style: .primary,
                    action: {
                        showingReviewSheet = true
                    }
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color(UIColor.systemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showingReviewSheet) {
            ReviewFormView(procedure: procedure)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(isSelected ? .thinMediumSubheadline : .thinSubheadline)
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Rectangle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(height: 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

// MARK: - Review Form View
struct ReviewFormView: View {
    let procedure: Procedure
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentStep = 0
    @State private var beforeImage: UIImage?
    @State private var afterImage: UIImage?
    @State private var reviewDescription = ""
    @State private var actualPrice = ""
    @State private var procedureDate = Date()
    @State private var showingImagePicker = false
    @State private var imagePickerType: ImagePickerType = .before
    
    enum ImagePickerType {
        case before, after
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Progress indicator
                ProgressView(value: Double(currentStep + 1), total: 4)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
                
                Text("Step \(currentStep + 1) of 4")
                    .font(.custom("HelveticaNeue", size: 14))
                    .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                
                // Step content
                ScrollView {
                    VStack(spacing: 24) {
                        switch currentStep {
                        case 0:
                            photoUploadStep
                        case 1:
                            descriptionStep
                        case 2:
                            pricingStep
                        case 3:
                            dateStep
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        CustomizedButton(
                            title: "Back",
                            style: .outline,
                            action: { currentStep -= 1 }
                        )
                    }
                    
                    CustomizedButton(
                        title: currentStep == 3 ? "Submit Review" : "Continue",
                        style: .primary,
                        action: {
                            if currentStep == 3 {
                                // Submit review
                                dismiss()
                            } else {
                                currentStep += 1
                            }
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Write Review")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(
                sourceType: .photoLibrary,
                selectedImage: imagePickerType == .before ? $beforeImage : $afterImage,
                isPresented: $showingImagePicker
            )
        }
    }
    
    private var photoUploadStep: some View {
        VStack(spacing: 24) {
            Text("Upload Your Photos")
                .font(.custom("HelveticaNeue-Medium", size: 20))
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            Text("Share your before and after photos to help others")
                .font(.custom("HelveticaNeue", size: 14))
                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                // Before photo
                VStack(spacing: 8) {
                    Button(action: {
                        imagePickerType = .before
                        showingImagePicker = true
                    }) {
                        if let beforeImage = beforeImage {
                            Image(uiImage: beforeImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.adaptiveSecondaryBackground(colorScheme))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera")
                                            .font(.title2)
                                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                        Text("Before")
                                            .font(.custom("HelveticaNeue", size: 12))
                                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                    }
                                )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // After photo
                VStack(spacing: 8) {
                    Button(action: {
                        imagePickerType = .after
                        showingImagePicker = true
                    }) {
                        if let afterImage = afterImage {
                            Image(uiImage: afterImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.adaptiveSecondaryBackground(colorScheme))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera")
                                            .font(.title2)
                                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                        Text("After")
                                            .font(.custom("HelveticaNeue", size: 12))
                                            .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                    }
                                )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var descriptionStep: some View {
        VStack(spacing: 24) {
            Text("Describe Your Experience")
                .font(.custom("HelveticaNeue-Medium", size: 20))
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            Text("Share details about your procedure and recovery")
                .font(.custom("HelveticaNeue", size: 14))
                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                .multilineTextAlignment(.center)
            
            TextEditor(text: $reviewDescription)
                .frame(height: 200)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.adaptiveTertiaryText(colorScheme), lineWidth: 1)
                )
                .font(.custom("HelveticaNeue", size: 16))
        }
    }
    
    private var pricingStep: some View {
        VStack(spacing: 24) {
            Text("What Did You Pay?")
                .font(.custom("HelveticaNeue-Medium", size: 20))
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            Text("Help others with accurate pricing information")
                .font(.custom("HelveticaNeue", size: 14))
                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                .multilineTextAlignment(.center)
            
            TextField("Enter amount (e.g., 5000)", text: $actualPrice)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .font(.custom("HelveticaNeue", size: 16))
        }
    }
    
    private var dateStep: some View {
        VStack(spacing: 24) {
            Text("When Was Your Procedure?")
                .font(.custom("HelveticaNeue-Medium", size: 20))
                .foregroundColor(Color.adaptivePrimaryText(colorScheme))
            
            Text("This helps others understand the timeline")
                .font(.custom("HelveticaNeue", size: 14))
                .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                .multilineTextAlignment(.center)
            
            DatePicker("Procedure Date", selection: $procedureDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
        }
    }
}