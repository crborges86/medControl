import 'package:med_control/database/database_helper.dart';
import 'package:med_control/models/medication_pet.dart';

class MedicationPetController {
  // Método para obter todos os medicamentos para um perfil específico
  Future<List<MedicationPet>> getMedicationsByPet(int petId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'medications_pet',
      where: 'petId = ?',
      whereArgs: [petId],
    );
    return result.map((json) => MedicationPet.fromMap(json)).toList();
  }

  // Método para adicionar um novo medicamento
  Future<int> addMedication(MedicationPet medication) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('medications_pet', medication.toMap());
  }

  // Método para atualizar um medicamento existente
  Future<int> updateMedication(MedicationPet medication) async {
    final db = await DatabaseHelper.instance.database;

    return await db.update(
      'medications_pet',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  // Método para tomar um medicamento (diminuir o estoque em 1)
  Future<void> takeMedication(int medicationId) async {
    final db = await DatabaseHelper.instance.database;

    // Decrementar a quantidade no estoque
    await db.rawUpdate('''
      UPDATE medications_pet
      SET stock = stock - 1
      WHERE id = ? AND stock > 0
    ''', [medicationId]);
  }

  // Método para excluir um medicamento
  Future<int> deleteMedication(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      'medications_pet',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para buscar todos os medicamentos para o perfil especificado que estão programados para o dia atual
  Future<List<MedicationPet>> getMedicationsForToday(int profileId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'medications_pet',
      where: 'petId = ? AND archived = 0',
      whereArgs: [profileId],
    );

    return result.map((json) => MedicationPet.fromMap(json)).toList();
  }

  getMedications(int i) {}
}
