import SwiftUI

struct ConsultantDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showLogoutAlert = false

    private var consultant: Consultant { authVM.currentConsultant! }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerCard
                    kpiCards
                    quickActionsGrid
                    recentOrdersSection
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.veroBackground)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showLogoutAlert = true }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.veroPrimary)
                    }
                }
            }
            .alert("Sair da conta?", isPresented: $showLogoutAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Sair", role: .destructive) { authVM.logout() }
            } message: {
                Text("Você precisará fazer login novamente.")
            }
        }
    }

    // MARK: - Header
    private var headerCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [Color.veroPrimary, Color.veroGradientEnd],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 58, height: 58)
                Text(String(consultant.firstName.prefix(1)))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Olá, \(consultant.firstName)!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.veroText)
                HStack(spacing: 6) {
                    statusDot(consultant.status)
                    Text(consultant.status.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.veroSubtext)
                    Text("•")
                        .foregroundColor(.veroSubtext)
                    Text(consultant.consultantCode)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.veroPrimary)
                }
            }

            Spacer()

            Image(systemName: "bell.badge")
                .font(.title3)
                .foregroundColor(.veroPrimary)
        }
        .padding(16)
        .veroCard()
    }

    private func statusDot(_ status: Consultant.ConsultantStatus) -> some View {
        Circle()
            .fill(status == .active ? Color.veroSuccess : Color.veroSecondary)
            .frame(width: 7, height: 7)
    }

    // MARK: - KPI Cards
    private var kpiCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            kpiCard(title: "Vendas do Mês", value: "R$ 1.240,00", icon: "chart.line.uptrend.xyaxis", color: .veroPrimary, trend: "+12%")
            kpiCard(title: "Pontuação", value: "4.850 pts", icon: "star.fill", color: .veroSecondary, trend: "+320 pts")
            kpiCard(title: "Clientes Ativos", value: "23", icon: "person.2.fill", color: .veroSuccess, trend: "+3")
            kpiCard(title: "Rede de Consultoras", value: "7", icon: "network", color: Color(red: 0.35, green: 0.18, blue: 0.78), trend: "+1")
        }
    }

    private func kpiCard(title: String, value: String, icon: String, color: Color, trend: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(color)
                Spacer()
                Text(trend)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.veroSuccess)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.veroSuccess.opacity(0.12))
                    .clipShape(Capsule())
            }
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.veroText)
            Text(title)
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(14)
        .veroCard()
    }

    // MARK: - Quick Actions
    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ações Rápidas")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.veroText)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(quickActions, id: \.label) { action in
                    quickActionButton(action)
                }
            }
        }
    }

    private func quickActionButton(_ action: QuickAction) -> some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(action.color.opacity(0.12))
                        .frame(width: 52, height: 52)
                    Image(systemName: action.icon)
                        .font(.title3)
                        .foregroundColor(action.color)
                }
                Text(action.label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.veroText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
    }

    private struct QuickAction {
        let label: String; let icon: String; let color: Color
    }

    private let quickActions: [QuickAction] = [
        QuickAction(label: "Novo Pedido",   icon: "cart.badge.plus",         color: .veroPrimary),
        QuickAction(label: "Catálogo",      icon: "book.fill",                color: .veroSecondary),
        QuickAction(label: "Minha Rede",    icon: "person.3.fill",            color: Color(red: 0.35, green: 0.18, blue: 0.78)),
        QuickAction(label: "Relatórios",    icon: "chart.bar.fill",           color: .veroSuccess),
        QuickAction(label: "Clientes",      icon: "person.crop.circle.fill",  color: Color(red: 0.14, green: 0.55, blue: 0.80)),
        QuickAction(label: "Treinamentos",  icon: "graduationcap.fill",       color: Color(red: 0.82, green: 0.28, blue: 0.52)),
        QuickAction(label: "Promoções",     icon: "tag.fill",                 color: .veroSecondary),
        QuickAction(label: "Suporte",       icon: "headphones",               color: .veroPrimary),
    ]

    // MARK: - Recent Orders
    private var recentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Últimos Pedidos")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.veroText)
                Spacer()
                Button("Ver todos") {}
                    .font(.caption)
                    .foregroundColor(.veroPrimary)
            }

            VStack(spacing: 8) {
                ForEach(sampleOrders, id: \.id) { order in
                    orderRow(order)
                }
            }
        }
    }

    private func orderRow(_ order: SampleOrder) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.veroPrimary.opacity(0.08))
                    .frame(width: 42, height: 42)
                Image(systemName: "bag.fill")
                    .font(.subheadline)
                    .foregroundColor(.veroPrimary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(order.client)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.veroText)
                Text(order.date)
                    .font(.caption)
                    .foregroundColor(.veroSubtext)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(order.value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.veroText)
                Text(order.status)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(order.statusColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(order.statusColor.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .padding(12)
        .veroCard()
    }

    private struct SampleOrder: Identifiable {
        let id = UUID()
        let client: String; let date: String; let value: String
        let status: String; let statusColor: Color
    }

    private let sampleOrders = [
        SampleOrder(client: "Ana Souza",      date: "09/05/2026", value: "R$ 185,00", status: "Entregue",   statusColor: .veroSuccess),
        SampleOrder(client: "Carla Mendes",   date: "07/05/2026", value: "R$ 342,00", status: "Em andamento", statusColor: .veroSecondary),
        SampleOrder(client: "Juliana Costa",  date: "05/05/2026", value: "R$ 97,00",  status: "Entregue",   statusColor: .veroSuccess),
        SampleOrder(client: "Fernanda Lima",  date: "02/05/2026", value: "R$ 210,00", status: "Cancelado",  statusColor: .veroError),
    ]
}

#Preview {
    ConsultantDashboardView().environmentObject({
        let vm = AuthViewModel()
        vm.currentConsultant = Consultant(
            id: "1", name: "Maria Silva", email: "maria@email.com",
            cpf: "000.000.000-00", phone: "(11) 99999-9999",
            status: .active, registrationDate: Date(),
            sponsorCode: nil,
            address: Address(zipCode: "01310-100", street: "Av. Paulista", number: "1000",
                             complement: "", neighborhood: "Bela Vista", city: "São Paulo", state: "SP"),
            consultantCode: "VR-123456"
        )
        return vm
    }())
}
