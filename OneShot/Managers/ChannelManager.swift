import Foundation

class ChannelManager {
    static let shared = ChannelManager()
    
    private var activeChannels: [String: Channel] = [:]
    
    struct Channel {
        let id: String
        let sellerId: String
        var viewers: [String]
        var isLive: Bool
        var currentAuction: Auction?
        
        struct Auction {
            let itemId: String
            let startingPrice: Double
            var currentPrice: Double
            var highestBidder: String?
            var endTime: Date
            var status: Status
            
            enum Status {
                case active
                case ended
                case cancelled
            }
        }
    }
    
    private init() {}
    
    func createChannel(sellerId: String) -> Channel {
        let channelId = UUID().uuidString
        let channel = Channel(
            id: channelId,
            sellerId: sellerId,
            viewers: [],
            isLive: false,
            currentAuction: nil
        )
        activeChannels[channelId] = channel
        return channel
    }
    
    func joinChannel(channelId: String, userId: String) -> Channel? {
        guard var channel = activeChannels[channelId] else { return nil }
        channel.viewers.append(userId)
        activeChannels[channelId] = channel
        return channel
    }
    
    func leaveChannel(channelId: String, userId: String) {
        guard var channel = activeChannels[channelId] else { return }
        channel.viewers.removeAll { $0 == userId }
        activeChannels[channelId] = channel
    }
    
    func startAuction(channelId: String, itemId: String, startingPrice: Double, duration: TimeInterval) {
        guard var channel = activeChannels[channelId] else { return }
        let auction = Channel.Auction(
            itemId: itemId,
            startingPrice: startingPrice,
            currentPrice: startingPrice,
            highestBidder: nil,
            endTime: Date().addingTimeInterval(duration),
            status: .active
        )
        channel.currentAuction = auction
        channel.isLive = true
        activeChannels[channelId] = channel
    }
    
    func placeBid(channelId: String, userId: String, amount: Double) -> Bool {
        guard var channel = activeChannels[channelId],
              var auction = channel.currentAuction,
              auction.status == .active,
              amount > auction.currentPrice else {
            return false
        }
        
        auction.currentPrice = amount
        auction.highestBidder = userId
        channel.currentAuction = auction
        activeChannels[channelId] = channel
        return true
    }
    
    func endAuction(channelId: String) {
        guard var channel = activeChannels[channelId],
              var auction = channel.currentAuction else { return }
        
        auction.status = .ended
        channel.currentAuction = auction
        channel.isLive = false
        activeChannels[channelId] = channel
    }
    
    func getChannel(channelId: String) -> Channel? {
        return activeChannels[channelId]
    }
    
    func getAllChannels() -> [Channel] {
        return Array(activeChannels.values)
    }
} 