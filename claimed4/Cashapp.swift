import SwiftUI

struct Cashapp: View {
    @ObservedObject var walletManager: WalletManager  // Added
    
    // MARK: - Deadline
    private let deadline = Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 27))!
    
    // MARK: - State
    @State private var showSafari = false
    @State private var showAlert = false
    
    // MARK: - Days Remaining Calculation
    private var daysRemaining: Int {
        let today = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.startOfDay(for: deadline)
        let components = Calendar.current.dateComponents([.day], from: today, to: endDate)
        return components.day ?? 0
    }
    
    var body: some View {
        ZStack {
            // Scrollable content
            ScrollView {
                VStack(spacing: 20) {
                    
                    Image("pur8")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .padding(.top, 40)
                    
                    Text("Cashapp\n Text Class Action")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, -20)
                    
                    Text("Due in \(daysRemaining) days")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, -10)
                    
                    Text("Proof Required")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("Official Claim Website")
                                .font(.headline)
                        }
                        
                        Text("Redirected to Cash App\nSettlement")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 26)
                            .padding(.vertical, -1)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lawsuit")
                            .font(.headline)
                        Text("Block Inc. (Cash App) allegedly helped users send unsolicited Invite Friends referral texts to Washington residents without clear consent, violating state consumer + electronic messaging laws.")
                            .font(.body)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Eligibility")
                            .font(.headline)
                        Text("You received one of these Cash App referral messages while living in Washington between Nov. 14, 2019 and a date in 2025 (TBD).")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 280)
                }
            }
            
            VStack {
                Spacer()
                payoutCard
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        
        // Safari sheet
        .sheet(isPresented: $showSafari, onDismiss: {
            showAlert = true
        }) {
            SafariView(url: URL(string: "https://topclassactions.com/lawsuit-settlements/open-lawsuit-settlements/12-5m-cash-app-text-message-class-action-lawsuit-settlement/")!)
        }
        
        // Alert after Safari closes - UPDATED
        .alert("Did you submit a claim for Cashapp Text Class Action?", isPresented: $showAlert) {
            Button("Yes") {
                walletManager.addClaim(
                    title: "Cashapp Text Class Action",
                    amount: 147.0,
                    imageName: "pur8"
                )
                print("✅ User said Yes for Cashapp - Added to wallet")
            }
            Button("No") {
                print("❌ User said No for Cashapp")
            }
        }
    }
    
    // MARK: - Payout Card
    private var payoutCard: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 380, height: 240)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.01, green: 0.27, blue: 0.91), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.02, green: 0.2, blue: 0.84), location: 0.64),
                            Gradient.Stop(color: Color(red: 0.01, green: 0.1, blue: 0.73), location: 1.00),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Possible Payout")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                
                Text("$147")
                    .font(.system(size: 48, weight: .black))
                    .italic()
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                
                ProgressView(value: 22, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.horizontal, 12)
                
                Text("22 of 100 open claims filed")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 12)
                
                HStack(spacing: 16) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 166, height: 59)
                        .background(.white.opacity(0.2))
                        .cornerRadius(40)
                        .overlay(
                            Text("Share")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    // Claim button opens Safari popup
                    Button(action: { showSafari = true }) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 166, height: 59)
                            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .cornerRadius(40)
                            .overlay(
                                Text("Claim")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                            )
                    }
                }
                .padding(.top, 10)
            }
            .padding(20)
        }
        .padding(.bottom, -10)
    }
}

struct Cashapp_Previews: PreviewProvider {
    static var previews: some View {
        Cashapp(walletManager: WalletManager())
            .previewDevice("iPhone 17 Pro")
    }
}
