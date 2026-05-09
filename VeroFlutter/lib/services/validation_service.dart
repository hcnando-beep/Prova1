abstract class ValidationService {
  static bool isValidEmail(String email) =>
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
          .hasMatch(email);

  static bool isValidCPF(String cpf) {
    final d = cpf.replaceAll(RegExp(r'\D'), '');
    if (d.length != 11 || d.split('').toSet().length == 1) return false;

    int calc(int len) {
      int sum = 0;
      for (int i = 0; i < len; i++) sum += int.parse(d[i]) * (len + 1 - i);
      final rem = sum % 11;
      return rem < 2 ? 0 : 11 - rem;
    }

    return int.parse(d[9]) == calc(9) && int.parse(d[10]) == calc(10);
  }

  static bool isValidPhone(String phone) {
    final n = phone.replaceAll(RegExp(r'\D'), '').length;
    return n >= 10 && n <= 11;
  }
}
