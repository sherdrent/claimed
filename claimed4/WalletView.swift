import SwiftUI

struct WalletView: View {
    @ObservedObject var walletManager: WalletManager
    @State private var showCashOutAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                
                VStack {
                    Text("Wallet")
                        .font(.system(size: 24, weight: .black))
                        .italic()
                        .foregroundColor(.black)
                    
                    Image("Coin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 135)
                        .padding(.top, -20)
                    
                    Text("$\(Int(walletManager.totalClaimed))")
                        .font(.system(size: 64, weight: .black))
                        .foregroundColor(.black)
                        .padding(.top, -20)
                    
                    Text("Total Claimed Amount")
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .padding(.horizontal)
                        .padding(.top, -40)
                        .frame(width: 354, height: 210)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.02, green: 0.32, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.01, green: 0.22, blue: 0.8), location: 1.00)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(30)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Payout")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 10)
                        
                        Text("$\(String(format: "%.2f", walletManager.availablePayout))")
                            .font(.system(size: 48, weight: .black))
                            .italic()
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showCashOutAlert = true
                        }) {
                            Rectangle()
                            
                                .foregroundColor(.clear)
                                .frame(width: 288, height: 53)
                                .background(Color.white.opacity(0.5))
                            
                                .cornerRadius(20)
                                .overlay(
                                    Text("Cash Out")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                )
                        }
                        .disabled(walletManager.availablePayout == 0)
                    }
                    .padding()
                }
                .padding(.horizontal)
                
                // Share Section
                VStack(spacing: 16) {
                    HStack {
                        Text("Invite 3 friends")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(12)
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    
                    Text("🎉 You're in! Share with friends to cash out faster.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    HStack(spacing: 30) {
                        Spacer()
                        InviteButton()
                        InviteButton()
                        InviteButton()
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    Button(action: {
                        print("Copy Link tapped")
                    }) {
                        Text("Copy Link")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.blue)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, -10)
                
                VStack(alignment: .leading) {
                    Text("Your Claims")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if walletManager.claims.isEmpty {
                        Text("No claims yet")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 40)
                    } else {
                        ForEach(walletManager.claims) { claim in
                            HStack {
                                Image(claim.imageName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading) {
                                    Text(claim.title)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("$\(Int(claim.amount))")
                                        .font(.headline)
                                    Text(claim.status)
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                Spacer()
                                Button("Review") {
                                    print("Reviewing \(claim.title)")
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .alert("All payouts are sent as prepaid virtual cards by settlement administrators", isPresented: $showCashOutAlert) {
            Button("Sounds Good", role: .cancel) {
                walletManager.availablePayout = 0.0
            }
        } message: {
            Text("We're currently adding more payout options. Once available, you'll be able to select your preferred method in Settings.")
        }
    }
}

// MARK: - Invite Button Component
struct InviteButton: View {
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                .frame(width: 65, height: 65)
                .overlay(
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                )
            
            Text("Invite")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.blue)
        }
    }
}

// MARK: - Preview
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        let mockWallet = WalletManager()
        mockWallet.addClaim(title: "Panera Security Data", amount: 100.0, imageName: "pur12")
        mockWallet.addClaim(title: "Whole Foods Hot Cocoa", amount: 5.50, imageName: "pur19")
        
        return WalletView(walletManager: mockWallet)
            .previewDevice("iPhone 17 Pro")
            .previewDisplayName("Wallet View with Claims")
    }
}
