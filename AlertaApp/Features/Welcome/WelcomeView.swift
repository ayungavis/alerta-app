import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Color("backgroundPrimary")
                .ignoresSafeArea()

            Circle()
                .fill(Color("primary").opacity(0.2))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: -136, y: -200)

            Circle()
                .fill(Color("primaryDark").opacity(0.5))
                .frame(width: 256, height: 256)
                .blur(radius: 50)
                .opacity(0.2)
                .offset(x: 100, y: UIScreen.main.bounds.height / 2 - 150)

            VStack(spacing: 0) {
                Spacer()

                Text("Welcome to")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundStyle(Color("primary"))

                Text("ALERTA")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(Color("primary"))
                    .padding(.top, 4)

                AudioBarsView()
                    .padding(.top, 24)

                Text("Stay alert. Stay safe.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("primary"))
                    .padding(.top, 24)

                Text("We detect important environmental sounds and instantly notify you about potential danger nearby.")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundStyle(Color("secondary"))
                    .multilineTextAlignment(.center)
                    .frame(width: 297)
                    .padding(.top, 16)

                Spacer()

                NavigationLink {
                    AwarenessView()
                } label: {
                    Text("LET\u{2019}S ROCK!")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("buttonText"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color("buttonDefault"))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
