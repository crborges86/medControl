class MedicationsPetTaken {
  final int? id;
  final int petId;
  final int medicationId;
  final String scheduleTime;
  final String takenDate;
  final String takenTime;

  MedicationsPetTaken({
    this.id,
    required this.petId,
    required this.medicationId,
    required this.scheduleTime,
    required this.takenDate,
    required this.takenTime,
  });

  factory MedicationsPetTaken.fromMap(Map<String, dynamic> map) {
    return MedicationsPetTaken(
      id: map['id'] as int?,
      petId: map['petId'] as int,
      medicationId: map['medicationId'] as int,
      scheduleTime: map['scheduleTime'] as String,
      takenDate: map['takenDate'] as String,
      takenTime: map['takenTime'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'medicationId': medicationId,
      'scheduleTime': scheduleTime,
      'takenDate': takenDate,
      'takenTime': takenTime,
    };
  }

  MedicationsPetTaken copyWith({
    int? id,
    int? petId,
    int? medicationId,
    String? scheduleTime,
    String? takenDate,
    String? takenTime,
  }) {
    return MedicationsPetTaken(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      medicationId: medicationId ?? this.medicationId,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      takenDate: takenDate ?? this.takenDate,
      takenTime: takenTime ?? this.takenTime,
    );
  }
}