import SwiftUI

struct LiveStreamView: View {
    let channelId: String
    @State private var isBroadcasting = false
    @State private var showControls = false
    
    var body: some View {
        ZStack {
            // Video container
            VideoContainerView(channelId: channelId)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay controls
            VStack {
                Spacer()
                
                if showControls {
                    HStack {
                        Button(action: {
                            if isBroadcasting {
                                AgoraManager.shared.stopBroadcasting()
                            } else {
                                AgoraManager.shared.startBroadcasting()
                            }
                            isBroadcasting.toggle()
                        }) {
                            Image(systemName: isBroadcasting ? "stop.circle.fill" : "play.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(isBroadcasting ? .red : .green)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            AgoraManager.shared.leaveChannel()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .background(Color.black.opacity(0.5))
                }
            }
        }
        .onTapGesture {
            withAnimation {
                showControls.toggle()
            }
        }
    }
}

// UIViewRepresentable for Agora video
struct VideoContainerView: UIViewRepresentable {
    let channelId: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        // Setup Agora video
        AgoraManager.shared.setupLocalVideo(in: view)
        AgoraManager.shared.joinChannel(channelId: channelId)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    LiveStreamView(channelId: "test-channel")
} 