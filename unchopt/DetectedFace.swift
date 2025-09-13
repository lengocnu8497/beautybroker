import Foundation
import Vision
import UIKit

// MARK: - Detected Face Model
struct DetectedFace: Identifiable {
    let id = UUID()
    let boundingBox: CGRect
    let landmarks: FaceLandmarks?
    let confidence: Float
    
    init(from observation: VNFaceObservation, imageSize: CGSize) {
        // Convert normalized coordinates to image coordinates
        // Vision uses bottom-left origin, we need top-left for UI
        let x = observation.boundingBox.origin.x * imageSize.width
        let y = (1 - observation.boundingBox.origin.y - observation.boundingBox.height) * imageSize.height
        let width = observation.boundingBox.width * imageSize.width
        let height = observation.boundingBox.height * imageSize.height
        
        self.boundingBox = CGRect(x: x, y: y, width: width, height: height)
        self.confidence = observation.confidence
        
        // Extract landmarks if available
        if let faceLandmarks = observation.landmarks {
            self.landmarks = FaceLandmarks(from: faceLandmarks, imageSize: imageSize, boundingBox: observation.boundingBox)
        } else {
            self.landmarks = nil
        }
        
        print("Created DetectedFace with confidence: \(confidence), boundingBox: \(boundingBox)")
    }
}

// MARK: - Face Landmarks Model
struct FaceLandmarks {
    let leftEye: [CGPoint]?
    let rightEye: [CGPoint]?
    let nose: [CGPoint]?
    let outerLips: [CGPoint]?
    let innerLips: [CGPoint]?
    let leftEyebrow: [CGPoint]?
    let rightEyebrow: [CGPoint]?
    let faceContour: [CGPoint]?
    
    init(from landmarks: VNFaceLandmarks2D, imageSize: CGSize, boundingBox: CGRect) {
        func convertPoints(_ points: [CGPoint]?) -> [CGPoint]? {
            return points?.map { point in
                // Convert from landmark-relative coordinates to image coordinates
                let x = boundingBox.origin.x * imageSize.width + point.x * boundingBox.width * imageSize.width
                let y = (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height + (1 - point.y) * boundingBox.height * imageSize.height
                return CGPoint(x: x, y: y)
            }
        }
        
        self.leftEye = convertPoints(landmarks.leftEye?.normalizedPoints)
        self.rightEye = convertPoints(landmarks.rightEye?.normalizedPoints)
        self.nose = convertPoints(landmarks.nose?.normalizedPoints)
        self.outerLips = convertPoints(landmarks.outerLips?.normalizedPoints)
        self.innerLips = convertPoints(landmarks.innerLips?.normalizedPoints)
        self.leftEyebrow = convertPoints(landmarks.leftEyebrow?.normalizedPoints)
        self.rightEyebrow = convertPoints(landmarks.rightEyebrow?.normalizedPoints)
        self.faceContour = convertPoints(landmarks.faceContour?.normalizedPoints)
        
        print("Created FaceLandmarks with features - Eyes: \(leftEye?.count ?? 0)/\(rightEye?.count ?? 0), Nose: \(nose?.count ?? 0)")
    }
}

// MARK: - Detection Quality Helper
enum DetectionQuality {
    case excellent  // confidence > 0.9
    case good      // confidence > 0.7
    case fair      // confidence > 0.5
    case poor      // confidence <= 0.5
    
    init(confidence: Float) {
        switch confidence {
        case 0.9...1.0:
            self = .excellent
        case 0.7..<0.9:
            self = .good
        case 0.5..<0.7:
            self = .fair
        default:
            self = .poor
        }
    }
    
    var color: UIColor {
        switch self {
        case .excellent:
            return .systemGreen
        case .good:
            return .systemBlue
        case .fair:
            return .systemOrange
        case .poor:
            return .systemRed
        }
    }
}