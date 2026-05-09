class Address {
  final String zipCode;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  const Address({
    required this.zipCode,
    required this.street,
    required this.number,
    this.complement = '',
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  String get formatted {
    final parts = <String>[
      if (street.isNotEmpty) '$street, $number',
      if (complement.isNotEmpty) complement,
      if (neighborhood.isNotEmpty) neighborhood,
      '$city - $state',
      zipCode,
    ];
    return parts.join(', ');
  }
}
