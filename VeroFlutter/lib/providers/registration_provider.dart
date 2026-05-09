import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/consultant.dart';
import '../services/api_service.dart';
import '../services/via_cep_service.dart';
import '../services/validation_service.dart';

class RegistrationProvider extends ChangeNotifier {
  // Step 1 – Dados Pessoais
  String fullName = '';
  String cpf = '';
  String rg = '';
  DateTime birthDate = DateTime.now().subtract(const Duration(days: 365 * 25));
  String gender = 'Prefiro não informar';

  // Step 2 – Contato
  String email = '';
  String phone = '';
  String whatsapp = '';
  bool samePhoneAsWhatsApp = true;

  // Step 3 – Endereço
  String zipCode = '';
  String street = '';
  String number = '';
  String complement = '';
  String neighborhood = '';
  String city = '';
  String state = '';

  // Step 4 – Profissional
  String sponsorCode = '';
  String interestArea = '';
  bool hasExperience = false;

  // Step 5 – Documentos
  XFile? documentFrontImage;
  XFile? documentBackImage;
  XFile? selfieImage;

  // Step 6 – Termos
  bool acceptedTerms = false;
  bool acceptedPrivacy = false;

  // State
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isLoadingAddress = false;
  String? _errorMessage;
  String? _addressError;
  Consultant? _registeredConsultant;

  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  bool get isLoadingAddress => _isLoadingAddress;
  String? get errorMessage => _errorMessage;
  String? get addressError => _addressError;
  Consultant? get registeredConsultant => _registeredConsultant;
  bool get isRegistered => _registeredConsultant != null;

  // Static data
  static const stepTitles = ['Pessoal', 'Contato', 'Endereço', 'Profissional', 'Docs', 'Confirmar'];
  static const stepIcons = [
    Icons.person_outline,
    Icons.email_outlined,
    Icons.map_outlined,
    Icons.work_outline,
    Icons.document_scanner_outlined,
    Icons.check_circle_outline,
  ];
  static const genderOptions = ['Feminino', 'Masculino', 'Outro', 'Prefiro não informar'];
  static const interestAreas = [
    'Bem-estar e cuidados pessoais',
    'Maquiagem e beleza',
    'Skincare e cuidados com a pele',
    'Perfumaria',
    'Produtos capilares',
    'Diversificado (todas as categorias)',
  ];
  static const brStates = [
    'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
    'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN',
    'RS','RO','RR','SC','SP','SE','TO',
  ];

  String get navigationTitle => switch (_currentStep) {
    0 => 'Dados Pessoais',
    1 => 'Contato',
    2 => 'Endereço',
    3 => 'Dados Profissionais',
    4 => 'Documentos',
    5 => 'Confirmar Cadastro',
    _ => 'Cadastro',
  };

  bool get isStep1Valid =>
      fullName.trim().isNotEmpty &&
      ValidationService.isValidCPF(cpf) &&
      rg.isNotEmpty;

  bool get isStep2Valid =>
      ValidationService.isValidEmail(email) &&
      phone.replaceAll(RegExp(r'\D'), '').length >= 10;

  bool get isStep3Valid =>
      zipCode.replaceAll(RegExp(r'\D'), '').length == 8 &&
      street.trim().isNotEmpty &&
      number.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      state.isNotEmpty;

  bool get isStep4Valid => interestArea.isNotEmpty;
  bool get isStep5Valid => documentFrontImage != null;
  bool get isStep6Valid => acceptedTerms && acceptedPrivacy;

  bool get canAdvance => switch (_currentStep) {
    0 => isStep1Valid,
    1 => isStep2Valid,
    2 => isStep3Valid,
    3 => isStep4Valid,
    4 => isStep5Valid,
    5 => isStep6Valid,
    _ => false,
  };

  void update(VoidCallback fn) { fn(); notifyListeners(); }

  void next() { if (_currentStep < 5) { _currentStep++; notifyListeners(); } }
  void back() { if (_currentStep > 0) { _currentStep--; notifyListeners(); } }

  Future<void> fetchAddress() async {
    final clean = zipCode.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 8) return;
    _isLoadingAddress = true;
    _addressError = null;
    notifyListeners();
    try {
      final r = await ViaCepService.fetchAddress(clean);
      street       = r.logradouro ?? '';
      neighborhood = r.bairro     ?? '';
      city         = r.localidade ?? '';
      state        = r.uf         ?? '';
    } catch (e) {
      _addressError = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoadingAddress = false;
    notifyListeners();
  }

  Future<void> submit() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _registeredConsultant = await ApiService.registerConsultant(this);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
  }
}
