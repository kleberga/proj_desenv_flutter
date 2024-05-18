class Cidade {
  final String city;

  const Cidade({
    required this.city,
  });

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'city': String city,
      } =>
          Cidade(
            city: city,
          ),
      _ => throw const FormatException('Failed to load city.'),
    };
  }
}