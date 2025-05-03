class Pet {
  final int? id;
  final String name;
  final String birthdate;
  final String species;
  final String breed;


  Pet({
    this.id,
    required this.name,
    required this.birthdate,
    required this.species,
    required this.breed,
  });

  // Converte um Map em uma instância de Pet
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'] as int?,
      name: map['name'] as String,
      birthdate: map['birthdate'] as String,
      species: map['species'] as String,
      breed: map['breed'] as String,

    );
  }

  // Converte uma instância de Pet em um Map para o banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthdate': birthdate,
      'species': species,
      'breed': breed,
    };
  }
}