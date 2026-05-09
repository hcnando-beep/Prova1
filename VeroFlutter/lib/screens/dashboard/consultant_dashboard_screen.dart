import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/consultant.dart';
import '../../providers/auth_provider.dart';
import '../../theme/vero_theme.dart';
import '../login_screen.dart';

class ConsultantDashboardScreen extends StatelessWidget {
  const ConsultantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final c = auth.consultant!;

    return Scaffold(
      backgroundColor: VeroColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Vero Consultora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: VeroColors.error,
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: VeroColors.primary,
        onRefresh: () async => await Future.delayed(const Duration(milliseconds: 800)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _headerCard(c),
            const SizedBox(height: 16),
            _kpiGrid(),
            const SizedBox(height: 20),
            _quickActions(context),
            const SizedBox(height: 20),
            _recentOrders(),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  Widget _headerCard(Consultant c) {
    final dateF = DateFormat('MMMM yyyy', 'pt_BR');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: VeroColors.primary.withOpacity(0.08),
              blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [VeroColors.gradientStart, VeroColors.gradientEnd],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: Center(child: Text(c.firstName[0].toUpperCase(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Olá, ${c.firstName}!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: VeroColors.text)),
          const SizedBox(height: 4),
          Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.status == ConsultantStatus.active ? VeroColors.success : VeroColors.secondary)),
            const SizedBox(width: 6),
            Text(c.consultantCode,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                    color: VeroColors.primary)),
            const Text(' · ', style: TextStyle(color: VeroColors.subtext)),
            Text(c.status.label,
                style: const TextStyle(fontSize: 12, color: VeroColors.subtext)),
          ]),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(dateF.format(DateTime.now()),
              style: const TextStyle(fontSize: 11, color: VeroColors.subtext)),
          const SizedBox(height: 4),
          const Icon(Icons.notifications_outlined, color: VeroColors.primary, size: 20),
        ]),
      ]),
    );
  }

  Widget _kpiGrid() {
    const kpis = [
      _KPI('Vendas do Mês', 'R\$ 1.240', Icons.trending_up, VeroColors.primary, '+12%'),
      _KPI('Pontuação', '4.850 pts', Icons.star_rounded, VeroColors.secondary, '+320'),
      _KPI('Clientes', '23', Icons.people_alt_outlined, VeroColors.success, '+3'),
      _KPI('Minha Rede', '7', Icons.hub_outlined, Color(0xFF5B21B6), '+1'),
    ];
    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6,
      children: kpis.map((k) => _kpiCard(k)).toList(),
    );
  }

  Widget _kpiCard(_KPI k) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: k.color.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(k.icon, color: k.color, size: 18),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: VeroColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20)),
          child: Text(k.trend, style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: VeroColors.success)),
        ),
      ]),
      const Spacer(),
      Text(k.value, style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: VeroColors.text)),
      Text(k.title, style: const TextStyle(fontSize: 11, color: VeroColors.subtext)),
    ]),
  );

  Widget _quickActions(BuildContext context) {
    const actions = [
      _Action('Novo Pedido',   Icons.add_shopping_cart, VeroColors.primary),
      _Action('Catálogo',      Icons.menu_book_rounded,  VeroColors.secondary),
      _Action('Minha Rede',   Icons.people_alt_rounded,  Color(0xFF5B21B6)),
      _Action('Relatórios',   Icons.bar_chart_rounded,   VeroColors.success),
      _Action('Clientes',     Icons.contacts_rounded,    Color(0xFF0369A1)),
      _Action('Treinamentos', Icons.school_rounded,      Color(0xFFBE185D)),
      _Action('Promoções',    Icons.local_offer_rounded,  VeroColors.secondary),
      _Action('Suporte',      Icons.headset_mic_rounded,  VeroColors.primary),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Ações Rápidas',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: VeroColors.text)),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 4, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10, mainAxisSpacing: 12, childAspectRatio: 0.85,
        children: actions.map((a) => _actionButton(a)).toList(),
      ),
    ]);
  }

  Widget _actionButton(_Action a) => GestureDetector(
    onTap: () {},
    child: Column(children: [
      Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
            color: a.color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
        child: Icon(a.icon, color: a.color, size: 24),
      ),
      const SizedBox(height: 6),
      Text(a.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
          color: VeroColors.text), textAlign: TextAlign.center, maxLines: 2),
    ]),
  );

  Widget _recentOrders() {
    const orders = [
      _Order('Ana Souza',     '09/05/2026', 'R\$ 185,00', 'Entregue',      VeroColors.success),
      _Order('Carla Mendes',  '07/05/2026', 'R\$ 342,00', 'Em andamento',  VeroColors.secondary),
      _Order('Juliana Costa', '05/05/2026', 'R\$ 97,00',  'Entregue',      VeroColors.success),
      _Order('Fernanda Lima', '02/05/2026', 'R\$ 210,00', 'Cancelado',     VeroColors.error),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Últimos Pedidos',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: VeroColors.text)),
        TextButton(onPressed: () {},
            child: const Text('Ver todos', style: TextStyle(color: VeroColors.primary, fontSize: 12))),
      ]),
      const SizedBox(height: 8),
      ...orders.map((o) => _orderRow(o)),
    ]);
  }

  Widget _orderRow(_Order o) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: VeroColors.primary.withOpacity(0.06),
            blurRadius: 6, offset: const Offset(0, 2))]),
    child: Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
            color: VeroColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.shopping_bag_outlined, color: VeroColors.primary, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(o.client, style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500, color: VeroColors.text)),
        Text(o.date, style: const TextStyle(fontSize: 11, color: VeroColors.subtext)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(o.value, style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: VeroColors.text)),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
              color: o.statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
          child: Text(o.status, style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: o.statusColor)),
        ),
      ]),
    ]),
  );

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text('Você precisará fazer login novamente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Sair', style: TextStyle(color: VeroColors.error)),
          ),
        ],
      ),
    );
  }
}

class _KPI { final String title, value, trend; final IconData icon; final Color color;
  const _KPI(this.title, this.value, this.icon, this.color, this.trend); }
class _Action { final String label; final IconData icon; final Color color;
  const _Action(this.label, this.icon, this.color); }
class _Order { final String client, date, value, status; final Color statusColor;
  const _Order(this.client, this.date, this.value, this.status, this.statusColor); }
