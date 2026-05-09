import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showRegistration = false

    var formIsReady: Bool { !email.isEmpty && password.count >= 6 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.top, 48)
                        .padding(.bottom, 36)

                    formSection
                        .padding(.horizontal, 24)

                    dividerSection
                        .padding(.vertical, 24)
                        .padding(.horizontal, 24)

                    registerSection
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
            .background(Color.veroBackground)
            .onTapGesture { hideKeyboard() }
        }
        .fullScreenCover(isPresented: $showRegistration) {
            ConsultantRegistrationView()
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [Color.veroPrimary, Color.veroGradientEnd],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 110, height: 110)
                    .shadow(color: Color.veroPrimary.opacity(0.35), radius: 16, x: 0, y: 8)

                VStack(spacing: 2) {
                    Text("VERO")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("COSMÉTICOS")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.85))
                        .tracking(4)
                }
            }

            VStack(spacing: 6) {
                Text("Bem-vinda de volta!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.veroText)
                Text("Acesse sua conta de consultora")
                    .font(.subheadline)
                    .foregroundColor(.veroSubtext)
            }
        }
    }

    // MARK: - Form
    private var formSection: some View {
        VStack(spacing: 16) {
            VeroTextField(
                title: "E-mail",
                placeholder: "seu@email.com",
                text: $email,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )

            VeroTextField(
                title: "Senha",
                placeholder: "Mínimo 6 caracteres",
                text: $password,
                isSecure: !showPassword,
                autocapitalization: .never,
                trailingIcon: showPassword ? "eye.slash" : "eye",
                onTrailingIconTap: { showPassword.toggle() }
            )

            Button("Esqueci minha senha") {}
                .font(.caption)
                .foregroundColor(.veroPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)

            if let err = authVM.errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(err)
                }
                .font(.caption)
                .foregroundColor(.veroError)
                .padding(10)
                .background(Color.veroError.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VeroButton(
                title: "Entrar",
                icon: "arrow.right.circle.fill",
                isLoading: authVM.isLoading,
                isEnabled: formIsReady
            ) {
                Task { await authVM.login(email: email, password: password) }
            }
        }
    }

    // MARK: - Divider
    private var dividerSection: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color.veroBorder).frame(height: 1)
            Text("ou").font(.caption).foregroundColor(.veroSubtext)
            Rectangle().fill(Color.veroBorder).frame(height: 1)
        }
    }

    // MARK: - Register
    private var registerSection: some View {
        VStack(spacing: 12) {
            VeroButton(
                title: "Quero ser consultora Vero",
                icon: "star.fill",
                style: .outline
            ) {
                showRegistration = true
            }

            Text("Comece sua jornada e transforme sua vida!")
                .font(.caption)
                .foregroundColor(.veroSubtext)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
