import 'dart:convert';

class MedicationPet {
  final int? id;
  final int petId;
  final String name;
  final String dosage;
  final List<String> scheduleTimes;
  final int stock;
  final String colorCode;
  final bool archived;

  MedicationPet({
    this.id,
    required this.petId,
    required this.name,
    required this.dosage,
    required this.scheduleTimes,
    required this.stock,
    required this.colorCode,
    this.archived = false,
  });

  factory MedicationPet.fromMap(Map<String, dynamic> map) {
    return MedicationPet(
      id: map['id'] as int?,
      petId: map['petId'] as int,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      scheduleTimes: List<String>.from(jsonDecode(map['scheduleTimes'])),
      stock: map['stock'],
      colorCode: map['colorCode'],
      archived: map['archived'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'name': name,
      'dosage': dosage,
      'scheduleTimes': jsonEncode(scheduleTimes),
      'stock': stock,
      'colorCode': colorCode,
      'archived': archived ? 1 : 0,
    };
  }

  DateTime? get startDate => null;
  get endDate => null;

  MedicationPet copyWith({
    int? id,
    int? petId,
    String? name,
    String? dosage,
    List<String>? scheduleTimes,
    int? stock,
    String? colorCode,
    bool? archived,
  }) {
    return MedicationPet(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      stock: stock ?? this.stock,
      colorCode: colorCode ?? this.colorCode,
      archived: archived ?? this.archived,
    );
  }
}