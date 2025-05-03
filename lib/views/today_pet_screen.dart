import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_control/controllers/medication_pet_controller.dart';
import 'package:med_control/controllers/medication_pet_taken_controller.dart';
import 'package:med_control/models/medication_pet.dart';
import 'package:med_control/models/medications_pet_taken.dart';
import 'package:med_control/models/pet.dart';
import 'package:med_control/widgets/bottom_navigation_widgets_pet.dart';

class TodayPetScreen extends StatefulWidget {
  final Pet pet;

  const TodayPetScreen({super.key, required this.pet});

  @override
  State<TodayPetScreen> createState() => TodayPetScreenState();
}

class TodayPetScreenState extends State<TodayPetScreen> {
  final MedicationPetController _medicationPetController = MedicationPetController();
  final MedicationPetTakenController _medicationTakenController = MedicationPetTakenController();
  List<MedicationPet> _medications = [];
  List<MedicationsPetTaken> _takenMedications = [];

  @override
  void initState() {
    super.initState();
    _loadMedicationsForToday();
  }

  Future<void> _loadMedicationsForToday() async {
    final medications = await _medicationPetController.getMedicationsForToday(widget.pet.id!);

    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final takenMedications = await _medicationTakenController.getMedicationsTakenByDate(widget.pet.id!, today);

    setState(() {
      _medications = medications;
      _takenMedications = takenMedications;
    });
  }

  Future<void> _takeMedication(int medicationId, String time) async {
    final now = DateTime.now();
    final dateString = DateFormat('dd/MM/yyyy').format(now);
    final hourString = DateFormat('HH:mm').format(now);

    final medicationTaken = MedicationsPetTaken(
      petId: widget.pet.id!,
      medicationId: medicationId,
      scheduleTime: time,
      takenDate: dateString,
      takenTime: hourString,
    );

    await _medicationTakenController.addMedicationTaken(medicationTaken);
    await _medicationPetController.takeMedication(medicationId);

    _loadMedicationsForToday();
  }

  int _calculateAge(String dateOfBirth) {
    final birthDate = DateFormat('dd/MM/yyyy').parse(dateOfBirth);
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  List<Map<String, Object>> _getMedicationList() {
    final baseList = _medications.map((medication) {
      final remainingTimes = medication.scheduleTimes.where((time) {
        return !_takenMedications.any((taken) =>
          taken.medicationId == medication.id &&
          taken.scheduleTime == time);
      }).toList();

      if (remainingTimes.isNotEmpty) {
        return MedicationPet(
          id: medication.id,
          name: medication.name,
          colorCode: medication.colorCode,
          dosage: medication.dosage,
          petId: medication.petId,
          stock: medication.stock,
          archived: medication.archived,
          scheduleTimes: remainingTimes,
        );
      }
      return null;
    }).whereType<MedicationPet>().toList();

    final expandedList = baseList.expand((medication) {
      return medication.scheduleTimes.map((time) {
        return {
          'medication': medication,
          'time': time,
        };
      }).toList();
    }).toList();

    expandedList.sort((a, b) {
      final timeA = a['time'] as String;
      final timeB = b['time'] as String;
      return timeA.compareTo(timeB);
    });

    return expandedList;
  }

  bool _isDuringDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    return hour >= 6 && hour < 18;
  }

  @override
  Widget build(BuildContext context) {
    final medicationsList = _getMedicationList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pet.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_calculateAge(widget.pet.birthdate)} anos',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Hoje",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            medicationsList.isEmpty
                ? const Text('Nenhum medicamento encontrado')
                : Expanded(
                    child: ListView.builder(
                      itemCount: medicationsList.length,
                      itemBuilder: (context, index) {
                        final item = medicationsList[index];
                        final medication = item['medication'] as MedicationPet;
                        final time = item['time'] as String;
                        final isDay = _isDuringDay(time);

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            iconColor: Color(int.parse(medication.colorCode)),
                            leading: isDay
                                ? const Icon(Icons.sunny)
                                : const Icon(Icons.nightlight),
                            title: Text("${medication.name} ${medication.dosage}"),
                            subtitle: Text("Horário: $time - Estoque: ${medication.stock}"),
                            trailing: IconButton.outlined(
                              onPressed: () {
                                _takeMedication(medication.id!, time);
                              },
                              icon: const Icon(Icons.medication_liquid_outlined),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
bottomNavigationBar: BottomNavigationWidgetsPet(
  pet: widget.pet,
  currentIndex: 0,
),

    );
  }
}


