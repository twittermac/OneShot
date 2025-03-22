import SwiftUI

struct AuctionView: View {
    let channelId: String
    @StateObject private var channelManager = ChannelManager.shared
    @State private var showBidSheet = false
    @State private var showEndAuctionAlert = false
    
    var body: some View {
        VStack {
            // Auction Info
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Price")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("$\(channelManager.currentChannel?.currentPrice ?? 0.0, specifier: "%.2f")")
                        .font(.title)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Starting Price")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("$\(channelManager.currentChannel?.startPrice ?? 0.0, specifier: "%.2f")")
                        .font(.title2)
                        .bold()
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            // Bid History
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bid History")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if let channel = channelManager.currentChannel {
                        Text("Current Bid: $\(channel.currentPrice, specifier: "%.2f")")
                            .padding(.horizontal)
                    } else {
                        Text("No active auction")
                            .padding(.horizontal)
                    }
                }
            }
            
            // Bid Controls
            HStack {
                Button(action: {
                    showBidSheet = true
                }) {
                    Text("Place Bid")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                if channelManager.currentChannel?.hostId == "current_user_id" {
                    Button(action: {
                        showEndAuctionAlert = true
                    }) {
                        Text("End Auction")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showBidSheet) {
            BidSheet(channelId: channelId)
        }
        .alert("End Auction", isPresented: $showEndAuctionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("End", role: .destructive) {
                channelManager.endChannel()
            }
        } message: {
            Text("Are you sure you want to end this auction?")
        }
    }
}

struct BidHistoryRow: View {
    var body: some View {
        HStack {
            Text("User123")
                .font(.subheadline)
            Spacer()
            Text("$100.00")
                .font(.subheadline)
                .bold()
            Text("2m ago")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct BidSheet: View {
    let channelId: String
    @Environment(\.dismiss) var dismiss
    @State private var bidAmount: String = ""
    @StateObject private var channelManager = ChannelManager.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Bid Amount")) {
                    TextField("Amount", text: $bidAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button("Place Bid") {
                        if let amount = Double(bidAmount) {
                            channelManager.placeBid(amount: amount)
                            dismiss()
                        }
                    }
                    .disabled(bidAmount.isEmpty)
                }
            }
            .navigationTitle("Place Bid")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}

#Preview {
    AuctionView(channelId: "test-channel")
} 