import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepResponse {
  final String? logradouro;
  final String? bairro;
  final String? localidade;
  final String? uf;

  const ViaCepResponse({this.logradouro, this.bairro, this.localidade, this.uf});

  factory ViaCepResponse.fromJson(Map<String, dynamic> j) => ViaCepResponse(
        logradouro: j['logradouro'] as String?,
        bairro: j['bairro'] as String?,
        localidade: j['localidade'] as String?,
        uf: j['uf'] as String?,
      );
}

abstract class ViaCepService {
  static Future<ViaCepResponse> fetchAddress(String cep) async {
    final clean = cep.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://viacep.com.br/ws/$clean/json/');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['erro'] == true) throw Exception('CEP não encontrado.');
      return ViaCepResponse.fromJson(data);
    }
    throw Exception('Erro ao buscar CEP (${response.statusCode}).');
  }
}
