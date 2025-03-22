import Foundation
import AgoraRtcKit

class AgoraManager: NSObject {
    static let shared = AgoraManager()
    
    private var agoraKit: AgoraRtcEngineKit?
    private var localVideo: AgoraRtcVideoCanvas?
    private var remoteVideo: AgoraRtcVideoCanvas?
    
    // Agora App ID - Replace with your actual App ID
    private let appId = "YOUR_AGORA_APP_ID"
    
    override private init() {
        super.init()
        initializeAgoraEngine()
    }
    
    private func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
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
            joinSuccess: { channel, uid, elapsed in
                print("Successfully joined channel: \(channel)")
            }
        )
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
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
    }
    
    func stopBroadcasting() {
        agoraKit?.disableVideo()
        agoraKit?.disableAudio()
    }
}

// MARK: - AgoraRtcEngineDelegate
extension AgoraManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("Remote user joined: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("Remote user left: \(uid)")
    }
} 