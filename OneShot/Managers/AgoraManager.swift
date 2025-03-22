import Foundation
import AgoraRtcKit

class AgoraManager: NSObject, ObservableObject {
    static let shared = AgoraManager()
    
    private var agoraKit: AgoraRtcEngineKit?
    private var localVideo: AgoraRtcVideoCanvas?
    private var remoteVideo: AgoraRtcVideoCanvas?
    
    // Published properties for UI updates
    @Published var viewerCount: Int = 0
    @Published var isStreaming: Bool = false
    @Published var streamQuality: StreamQuality = .high
    
    // Agora App ID
    private let appId = "037182e1c2544d18b6a8f3e4e0330da8"
    
    enum StreamQuality {
        case low
        case medium
        case high
        
        var dimensions: CGSize {
            switch self {
            case .low: return CGSize(width: 640, height: 360)
            case .medium: return CGSize(width: 1280, height: 720)
            case .high: return CGSize(width: 1920, height: 1080)
            }
        }
        
        var frameRate: Int {
            switch self {
            case .low: return 15
            case .medium: return 24
            case .high: return 30
            }
        }
        
        var bitrate: Int {
            switch self {
            case .low: return 800
            case .medium: return 1500
            case .high: return 2500
            }
        }
    }
    
    override private init() {
        super.init()
        initializeAgoraEngine()
    }
    
    private func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        setupVideoConfig()
    }
    
    private func setupVideoConfig() {
        let config = AgoraVideoEncoderConfiguration(
            size: streamQuality.dimensions,
            frameRate: AgoraVideoFrameRate(rawValue: streamQuality.frameRate) ?? .fps15,
            bitrate: streamQuality.bitrate,
            orientationMode: .adaptative,
            mirrorMode: .auto
        )
        agoraKit?.setVideoEncoderConfiguration(config)
    }
    
    func joinChannel(channelId: String, uid: UInt = 0) {
        let options = AgoraRtcChannelMediaOptions()
        options.clientRoleType = .broadcaster
        options.channelProfile = .liveBroadcasting
        
        agoraKit?.joinChannel(
            byToken: nil,
            channelId: channelId,
            uid: uid,
            mediaOptions: options,
            joinSuccess: { [weak self] channel, uid, elapsed in
                print("Successfully joined channel: \(channel)")
                self?.isStreaming = true
            }
        )
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        isStreaming = false
        viewerCount = 0
    }
    
    func setupLocalVideo(in view: UIView) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        
        agoraKit?.setupLocalVideo(videoCanvas)
        localVideo = videoCanvas
    }
    
    func setupRemoteVideo(in view: UIView, uid: UInt) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        
        agoraKit?.setupRemoteVideo(videoCanvas)
        remoteVideo = videoCanvas
    }
    
    func startBroadcasting() {
        agoraKit?.setClientRole(.broadcaster)
        agoraKit?.enableVideo()
        agoraKit?.enableAudio()
        isStreaming = true
    }
    
    func stopBroadcasting() {
        agoraKit?.disableVideo()
        agoraKit?.disableAudio()
        isStreaming = false
    }
    
    func setStreamQuality(_ quality: StreamQuality) {
        streamQuality = quality
        setupVideoConfig()
    }
    
    func sendChatMessage(_ message: String) {
        if let data = message.data(using: .utf8) {
            agoraKit?.sendStreamMessage(1, data: data)
        }
    }
}

// MARK: - AgoraRtcEngineDelegate
extension AgoraManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("Remote user joined: \(uid)")
        viewerCount += 1
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("Remote user left: \(uid)")
        viewerCount = max(0, viewerCount - 1)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Agora error occurred: \(errorCode)")
        // Handle specific error cases
        switch errorCode {
        case .joinChannelRejected:
            print("Failed to join channel")
        case .leaveChannelRejected:
            print("Failed to leave channel")
        case .invalidChannelId:
            print("Invalid channel ID")
        default:
            print("Unknown error occurred")
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didReceiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            print("Received message from \(uid): \(message)")
            // Handle chat message
        }
    }
} 