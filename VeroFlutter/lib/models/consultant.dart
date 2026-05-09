import 'address.dart';

enum ConsultantStatus {
  pending('PENDENTE'),
  active('ATIVO'),
  inactive('INATIVO'),
  suspended('SUSPENSO');

  final String label;
  const ConsultantStatus(this.label);
}

class Consultant {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final String phone;
  final ConsultantStatus status;
  final DateTime registrationDate;
  final String? sponsorCode;
  final Address address;
  final String consultantCode;

  const Consultant({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.phone,
    required this.status,
    required this.registrationDate,
    this.sponsorCode,
    required this.address,
    required this.consultantCode,
  });

  String get firstName => name.split(' ').first;
}
