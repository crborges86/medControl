import 'package:med_control/database/database_helper.dart';
import 'package:med_control/models/medication_pet.dart';
import 'package:med_control/models/pet.dart';

class PetController {
  Future<List<Pet>> getPets() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('pets');
    return result.map((json) => Pet.fromMap(json)).toList();
  }

  Future<int> addPet(Pet pet) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('pets', pet.toMap());
  }

  Future<int> updatePet(Pet pet) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  Future<int> deletePet(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Pet?> getPetById(int petId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'pets',
      where: 'id = ?',
      whereArgs: [petId],
    );

    if (result.isNotEmpty) {
      return Pet.fromMap(result.first);
    } else {
      return null;
    }
  }

// Retorna uma lista de medicamentos em uso para um perfil específico
  Future<List<MedicationPet>> getMedicationsInUse(int petId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'medications_pet',
      where: 'petId = ? AND archived = 0',
      whereArgs: [petId],
    );

    return result.map((json) => MedicationPet.fromMap(json)).toList();
  }

  // Retorna uma lista de medicamentos arquivados para um perfil específico
  Future<List<MedicationPet>> getArchivedMedications(int petId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'medications_pet',
      where: 'petId = ? AND archived = 1',
      whereArgs: [petId],
    );

    return result.map((json) => MedicationPet.fromMap(json)).toList();
  }

  // Retorna todos os medicamentos (ativos e arquivados) para a tela de hoje
Future<List<MedicationPet>> getMedications(int petId) async {
  final db = await DatabaseHelper.instance.database;
  final result = await db.query(
    'medications_pet',
    where: 'petId = ?',
    whereArgs: [petId],
  );

  return result.map((json) => MedicationPet.fromMap(json)).toList();
}

}