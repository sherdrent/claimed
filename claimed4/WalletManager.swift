import Foundation
import Combine

class WalletManager: ObservableObject {
    @Published var claims: [Claim] = []
    @Published var totalClaimed: Double = 0.0
    @Published var availablePayout: Double = 0.0

    func addClaim(title: String, amount: Double, imageName: String) {
        let newClaim = Claim(title: title, amount: amount, status: "Submitted", imageName: imageName)
        claims.append(newClaim)
        totalClaimed += amount
        availablePayout += amount
    }
}
