import Foundation
import Vision
import UIKit
import CoreImage
import Combine

// MARK: - Face Detection Manager
class FaceDetectionManager: ObservableObject {
    @Published var detectedFaces: [DetectedFace] = []
    @Published var isProcessing = false
    @Published var detectionEnabled = false
    
    private let visionQueue = DispatchQueue(label: "com.unchopt.vision", qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupDetection()
    }
    
    private func setupDetection() {
        // Initialize any required setup here
        print("FaceDetectionManager initialized")
    }
    
    // MARK: - Static Image Detection
    func detectFaces(in image: UIImage, completion: @escaping ([DetectedFace]) -> Void) {
        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                completion([])
            }
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isProcessing = true
        }
        
        visionQueue.async { [weak self] in
            let request = VNDetectFaceLandmarksRequest { [weak self] request, error in
                DispatchQueue.main.async {
                    self?.isProcessing = false
                    
                    guard error == nil,
                          let observations = request.results as? [VNFaceObservation] else {
                        print("Face detection failed: \(error?.localizedDescription ?? "Unknown error")")
                        completion([])
                        return
                    }
                    
                    let faces = observations.compactMap { observation in
                        DetectedFace(from: observation, imageSize: image.size)
                    }
                    
                    print("Detected \(faces.count) face(s)")
                    self?.detectedFaces = faces
                    completion(faces)
                }
            }
            
            // Configure request for better performance
            request.revision = VNDetectFaceLandmarksRequestRevision3
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self?.isProcessing = false
                    print("Vision request failed: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
    
    // MARK: - Detection Control
    func enableDetection() {
        detectionEnabled = true
        print("Face detection enabled")
    }
    
    func disableDetection() {
        detectionEnabled = false
        detectedFaces = []
        print("Face detection disabled")
    }
    
    func toggleDetection() {
        if detectionEnabled {
            disableDetection()
        } else {
            enableDetection()
        }
    }
}