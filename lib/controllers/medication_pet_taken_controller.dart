import 'package:med_control/database/database_helper.dart';
import 'package:med_control/models/medications_pet_taken.dart';

class MedicationPetTakenController {
  // Obtém todos os medicamentos tomados por um pet específico
  Future<List<MedicationsPetTaken>> getMedicationsByPet(int petId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'medications_pet_taken',
      where: 'petId = ?',
      whereArgs: [petId],
    );

    return result.map((json) => MedicationsPetTaken.fromMap(json)).toList();
  }

  // Obtém medicamentos tomados por um pet em uma data específica
  Future<List<MedicationsPetTaken>> getMedicationsTakenByDate(
    int petId,
    String takenDate,
  ) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'medications_pet_taken',
      where: 'petId = ? AND takenDate = ?',
      whereArgs: [petId, takenDate],
    );

    return result.map((json) => MedicationsPetTaken.fromMap(json)).toList();
  }

  // Adiciona um novo registro de medicação tomada por pet
  Future<int> addMedicationTaken(MedicationsPetTaken medicationTaken) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('medications_pet_taken', medicationTaken.toMap());
  }
}