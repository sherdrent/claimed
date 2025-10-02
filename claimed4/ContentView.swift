import SwiftUI

// MARK: - Settlement Model
struct Settlement: Identifiable {
    let id = UUID()
    let title: String
    let amount: String
    let due: String
    let noProof: Bool
    let imageName: String
    let destination: AnyView
}

// MARK: - ContentView (Home Tab)
struct ContentView: View {
    @ObservedObject var walletManager: WalletManager
    @State private var selectedFilter: String = "All"
    
    var settlements: [Settlement] {
        [
            Settlement(title: "Poppi", amount: "$26", due: "Due in 67 days", noProof: false, imageName: "pur13", destination: AnyView(Poppi(walletManager: walletManager))),
            Settlement(title: "CashApp", amount: "$8", due: "Due in 67 days", noProof: true, imageName: "pur8", destination: AnyView(Cashapp(walletManager: walletManager))),
            Settlement(title: "Temu", amount: "$5000+", due: "Due in 67 days", noProof: false, imageName: "pur16", destination: AnyView(Temu(walletManager: walletManager))),
            Settlement(title: "Coinbase", amount: "$17", due: "Due in 67 days", noProof: false, imageName: "pur10", destination: AnyView(Coinbase(walletManager: walletManager))),
            Settlement(title: "Neiman Marcus", amount: "$750", due: "Due in 10 days", noProof: true, imageName: "pur11", destination: AnyView(Neiman(walletManager: walletManager))),
            Settlement(title: "Western Union", amount: "$750", due: "Due in 90 days", noProof: false, imageName: "pur18", destination: AnyView(Western(walletManager: walletManager))),
            Settlement(title: "Uber", amount: "$500", due: "Due in 90 days", noProof: false, imageName: "pur17", destination: AnyView(Uber(walletManager: walletManager))),
            Settlement(title: "Panera", amount: "$5-100", due: "Due in 15 days", noProof: true, imageName: "pur12", destination: AnyView(Panera(walletManager: walletManager))),
            Settlement(title: "Speedway", amount: "$970", due: "Due in 30 days", noProof: false, imageName: "pur15", destination: AnyView(Speedway(walletManager: walletManager))),
            Settlement(title: "Whole Foods", amount: "$5.50", due: "Due in 67 days", noProof: false, imageName: "pur19", destination: AnyView(Wholefoods(walletManager: walletManager)))
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Settlements")
                .font(.system(size: 32, weight: .heavy))
                .italic()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 12)
            
            ScrollView {
                VStack(spacing: 16) {
                    // Featured Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured")
                            .font(.system(size: 22, weight: .bold))
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        FeaturedCard(walletManager: walletManager)
                            .padding(.horizontal, 20)
                    }
                    
                    // Filter tabs
                    HStack(spacing: 20) {
                        FilterButton(title: "All", isSelected: selectedFilter == "All") {
                            selectedFilter = "All"
                        }
                        
                        FilterButton(title: "Upcoming", isSelected: selectedFilter == "Upcoming") {
                            selectedFilter = "Upcoming"
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Settlements List
                    ForEach(settlements) { settlement in
                        SettlementRow(settlement: settlement, walletManager: walletManager)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

// MARK: - Featured Card
struct FeaturedCard: View {
    @ObservedObject var walletManager: WalletManager
    
    var body: some View {
        NavigationLink(destination: Uber(walletManager: walletManager)) {
            VStack(spacing: 0) {
                HStack {
                    // Logo - same size as other rows
                    Image("pur17")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                    
                    // Info
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("$500")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("No proof")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(12)
                        }
                        
                        Text("Due in 8 days")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Claim button - same style as other rows
                    Text("Claim")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                
                // Progress bar
                VStack(spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * 0.99, height: 6)
                                .cornerRadius(3)
                        }
                    }
                    .frame(height: 6)
                    
                    Text("99 out of 100 claims filled 🎉")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Filter Button
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .black : .gray)
                .padding(.bottom, 4)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(isSelected ? .black : .clear)
                        .offset(y: 8)
                )
        }
    }
}

// MARK: - Settlement Row
struct SettlementRow: View {
    var settlement: Settlement
    @ObservedObject var walletManager: WalletManager
    
    var body: some View {
        HStack {
            // Logo
            Image(settlement.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(settlement.amount)
                        .font(.system(size: 20, weight: .bold))
                    
                    if settlement.noProof {
                        Text("No proof")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                Text(settlement.due)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Claim button
            ZStack {
                NavigationLink(destination: settlement.destination) {
                    Color.clear
                }
                .frame(width: 80, height: 40)
                
                Text("Claim")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .allowsHitTesting(false)
            }
        }
        .padding(.vertical, 14)
    }
}

// MARK: - Main TabView
struct MainTabView: View {
    @StateObject var walletManager = WalletManager()
    
    var body: some View {
        TabView {
            NavigationStack {
                ContentView(walletManager: walletManager)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationStack {
                WalletView(walletManager: walletManager)
            }
            .tabItem {
                Image(systemName: "creditcard.fill")
                Text("Wallet")
            }
        }
    }
}

// MARK: - Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .previewDisplayName("Main Tabs (Home + Wallet)")
    }
}
