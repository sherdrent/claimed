import SwiftUI

struct Claim: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let status: String
    let imageName: String
}
