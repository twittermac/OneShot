import Foundation
import FirebaseFirestore

class ChannelManager: ObservableObject {
    static let shared = ChannelManager()
    private let db = Firestore.firestore()
    
    @Published var currentChannel: Channel?
    @Published var isHosting: Bool = false
    
    struct Channel: Identifiable {
        let id: String
        let hostId: String
        let title: String
        let description: String
        let currentPrice: Double
        let startPrice: Double
        let status: ChannelStatus
        let createdAt: Date
        let updatedAt: Date
        
        enum ChannelStatus: String {
            case active
            case ended
            case scheduled
        }
    }
    
    private init() {}
    
    func createChannel(title: String, description: String, startPrice: Double) {
        let channel = Channel(
            id: UUID().uuidString,
            hostId: "current_user_id", // Replace with actual user ID
            title: title,
            description: description,
            currentPrice: startPrice,
            startPrice: startPrice,
            status: .active,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // Save to Firestore
        db.collection("channels").document(channel.id).setData([
            "id": channel.id,
            "hostId": channel.hostId,
            "title": channel.title,
            "description": channel.description,
            "currentPrice": channel.currentPrice,
            "startPrice": channel.startPrice,
            "status": channel.status.rawValue,
            "createdAt": channel.createdAt,
            "updatedAt": channel.updatedAt
        ]) { error in
            if let error = error {
                print("Error creating channel: \(error)")
            } else {
                self.currentChannel = channel
                self.isHosting = true
            }
        }
    }
    
    func joinChannel(channelId: String) {
        db.collection("channels").document(channelId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error joining channel: \(error)")
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("Channel not found")
                return
            }
            
            let channel = Channel(
                id: data["id"] as? String ?? "",
                hostId: data["hostId"] as? String ?? "",
                title: data["title"] as? String ?? "",
                description: data["description"] as? String ?? "",
                currentPrice: data["currentPrice"] as? Double ?? 0.0,
                startPrice: data["startPrice"] as? Double ?? 0.0,
                status: Channel.ChannelStatus(rawValue: data["status"] as? String ?? "") ?? .active,
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
            )
            
            self?.currentChannel = channel
            self?.isHosting = false
        }
    }
    
    func placeBid(amount: Double) {
        guard let channel = currentChannel else { return }
        
        let newPrice = max(channel.currentPrice + 1.0, amount)
        
        db.collection("channels").document(channel.id).updateData([
            "currentPrice": newPrice,
            "updatedAt": Date()
        ]) { [weak self] error in
            if let error = error {
                print("Error placing bid: \(error)")
            } else {
                self?.currentChannel = Channel(
                    id: channel.id,
                    hostId: channel.hostId,
                    title: channel.title,
                    description: channel.description,
                    currentPrice: newPrice,
                    startPrice: channel.startPrice,
                    status: channel.status,
                    createdAt: channel.createdAt,
                    updatedAt: Date()
                )
            }
        }
    }
    
    func endChannel() {
        guard let channel = currentChannel else { return }
        
        db.collection("channels").document(channel.id).updateData([
            "status": Channel.ChannelStatus.ended.rawValue,
            "updatedAt": Date()
        ]) { [weak self] error in
            if let error = error {
                print("Error ending channel: \(error)")
            } else {
                self?.currentChannel = nil
                self?.isHosting = false
            }
        }
    }
} 