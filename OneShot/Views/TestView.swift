import SwiftUI

struct TestView: View {
    @State private var channelId: String = ""
    @State private var isStreaming = false
    @State private var showLiveStream = false
    @State private var bidAmount: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Channel Creation
                VStack(alignment: .leading) {
                    Text("Create/Join Channel")
                        .font(.headline)
                    
                    TextField("Channel ID", text: $channelId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Button(action: {
                            if channelId.isEmpty {
                                channelId = UUID().uuidString
                            }
                            ChannelManager.shared.createChannel(
                                title: "Test Stream",
                                description: "This is a test live stream",
                                startPrice: 100.0
                            )
                        }) {
                            Text("Create Channel")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            if !channelId.isEmpty {
                                ChannelManager.shared.joinChannel(channelId: channelId)
                            }
                        }) {
                            Text("Join Channel")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Auction Controls
                VStack(alignment: .leading) {
                    Text("Auction Controls")
                        .font(.headline)
                    
                    HStack {
                        TextField("Bid Amount", value: $bidAmount, format: .currency(code: "USD"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Button(action: {
                            ChannelManager.shared.placeBid(amount: bidAmount)
                        }) {
                            Text("Place Bid")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        ChannelManager.shared.endChannel()
                    }) {
                        Text("End Auction")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Stream Controls
                VStack(alignment: .leading) {
                    Text("Stream Controls")
                        .font(.headline)
                    
                    Button(action: {
                        isStreaming.toggle()
                        showLiveStream = isStreaming
                    }) {
                        Text(isStreaming ? "Stop Stream" : "Start Stream")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isStreaming ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                Spacer()
            }
            .padding()
            .navigationTitle("OneShot Test")
            .sheet(isPresented: $showLiveStream) {
                if !channelId.isEmpty {
                    LiveStreamView(channelId: channelId)
                }
            }
        }
    }
}

#Preview {
    TestView()
} 