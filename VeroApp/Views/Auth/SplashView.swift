import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.55
    @State private var opacity: Double = 0
    @State private var taglineOpacity: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.veroGradientStart, Color.veroGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.14))
                        .frame(width: 140, height: 140)

                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                        .frame(width: 140, height: 140)

                    VStack(spacing: 2) {
                        Text("VERO")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("COSMÉTICOS")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.85))
                            .tracking(5)
                    }
                }
                .scaleEffect(scale)
                .opacity(opacity)

                VStack(spacing: 6) {
                    Text("Beleza que transforma vidas")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    Text("Para consultoras que fazem a diferença")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))
                }
                .opacity(taglineOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.75, dampingFraction: 0.65)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.6).delay(0.55)) {
                taglineOpacity = 1.0
            }
        }
    }
}

#Preview { SplashView() }
