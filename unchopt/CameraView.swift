import SwiftUI
import AVFoundation
import UIKit

// MARK: - Camera View with iPhone Camera Access
struct CameraView: View {
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var showingPermissionAlert = false
    @StateObject private var faceDetectionManager = FaceDetectionManager()
    @State private var showingFaceDetection = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: Spacing.xl) {
                // Header
                CustomizedSectionHeader(
                    title: "Camera",
                    showViewAll: false
                )
                
                Spacer()
                
                // Camera Preview Area
                if let capturedImage = capturedImage {
                    // Show captured image with face detection
                    VStack(spacing: Spacing.lg) {
                        ZStack {
                            Image(uiImage: capturedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 400)
                                .cornerRadius(CornerRadius.lg)
                                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            // Face detection overlay
                            if showingFaceDetection {
                                FaceDetectionOverlay(
                                    detectedFaces: faceDetectionManager.detectedFaces,
                                    imageSize: capturedImage.size,
                                    displaySize: CGSize(width: min(capturedImage.size.width, 400), 
                                                      height: min(capturedImage.size.height, 400))
                                )
                            }
                            
                            // Processing indicator
                            if faceDetectionManager.isProcessing {
                                ProgressView("Detecting faces...")
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black.opacity(0.7))
                                            .frame(width: 150, height: 50)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Face detection toggle
                        HStack(spacing: Spacing.md) {
                            CustomizedButton(
                                title: showingFaceDetection ? "Hide Detection" : "Detect Faces",
                                style: .outline,
                                action: {
                                    if showingFaceDetection {
                                        showingFaceDetection = false
                                        faceDetectionManager.disableDetection()
                                    } else {
                                        performFaceDetection()
                                    }
                                }
                            )
                        }
                        
                        HStack(spacing: Spacing.md) {
                            CustomizedButton(
                                title: "Retake Photo",
                                style: .secondary,
                                action: {
                                    self.capturedImage = nil
                                    self.showingFaceDetection = false
                                    faceDetectionManager.disableDetection()
                                    openCamera()
                                }
                            )
                            
                            CustomizedButton(
                                title: "Use Photo",
                                style: .primary,
                                action: {
                                    // Handle using the photo
                                    print("Using captured photo with \(faceDetectionManager.detectedFaces.count) detected faces")
                                }
                            )
                        }
                    }
                } else {
                    // Camera placeholder
                    VStack(spacing: Spacing.lg) {
                        RoundedRectangle(cornerRadius: CornerRadius.lg)
                            .fill(Color.adaptiveSecondaryBackground(colorScheme))
                            .frame(height: 300)
                            .overlay(
                                VStack(spacing: Spacing.md) {
                                    Image(systemName: "camera")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                    
                                    Text("Tap to take a photo")
                                        .font(.bodyLarge)
                                        .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                                }
                            )
                            .onTapGesture {
                                openCamera()
                            }
                        
                        // Camera action buttons
                        VStack(spacing: Spacing.md) {
                            CustomizedButton(
                                title: "Take Photo",
                                style: .primary,
                                action: {
                                    openCamera()
                                }
                            )
                            
                            CustomizedButton(
                                title: "Choose from Library",
                                style: .outline,
                                action: {
                                    showingImagePicker = true
                                }
                            )
                        }
                    }
                }
                
                Spacer()
                
                // Instructions
                VStack(spacing: Spacing.sm) {
                    Text("Capture procedure photos")
                        .font(.titleLarge)
                        .foregroundColor(Color.adaptivePrimaryText(colorScheme))
                    
                    Text("Take before and after photos to document your procedure journey")
                        .font(.bodyMedium)
                        .foregroundColor(Color.adaptiveSecondaryText(colorScheme))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                .padding(.horizontal, Spacing.screenPadding)
            }
            .padding(.horizontal, Spacing.screenPadding)
            .background(Color.adaptiveBackground(colorScheme))
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCamera) {
                ImagePicker(
                    sourceType: .camera,
                    selectedImage: $capturedImage,
                    isPresented: $showingCamera
                )
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(
                    sourceType: .photoLibrary,
                    selectedImage: $capturedImage,
                    isPresented: $showingImagePicker
                )
            }
            .alert("Camera Access Required", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    openAppSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please allow camera access in Settings to take photos.")
            }
        }
    }
    
    private func openCamera() {
        checkCameraPermission { hasPermission in
            if hasPermission {
                showingCamera = true
            } else {
                showingPermissionAlert = true
            }
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    // MARK: - Face Detection
    private func performFaceDetection() {
        guard let image = capturedImage else { return }
        
        faceDetectionManager.enableDetection()
        faceDetectionManager.detectFaces(in: image) { detectedFaces in
            DispatchQueue.main.async {
                self.showingFaceDetection = true
                print("Face detection completed. Found \(detectedFaces.count) face(s)")
            }
        }
    }
}

// MARK: - UIImagePickerController Wrapper
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

// MARK: - Preview
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
