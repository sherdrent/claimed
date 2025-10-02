import SwiftUI

struct Neiman: View {
    @ObservedObject var walletManager: WalletManager  // Added
    
    // MARK: - Deadline
    private let deadline = Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 8))!
    
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
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Logo
                    Image("pur11")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .padding(.top, 40)
                    
                    // Case Title
                    Text("Neiman Marcus\n Customer Data")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, -20)
                    
                    // Dynamic Due date
                    Text("Due in \(daysRemaining) days")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, -10)
                    
                    // Proof badge
                    Text("Proof Required")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(20)
                    
                    // Claim Website
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("Official Claim Website")
                                .font(.headline)
                        }
                        
                        Text("Redirected to Neiman Marcus \nData Security Breach Litigation")
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
                    
                    // Lawsuit description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lawsuit")
                            .font(.headline)
                        Text("This class action lawsuit stems from a data breach in 2020 that compromised personal information of Neiman Marcus customers. The settlement offers cash payments for time spent, documented losses, and reimbursement for data protection services.")
                            .font(.body)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Eligibility")
                            .font(.headline)
                        Text("If you received a notice about the 2020 Neiman Marcus data breach, you may be eligible to receive a cash payment or reimbursement as part of a class action settlement.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 280)
                }
            }
            
            // Blue Card pinned at bottom
            VStack {
                Spacer()
                payoutCard
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        
        // Safari popup
        .sheet(isPresented: $showSafari, onDismiss: {
            showAlert = true
        }) {
            SafariView(url: URL(string: "https://www.nmgsettlement.com/Login")!)
        }
        
        // Alert after Safari closes - UPDATED
        .alert("Did you submit a claim for Neiman Marcus Data Breach?", isPresented: $showAlert) {
            Button("Yes") {
                walletManager.addClaim(
                    title: "Neiman Marcus Customer Data",
                    amount: 750.0,
                    imageName: "pur11"
                )
                print("✅ User said Yes for Neiman Marcus - Added to wallet")
            }
            Button("No") {
                print("❌ User said No for Neiman Marcus")
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
                
                Text("$750")
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
                    
                    // Claim button triggers Safari
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

struct Neiman_Previews: PreviewProvider {
    static var previews: some View {
        Neiman(walletManager: WalletManager())
            .previewDevice("iPhone 17 Pro")
            .previewDisplayName("iPhone 17 Pro")
    }
}
