import SwiftUI

struct LiveStreamView: View {
    let channelId: String
    @StateObject private var agoraManager = AgoraManager.shared
    @StateObject private var channelManager = ChannelManager.shared
    @State private var showControls = false
    @State private var chatMessage = ""
    @State private var showQualitySettings = false
    
    var body: some View {
        ZStack {
            // Video container
            VideoContainerView(channelId: channelId)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay controls
            VStack {
                // Top bar with viewer count and quality settings
                HStack {
                    HStack {
                        Image(systemName: "eye.fill")
                        Text("\(agoraManager.viewerCount)")
                    }
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: { showQualitySettings.toggle() }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Spacer()
                
                if showControls {
                    VStack(spacing: 20) {
                        // Chat view
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                // Chat messages would go here
                            }
                            .padding()
                        }
                        .frame(height: 200)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(12)
                        
                        // Chat input
                        HStack {
                            TextField("Type a message...", text: $chatMessage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: sendMessage) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            }
                            .disabled(chatMessage.isEmpty)
                        }
                        .padding(.horizontal)
                        
                        // Stream controls
                        HStack {
                            Button(action: {
                                if agoraManager.isStreaming {
                                    agoraManager.stopBroadcasting()
                                } else {
                                    agoraManager.startBroadcasting()
                                }
                            }) {
                                Image(systemName: agoraManager.isStreaming ? "stop.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(agoraManager.isStreaming ? .red : .green)
                            }
                            .padding()
                            
                            Spacer()
                            
                            Button(action: {
                                agoraManager.leaveChannel()
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
            
            // Auction overlay
            VStack {
                Spacer()
                AuctionView(channelId: channelId)
                    .background(Color(.systemBackground).opacity(0.9))
                    .cornerRadius(20)
                    .padding()
            }
        }
        .onTapGesture {
            withAnimation {
                showControls.toggle()
            }
        }
        .sheet(isPresented: $showQualitySettings) {
            QualitySettingsView(agoraManager: agoraManager)
        }
    }
    
    private func sendMessage() {
        guard !chatMessage.isEmpty else { return }
        agoraManager.sendChatMessage(chatMessage)
        chatMessage = ""
    }
}

struct QualitySettingsView: View {
    @ObservedObject var agoraManager: AgoraManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Stream Quality")) {
                    Picker("Quality", selection: $agoraManager.streamQuality) {
                        Text("Low").tag(AgoraManager.StreamQuality.low)
                        Text("Medium").tag(AgoraManager.StreamQuality.medium)
                        Text("High").tag(AgoraManager.StreamQuality.high)
                    }
                }
                
                Section(header: Text("Current Settings")) {
                    HStack {
                        Text("Resolution")
                        Spacer()
                        Text("\(Int(agoraManager.streamQuality.dimensions.width))x\(Int(agoraManager.streamQuality.dimensions.height))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Frame Rate")
                        Spacer()
                        Text("\(agoraManager.streamQuality.frameRate) fps")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Bitrate")
                        Spacer()
                        Text("\(agoraManager.streamQuality.bitrate) kbps")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Stream Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
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