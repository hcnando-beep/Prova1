import '../models/consultant.dart';
import '../models/address.dart';
import '../providers/registration_provider.dart';

abstract class ApiService {
  static Future<Consultant> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (password.length < 6) throw Exception('Email ou senha inválidos.');

    return Consultant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Consultora Vero',
      email: email,
      cpf: '000.000.000-00',
      phone: '(11) 99999-9999',
      status: ConsultantStatus.active,
      registrationDate: DateTime.now().subtract(const Duration(days: 180)),
      address: const Address(
        zipCode: '01310-100', street: 'Av. Paulista', number: '1000',
        neighborhood: 'Bela Vista', city: 'São Paulo', state: 'SP',
      ),
      consultantCode: 'VR-123456',
    );
  }

  static Future<Consultant> registerConsultant(RegistrationProvider reg) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final code = 'VR-${100000 + (DateTime.now().microsecond % 900000)}';

    return Consultant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: reg.fullName,
      email: reg.email,
      cpf: reg.cpf,
      phone: reg.phone,
      status: ConsultantStatus.pending,
      registrationDate: DateTime.now(),
      sponsorCode: reg.sponsorCode.isEmpty ? null : reg.sponsorCode,
      address: Address(
        zipCode: reg.zipCode, street: reg.street, number: reg.number,
        complement: reg.complement, neighborhood: reg.neighborhood,
        city: reg.city, state: reg.state,
      ),
      consultantCode: code,
    );
  }
}
