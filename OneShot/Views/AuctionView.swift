import SwiftUI

struct AuctionView: View {
    let channelId: String
    @State private var currentBid: String = ""
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
                    Text("$0.00") // TODO: Get from ChannelManager
                        .font(.title)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Time Remaining")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("00:00") // TODO: Get from ChannelManager
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
                    
                    ForEach(0..<5) { _ in // TODO: Get from ChannelManager
                        BidHistoryRow()
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
                
                if ChannelManager.shared.getChannel(channelId: channelId)?.sellerId == "current_user_id" { // TODO: Get actual user ID
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
                ChannelManager.shared.endAuction(channelId: channelId)
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
                            let success = ChannelManager.shared.placeBid(
                                channelId: channelId,
                                userId: "current_user_id", // TODO: Get actual user ID
                                amount: amount
                            )
                            if success {
                                dismiss()
                            }
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