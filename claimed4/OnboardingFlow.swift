
//
//  OnboardingFlow.swift
//  claimed4
//
//  Created by SHERELY Drent on 9/27/25.
//

import SwiftUI
import SafariServices
import SuperwallKit

// MARK: - Floating Modifier (kept for compatibility but not used)
struct FloatingModifier: ViewModifier {
    @State private var offset: CGFloat = 0
    let range: CGFloat
    let duration: Double
    let delay: Double
    
    func body(content: Content) -> some View {
        content
            .offset(y: offset)
    }
}

extension View {
    func floating(range: CGFloat = 10,
                  duration: Double = 2.0,
                  delay: Double = 0.0) -> some View {
        self.modifier(FloatingModifier(range: range, duration: duration, delay: delay))
    }
}

struct OnboardingFlow: View {
    @State private var currentStep = 0
    @State private var isCalculating = false
    @State private var selectedBrands: Set<String> = []
    @State private var selectedPayout: String = ""
    @State private var animatedAmount: Int = 0
    @State private var showingSafari = false
    @State private var safariURL: URL?
    @State private var slideOffset: CGFloat = 0
    @State private var clickedPaywall = false

    var body: some View {
        ZStack {
            // Shared gradient background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.01, green: 0.32, blue: 1), location: 0.00),
                    .init(color: Color(red: 0.00, green: 0.32, blue: 1), location: 0.19),
                    .init(color: Color(red: 0.03, green: 0.34, blue: 1), location: 0.51),
                    .init(color: Color(red: 0.02, green: 0.23, blue: 0.68), location: 0.91),
                    .init(color: Color(red: 0.02, green: 0.11, blue: 0.35), location: 1.00)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                // Progress Bar (hide on step 0)
                if currentStep > 0 {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 4)
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * CGFloat(currentStep) / 11.0, height: 4)
                                .animation(.easeInOut(duration: 0.3), value: currentStep)
                        }
                    }
                    .frame(height: 4)
                    .padding(.top, 50)
                }
                
                Spacer()
            }

            if isCalculating {
                VStack(spacing: 20) {
                    ProgressView("Calculating your results…")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Hang tight while we check your eligibility.")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .opacity(0.8)
                }
            } else {
                GeometryReader { geometry in
                    ZStack {
                        Group {
                            switch currentStep {
                            case 0: introScreen
                            case 1: classActionScreen
                            case 2: billionScreen
                            case 3: newSettlementsScreen
                            case 4: notificationScreen
                            case 5: noproofScreen
                            case 6: numberOneScreen
                            case 7: owedScreen
                            case 8: brandSelectionScreen
                            case 9: payoutScreen
                            case 10: calculatingScreen
                            case 11: amountAnimationScreen
                            case 12: missedOutScreen
                            case 13: loadingScreen
                            default: introScreen
                            }
                        }
                        .frame(width: geometry.size.width)
                        .offset(x: slideOffset)
                    }
                }
            }
        }
        .sheet(isPresented: $showingSafari) {
            if let url = safariURL {
                SafariView(url: url)
            }
        }
    }

    // MARK: - Haptic Feedback
    private func triggerHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    // MARK: - Screens

    private var introScreen: some View {
        VStack {
            Spacer()
            Text("Claimed")
                .font(.system(size: 64, weight: .bold))
                .italic()
                .foregroundColor(.white)
            Text("make them pay")
                .font(Font.custom("Inter", size: 16))
                .foregroundColor(.white)
                .frame(width: 116, height: 18, alignment: .topLeading)
            Spacer()
            
            VStack(spacing: 16) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 352, height: 82)
                    .background(.white)
                    .cornerRadius(20)
                    .overlay(
                        Text("Get Started")
                            .font(.system(size: 24, weight: .bold))
                            .italic()
                            .foregroundColor(Color(red: 0.02, green: 0.24, blue: 0.71))
                    )
                    .onTapGesture {
                        triggerHaptic()
                        nextStep()
                    }
                
                VStack(spacing: 4) {
                    Text("By continuing you agree to our")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.3))
                    
                    HStack(spacing: 4) {
                        Button(action: {
                            safariURL = URL(string: "https://claimedmoney.app/terms-of-service")
                            showingSafari = true
                        }) {
                            Text("Terms of Use")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.3))
                                .underline()
                        }
                        
                        Text("and")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Button(action: {
                            safariURL = URL(string: "https://claimedmoney.app/privacy-policy")
                            showingSafari = true
                        }) {
                            Text("Privacy Policy")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.3))
                                .underline()
                        }
                    }
                }
                .multilineTextAlignment(.center)
            }
            .padding(.bottom, 60)
        }
        .frame(width: 393, height: 852)
    }

    private var classActionScreen: some View {
        VStack {
            Spacer()
            Text("👩‍⚖️")
                .font(.system(size: 96, weight: .bold))
                .italic()
                .foregroundColor(.white)
            VStack(spacing: -20) {
                Text("Class action")
                    .font(.system(size: 48, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                Text("settlements")
                    .font(.system(size: 48, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            Text("Are funds that companies set aside to give back to customers when they're found to have acted unfairly or broken the law.")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 373)
                .padding(.top, 12)
            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(Text("Next")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black))
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }

    private var billionScreen: some View {
        VStack {
            Spacer()
            Text("Last year, \ncustomers like you missed out on")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 373)
            Text("💵")
                .font(.system(size: 96, weight: .bold))
                .italic()
                .foregroundColor(.white)
            Text("$1.4 Billion")
                .font(.system(size: 48, weight: .bold))
                .italic()
                .foregroundColor(.white)
            Text("in settlement money.\n Most people never claim it.")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 373)
                .padding(.top, 10)
            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(Text("Next")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black))
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }
    
    private var newSettlementsScreen: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    logoBox(imageName: "Poppi")
                    logoBox(imageName: "Pepsi")
                    logoBox(imageName: "Fortnite")
                }
                HStack(spacing: 20) {
                    logoBox(imageName: "Tiktok")
                    logoBox(imageName: "Apple")
                }
            }
            .padding(.bottom, 20)
            VStack(spacing: -10) {
                Text("New settlements")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                Text("drop every week")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            Text("Meta, Apple, TikTok, Google, Pepsi, and more often pay penalties for misleading customers. Claim finds and organizes these opportunities for you every week.")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 373)
                .padding(.top, 10)
            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(Text("Next")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black))
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }

    private var notificationScreen: some View {
        VStack {
            Spacer()
            Image("NotificationIllustration")
                .resizable()
                .scaledToFit()
                .frame(width: 314, height: 295)
                .padding(.top, -100)
            VStack(spacing: -10) {
                Text("We track everything")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                Text("you just tap \"claim\"")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
            .frame(width: 430)
            Text("When a new settlement opens, we'll let you know. If you're eligible, you can use Claim for easy filing and skip the paperwork.")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 355)
                .padding(.top, 12)
            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(Text("Next")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black))
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }

    private var noproofScreen: some View {
        VStack {
            Spacer()
            TikTokCard()
            VStack(spacing: -10) {
                Text("No proof?")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                Text("Still eligible!")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
            .frame(width: 430)
            Text("You can still file a claim if you lost your receipt. If something requires proof, we'll let you know before you file.")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 355)
                .padding(.top, 12)
            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(Text("Next")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black))
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }

    private var numberOneScreen: some View {
        VStack {
            Spacer()
            Text("Class Action\nSettlement App")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 373, alignment: .top)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            VStack(spacing: -10) {
                Text("#1")
                    .font(.system(size: 96, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
            .frame(width: 386)
            Text("⭐ ⭐ ⭐ ⭐ ⭐")
                .font(Font.custom("Inter", size: 48))
                .foregroundColor(.white)
                .padding(.top, -9)
            Text("Trusted by thousands of users")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 373, alignment: .top)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 16)
            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(
                    Text("Next")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                )
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }
    
    private var owedScreen: some View {
        VStack {
            Spacer()
            Text("On average you are\nactually owed")
                .font(.system(size: 16, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom, -30)

            Text("$\(animatedAmount)")
                .font(.system(size: 96, weight: .bold))
                .italic()
                .foregroundColor(.white)
                .padding(.top, 60)
                .onAppear {
                    animatedAmount = 0
                    Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                        if animatedAmount < 428 {
                            animatedAmount += 1
                        } else {
                            timer.invalidate()
                        }
                    }
                }

            OwedCard()
                .padding(.bottom, -140)

            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(
                    Text("Find my Claims")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                )
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }

    private var brandSelectionScreen: some View {
        VStack {
            Spacer().frame(height: 80)

            VStack(spacing: -10) {
                Text("What brands have")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)

                Text("you purchased from")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)

                Text("in the last year")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
            .frame(width: 430)

            Text("Pick the ones you haven't claimed\n money from yet")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.85))
                .padding(.top, 20)

            Spacer().frame(height: 20)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(brands, id: \.self) { brand in
                    BrandCard(
                        imageName: brand,
                        isSelected: selectedBrands.contains(brand)
                    )
                    .onTapGesture {
                        triggerHaptic()
                        toggleSelection(for: brand)
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(
                    Text("Next Up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                )
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    print("Selected brands: \(selectedBrands)")
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }

    private var payoutScreen: some View {
        VStack {
            Spacer()
            VStack(spacing: -10) {
                Text("How would you like")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                Text("to recieve payouts?")
                    .font(.system(size: 36, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
            .frame(width: 430)

            Text("This will be your default payout method for all claims")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.85))
                .padding(.top, 2)

            Spacer()
            VStack(spacing: 16) {
                PayoutButton(label: "Credit Card", isSelected: selectedPayout == "Credit Card")
                    .onTapGesture {
                        triggerHaptic()
                        selectedPayout = "Credit Card"
                    }
                PayoutButton(label: "Debit Card", isSelected: selectedPayout == "Debit Card")
                    .onTapGesture {
                        triggerHaptic()
                        selectedPayout = "Debit Card"
                    }
                PayoutButton(label: "Zelle", isSelected: selectedPayout == "Zelle")
                    .onTapGesture {
                        triggerHaptic()
                        selectedPayout = "Zelle"
                    }
                PayoutButton(label: "Venmo", isSelected: selectedPayout == "Venmo")
                    .onTapGesture {
                        triggerHaptic()
                        selectedPayout = "Venmo"
                    }
            }

            Spacer().frame(height: 120)

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(
                    Text("Next Up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                )
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }
    
    private var missedOutScreen: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 200)
            Text("💸")
                .font(.system(size: 96))
                .padding(.bottom, 10)
            VStack(spacing: -10) {
                Text("Based on your answers")
                    .font(.system(size: 28, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                Text("you missing out on...")
                    .font(.system(size: 28, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
            .frame(width: 430)

            Text("$240")
                .font(.system(size: 58, weight: .bold))
                .italic()
                .foregroundColor(.white)
                .padding(.top, 6)

            Text("This is an approximation based on the average payouts from past class action settlements")
                .font(Font.custom("Inter", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.85))
                .frame(width: 355, alignment: .center)
                .padding(.top, 12)

            Spacer()

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 352, height: 82)
                .background(.white)
                .cornerRadius(20)
                .overlay(
                    Text("Next Up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                )
                .padding(.bottom, 110)
                .onTapGesture {
                    triggerHaptic()
                    nextStep()
                }
        }
        .frame(width: 393, height: 852)
    }

    // MARK: - Calculating Screen
    private var calculatingScreen: some View {
        CalculatingScreen(currentStep: $currentStep)
    }
    
    // MARK: - Amount Animation Screen
    private var amountAnimationScreen: some View {
        AmountAnimationScreen()
    }

   

    // MARK: - Loading Screen
    private var loadingScreen: some View {
        LoadingScreen()
    }

    // MARK: - Data for Brand Selection
    private let brands = [
        "pur1", "pur2", "pur3",
        "pur4", "pur5", "pur6",
        "pur7", "pur8", "pur9"
    ]

    // MARK: - Selection Logic
    private func toggleSelection(for brand: String) {
        if selectedBrands.contains(brand) {
            selectedBrands.remove(brand)
        } else {
            selectedBrands.insert(brand)
        }
    }

    // MARK: - Controls
    private func nextStep() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            slideOffset = -UIScreen.main.bounds.width
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if currentStep < 13 {
                currentStep += 1
            } else {
                startCalculating()
            }
            slideOffset = UIScreen.main.bounds.width
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                slideOffset = 0
            }
        }
    }

    private func finishFlow() { startCalculating() }

    private func startCalculating() {
        isCalculating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            triggerFinalStep()
        }
    }

    private func triggerFinalStep() {
        if clickedPaywall == false {
            Superwall.shared.register(placement: "campaign_trigger")
            clickedPaywall.toggle()
       
        }
        }

    }


// MARK: - AmountAnimationScreen View
// MARK: - AmountAnimationScreen View
struct AmountAnimationScreen: View {
    @State private var animatedAmount: Double = 120.0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.01, green: 0.32, blue: 1), location: 0.00),
                    .init(color: Color(red: 0.00, green: 0.32, blue: 1), location: 0.19),
                    .init(color: Color(red: 0.03, green: 0.34, blue: 1), location: 0.51),
                    .init(color: Color(red: 0.02, green: 0.23, blue: 0.68), location: 0.91),
                    .init(color: Color(red: 0.02, green: 0.11, blue: 0.35), location: 1.00)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 💸 Emoji
                Text("💸")
                    .font(.system(size: 96, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                
                // Animated amount
                Text("$\(String(format: "%.1f", animatedAmount))M")
                    .font(.system(size: 80, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                    .padding(.top, 12)
                
                // Subtitle
                Text("Brands you selected are estimated to pay\nthis much out to Class Actions")
                    .font(Font.custom("Inter", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 373)
                    .padding(.top, 12)
                
                Spacer()
                
                // Claim My Cash button
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 352, height: 82)
                    .background(.white)
                    .cornerRadius(20)
                    .overlay(
                        Text("Claim My Cash")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                    )
                    .padding(.bottom, 110)
                    .onTapGesture {
                        Superwall.shared.register(placement: "campaign_trigger")

                    }
            }
            .frame(width: 393, height: 852)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Animate from 120 to 360.2 over ~2 seconds
        let targetAmount = 360.2
        let duration = 2.0
        let steps = 100
        let increment = (targetAmount - animatedAmount) / Double(steps)
        let timePerStep = duration / Double(steps)
        
        Timer.scheduledTimer(withTimeInterval: timePerStep, repeats: true) { timer in
            if animatedAmount < targetAmount {
                animatedAmount += increment
                if animatedAmount > targetAmount {
                    animatedAmount = targetAmount
                }
            } else {
                timer.invalidate()
            }
        }
    }
}


// MARK: - CalculatingScreen View
struct CalculatingScreen: View {
    @State private var progress: CGFloat = 0.0
    @State private var percentage: Int = 0
    @State private var showNextButton: Bool = false
    @Binding var currentStep: Int
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.01, green: 0.32, blue: 1), location: 0.00),
                    .init(color: Color(red: 0.00, green: 0.32, blue: 1), location: 0.19),
                    .init(color: Color(red: 0.03, green: 0.34, blue: 1), location: 0.51),
                    .init(color: Color(red: 0.02, green: 0.23, blue: 0.68), location: 0.91),
                    .init(color: Color(red: 0.02, green: 0.11, blue: 0.35), location: 1.00)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Circular progress indicator
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 12)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(percentage)%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Title
                Text("Calculating")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                // Subtitle (changes based on percentage)
                Text(subtitleText)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Next button (appears when 100%)
                if showNextButton {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 352, height: 82)
                        .background(.white)
                        .cornerRadius(20)
                        .overlay(
                            Text("Next")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                        )
                        .padding(.bottom, 110)
                        .onTapGesture {
                            currentStep = 11
                        }
                        .transition(.opacity)
                }
            }
        }
        .onAppear {
            startCalculating()
        }
    }
    
    private var subtitleText: String {
        if percentage <= 45 {
            return "Finding Your Money"
        } else if percentage <= 80 {
            return "Profile matching"
        } else {
            return "Results preparation"
        }
    }
    
    private func startCalculating() {
        // 7 seconds total / 100 steps = 0.07 seconds per step
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if percentage < 100 {
                percentage += 1
                progress = CGFloat(percentage) / 100.0
            } else {
                timer.invalidate()
                withAnimation {
                    showNextButton = true
                }
            }
        }
    }
}

// MARK: - LoadingScreen View
struct LoadingScreen: View {
    @State private var progress: CGFloat = 0.0
    @State private var percentage: Int = 0
    @State private var completedSteps: Int = 0
    
    private let steps = [
        "Settlement eligibility",
        "Profile matching",
        "Claim calculations",
        "Results preparation",
        "Account setup"
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.01, green: 0.32, blue: 1), location: 0.00),
                    .init(color: Color(red: 0.00, green: 0.32, blue: 1), location: 0.19),
                    .init(color: Color(red: 0.03, green: 0.34, blue: 1), location: 0.51),
                    .init(color: Color(red: 0.02, green: 0.23, blue: 0.68), location: 0.91),
                    .init(color: Color(red: 0.02, green: 0.11, blue: 0.35), location: 1.00)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                // Static coin
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                
                // Percentage (animated)
                Text("\(percentage)%")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(.white)
                
                // Subtitles
                Text("Finding Your Money")
                    .font(.system(size: 24, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
                Text("Searching through thousands of settlements")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: geometry.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 32)
                .padding(.top, 8)
                
                // Checklist
                VStack(alignment: .leading, spacing: 16) {
                    Text("Setting up your account")
                        .font(.system(size: 20, weight: .bold))
                        .italic()
                        .foregroundColor(.white)
                    
                    ForEach(0..<steps.count, id: \.self) { index in
                        HStack {
                            Text(steps[index])
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            if index < completedSteps {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
        }
        .onAppear {
            startLoading()
        }
    }
    
    private func startLoading() {
        // Increment percentage smoothly
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if percentage < 100 {
                percentage += 1
                progress = CGFloat(percentage) / 100.0
                
                // Reveal steps as percentage grows
                if percentage == 20 { completedSteps = 1 }
                if percentage == 40 { completedSteps = 2 }
                if percentage == 60 { completedSteps = 3 }
                if percentage == 80 { completedSteps = 4 }
                if percentage == 100 { completedSteps = 5 }
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Components
struct logoBox: View {
    let imageName: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.26))
                .frame(width: 92, height: 86)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.32), lineWidth: 0.5)
                )
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 75, height: 71)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                )
        }
    }
}

struct TikTokCard: View {
    var body: some View {
        HStack(spacing: 12) {
            Image("TiktokLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("TikTok")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Text("No proof")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 79, height: 26)
                        .background(Color(red: 0, green: 0.75, blue: 0))
                        .cornerRadius(20)
                        .padding(.top, -9)
                }
                Text("Claim by Aug 10th 2023")
                    .font(Font.custom("Inter", size: 14))
                    .tracking(0.42)
                    .foregroundColor(Color.white.opacity(0.72))
            }
            Spacer()
        }
        .padding(12)
        .frame(width: 352, height: 91)
        .background(Color.white.opacity(0.19))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.5), lineWidth: 0.5)
        )
    }
}

struct OwedCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("igpic")
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Donna L.")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("★★★★★")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.yellow)
                }
                Text("Claimed $41 last month")
                    .font(Font.custom("Inter", size: 14))
                    .foregroundColor(Color.white.opacity(0.76))
                Text("\"It's like finding money in your pocket every month!\"")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(16)
        .frame(width: 352)
        .background(Color.white.opacity(0.19))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.46), lineWidth: 0.5)
        )
    }
}

struct PayoutButton: View {
    let label: String
    let isSelected: Bool
    
    var body: some View {
        Text(label)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 352, height: 56)
            .background(isSelected ? Color.white.opacity(0.35) : Color.white.opacity(0.16))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.white : Color.white.opacity(0.4), lineWidth: isSelected ? 2 : 1)
            )
    }
}

struct BrandCard: View {
    let imageName: String
    let isSelected: Bool

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(height: 90)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.6), lineWidth: isSelected ? 3 : 0)
            )
    }
}

// MARK: - Safari View Wrapper
struct OnboardingSafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No update needed
    }
}

#Preview {
    OnboardingFlow()
}
