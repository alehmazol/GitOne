//
//  OnboardingView.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage(wrappedValue: false, "isPresentedOnboarding") private var isPresentedOnboarding
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showTabComponents = Array(repeating: false, count: 4)
    let horizontalSizeClass: UserInterfaceSizeClass?
    let continueText = String(localized: "Continue", defaultValue: "Continue")
    
    var body: some View {
        VStack(alignment: .center) {
            ForEach(showTabComponents.startIndex..<showTabComponents.endIndex,
                    id: \ .self) { index in
                if showTabComponents[index] == true,
                   index <= 2 {
                    getComponentForIndex(index: index)
                }
            }
        }
        .onboardingVStackStyling()
        .overlay(alignment: .bottom) {
            if showTabComponents[3] == true {
                getComponentForIndex(index: 3)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(350))
            animateSeuqentially()
        }
    }
}

#Preview {
    OnboardingView(horizontalSizeClass: .regular)
}

private extension OnboardingView {
    var appImage: some View {
        Image(.app)
            .resizable()
            .scaledToFit()
            .frame(width: 88 * (horizontalSizeClass == .compact ? 1.0 : 1.36),
                   height: 88 * (horizontalSizeClass == .compact ? 1.0 : 1.36),
                   alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: horizontalSizeClass == .compact ? 20 : 28,
                                        style: .continuous))
            .shadow(color: Color(.launchScreen),
                    radius: 24, x: 4, y: 4)
            .transition(.scale(scale: 0.65, anchor: .center).combined(with: .opacity))
    }
    
    var appTitle: some View {
        Text("Git One")
            .font(.system(size: horizontalSizeClass == .compact ? 32 : 44,
                          weight: .heavy,
                          design: .default).lowercaseSmallCaps().leading(.loose))
            .kerning(2)
            .foregroundStyle(Color.primary)
            .multilineTextAlignment(.center)
            .transition(.opacity.combined(with: .push(from: .bottom)))
    }
    
    var appDescription: some View {
        Text(String(localized: "Trending projects",
                    defaultValue: "Trending projects"))
            .font(.system(size: horizontalSizeClass == .compact ? 24 : 36,
                          weight: .bold).leading(.loose))
            .foregroundStyle(Color.secondary)
            .multilineTextAlignment(.center)
            .transition(.opacity.combined(with: .push(from: .bottom)))
    }
    
    var continueButton: some View {
        Button {
            isPresentedOnboarding = true
            dismiss()
        } label: {
            Text(continueText)
                .fontWeight(.semibold)
                .frame(height: horizontalSizeClass == .compact ? 28 : 32)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 12))
        .padding(horizontalSizeClass == .compact ? 32 : 48)
        .transition(.opacity.combined(with: .push(from: .bottom)))
    }
}

//: MARK: - EXTENSION HELPER FUNCTIONS
private extension OnboardingView {
    @ViewBuilder
    func getComponentForIndex(index: Int) -> some View {
        switch index {
            case 0:
                appImage
            case 1:
                appTitle
            case 2:
                appDescription
            case 3:
                continueButton
            default:
                EmptyView()
        }
    }
    
    func animateSeuqentially() {
        let delayInterval = 0.75 / Double(showTabComponents.count)
        for index in showTabComponents.startIndex..<showTabComponents.endIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index) * delayInterval)) {
                withAnimation(.smooth) {
                    showTabComponents[index] = true
                }
            }
        }
    }
}
