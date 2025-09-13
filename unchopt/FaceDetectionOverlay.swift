import SwiftUI
import UIKit
import Vision

// MARK: - Face Detection Overlay View
struct FaceDetectionOverlay: View {
    let detectedFaces: [DetectedFace]
    let imageSize: CGSize
    let displaySize: CGSize
    
    var body: some View {
        ZStack {
            ForEach(detectedFaces) { face in
                FaceOutlineView(
                    face: face,
                    imageSize: imageSize,
                    displaySize: displaySize
                )
            }
        }
    }
}

// MARK: - Individual Face Outline View
struct FaceOutlineView: View {
    let face: DetectedFace
    let imageSize: CGSize
    let displaySize: CGSize
    @Environment(\.colorScheme) var colorScheme
    
    private var scaleFactor: CGSize {
        CGSize(
            width: displaySize.width / imageSize.width,
            height: displaySize.height / imageSize.height
        )
    }
    
    private var scaledBoundingBox: CGRect {
        CGRect(
            x: face.boundingBox.origin.x * scaleFactor.width,
            y: face.boundingBox.origin.y * scaleFactor.height,
            width: face.boundingBox.width * scaleFactor.width,
            height: face.boundingBox.height * scaleFactor.height
        )
    }
    
    var body: some View {
        ZStack {
            // Face bounding box
            Rectangle()
                .stroke(detectionColor, lineWidth: 2)
                .frame(
                    width: scaledBoundingBox.width,
                    height: scaledBoundingBox.height
                )
                .position(
                    x: scaledBoundingBox.midX,
                    y: scaledBoundingBox.midY
                )
            
            // Confidence indicator
            VStack {
                Text("\(Int(face.confidence * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(detectionColor)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.adaptiveBackground(colorScheme).opacity(0.8))
                    )
                
                Spacer()
            }
            .frame(
                width: scaledBoundingBox.width,
                height: scaledBoundingBox.height
            )
            .position(
                x: scaledBoundingBox.midX,
                y: scaledBoundingBox.midY
            )
            
            // Facial landmarks
            if let landmarks = face.landmarks {
                FaceLandmarksView(
                    landmarks: landmarks,
                    scaleFactor: scaleFactor,
                    color: detectionColor
                )
            }
        }
    }
    
    private var detectionColor: Color {
        let quality = DetectionQuality(confidence: face.confidence)
        return Color(quality.color)
    }
}

// MARK: - Facial Landmarks View
struct FaceLandmarksView: View {
    let landmarks: FaceLandmarks
    let scaleFactor: CGSize
    let color: Color
    
    var body: some View {
        ZStack {
            // Eyes
            if let leftEye = landmarks.leftEye {
                LandmarkPointsView(points: leftEye, scaleFactor: scaleFactor, color: color)
            }
            
            if let rightEye = landmarks.rightEye {
                LandmarkPointsView(points: rightEye, scaleFactor: scaleFactor, color: color)
            }
            
            // Eyebrows
            if let leftEyebrow = landmarks.leftEyebrow {
                LandmarkPointsView(points: leftEyebrow, scaleFactor: scaleFactor, color: color)
            }
            
            if let rightEyebrow = landmarks.rightEyebrow {
                LandmarkPointsView(points: rightEyebrow, scaleFactor: scaleFactor, color: color)
            }
            
            // Nose
            if let nose = landmarks.nose {
                LandmarkPointsView(points: nose, scaleFactor: scaleFactor, color: color)
            }
            
            // Lips
            if let outerLips = landmarks.outerLips {
                LandmarkPointsView(points: outerLips, scaleFactor: scaleFactor, color: color, connected: true)
            }
            
            if let innerLips = landmarks.innerLips {
                LandmarkPointsView(points: innerLips, scaleFactor: scaleFactor, color: color, connected: true)
            }
            
            // Face contour
            if let faceContour = landmarks.faceContour {
                LandmarkPointsView(points: faceContour, scaleFactor: scaleFactor, color: color, connected: true)
            }
        }
    }
}

// MARK: - Landmark Points View
struct LandmarkPointsView: View {
    let points: [CGPoint]
    let scaleFactor: CGSize
    let color: Color
    let connected: Bool
    
    init(points: [CGPoint], scaleFactor: CGSize, color: Color, connected: Bool = false) {
        self.points = points
        self.scaleFactor = scaleFactor
        self.color = color
        self.connected = connected
    }
    
    var body: some View {
        ZStack {
            // Draw connecting lines if requested
            if connected && points.count > 1 {
                Path { path in
                    let scaledPoints = points.map { point in
                        CGPoint(
                            x: point.x * scaleFactor.width,
                            y: point.y * scaleFactor.height
                        )
                    }
                    
                    path.move(to: scaledPoints[0])
                    for i in 1..<scaledPoints.count {
                        path.addLine(to: scaledPoints[i])
                    }
                }
                .stroke(color.opacity(0.6), lineWidth: 1)
            }
            
            // Draw individual points
            ForEach(0..<points.count, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 2, height: 2)
                    .position(
                        x: points[index].x * scaleFactor.width,
                        y: points[index].y * scaleFactor.height
                    )
            }
        }
    }
}

// MARK: - Preview
struct FaceDetectionOverlay_Previews: PreviewProvider {
    static var previews: some View {
        // Preview without mock data since VNFaceObservation can't be easily created
        FaceDetectionOverlay(
            detectedFaces: [],
            imageSize: CGSize(width: 400, height: 400),
            displaySize: CGSize(width: 300, height: 300)
        )
        .background(Color.gray.opacity(0.3))
        .frame(width: 300, height: 300)
    }
}