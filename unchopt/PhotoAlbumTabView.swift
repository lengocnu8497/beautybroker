import SwiftUI

struct PhotoAlbumTabView: View {
    let procedure: Procedure
    
    // Sample photo data - in a real app, this would come from a backend
    private var samplePhotos: [UserPhoto] {
        let basePhotos = [
            UserPhoto(id: 1, username: "Sarah_M", timeAgo: "2 weeks ago", beforeImage: "photo", afterImage: "photo.on.rectangle", likes: 24),
            UserPhoto(id: 2, username: "Mike_Chen", timeAgo: "1 month ago", beforeImage: "photo.fill", afterImage: "photo.on.rectangle.fill", likes: 18),
            UserPhoto(id: 3, username: "Emma_R", timeAgo: "3 weeks ago", beforeImage: "camera", afterImage: "camera.fill", likes: 31),
            UserPhoto(id: 4, username: "Alex_K", timeAgo: "2 months ago", beforeImage: "photo.circle", afterImage: "photo.circle.fill", likes: 42),
            UserPhoto(id: 5, username: "Jenny_L", timeAgo: "1 week ago", beforeImage: "photo.stack", afterImage: "photo.stack.fill", likes: 15),
            UserPhoto(id: 6, username: "David_W", timeAgo: "5 weeks ago", beforeImage: "photo.tv", afterImage: "photo.artframe", likes: 28)
        ]
        return basePhotos
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(samplePhotos) { photo in
                    PhotoSubmissionCard(photo: photo)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct UserPhoto: Identifiable {
    let id: Int
    let username: String
    let timeAgo: String
    let beforeImage: String
    let afterImage: String
    let likes: Int
}

struct PhotoSubmissionCard: View {
    let photo: UserPhoto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User info header
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(photo.username.prefix(1)))
                            .font(.thinMediumHeadline)
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(photo.username)
                        .font(.thinMediumSubheadline)
                    
                    Text(photo.timeAgo)
                        .font(.thinCaption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            
            // Before/After Photos
            HStack(spacing: 12) {
                VStack(spacing: 8) {
                    Text("Before")
                        .font(.thinCaption)
                        .foregroundColor(.secondary)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: photo.beforeImage)
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(spacing: 8) {
                    Text("After")
                        .font(.thinCaption)
                        .foregroundColor(.secondary)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.2))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: photo.afterImage)
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        )
                }
            }
            
            // Interaction buttons
            HStack {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                        Text("\(photo.likes)")
                            .font(.thinCaption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "message")
                            .foregroundColor(.blue)
                        Text("Comment")
                            .font(.thinCaption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}