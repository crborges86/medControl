import 'package:flutter/material.dart';
import 'package:med_control/controllers/medication_pet_controller.dart';
import 'package:med_control/controllers/medication_pet_taken_controller.dart';
import 'package:med_control/models/medication_pet.dart';
import 'package:med_control/models/medications_pet_taken.dart';
import 'package:med_control/models/pet.dart';
import 'package:med_control/widgets/bottom_navigation_widgets_pet.dart';

class HistoryPetScreen extends StatefulWidget {
  final Pet pet;

  const HistoryPetScreen({super.key, required this.pet});

  @override
  HistoryPetScreenState createState() => HistoryPetScreenState();
}

class HistoryPetScreenState extends State<HistoryPetScreen> {
  final MedicationPetController _medicationController = MedicationPetController();
  final MedicationPetTakenController _medicationTakenController = MedicationPetTakenController();

  List<MedicationPet> _medications = [];
  List<MedicationsPetTaken> _takenMedications = [];

  @override
  void initState() {
    super.initState();
    _loadTakenMedications();
  }

  Future<void> _loadTakenMedications() async {
    final medications = await _medicationController.getMedicationsByPet(widget.pet.id!);
    final takenMedications = await _medicationTakenController.getMedicationsByPet(widget.pet.id!);

    setState(() {
      _medications = medications;
      _takenMedications = takenMedications;
    });
  }

  Map<String, List<Map<String, Object>>> _groupByDate(List<Map<String, Object>> data) {
    if (data.isEmpty) return {};

    final groupedData = <String, List<Map<String, Object>>>{};

    for (var item in data) {
      String date = item['date'] as String;
      groupedData.putIfAbsent(date, () => []).add(item);
    }

    final sortedKeys = groupedData.keys.toList()..sort();

    return {
      for (var key in sortedKeys)
        key: (groupedData[key]!..sort((a, b) {
          final timeA = a['scheduleTime'] as String;
          final timeB = b['scheduleTime'] as String;
          return timeA.compareTo(timeB);
        }))
    };
  }

  List<Map<String, Object>> _getMedicationList() {
    if (_takenMedications.isEmpty || _medications.isEmpty) return [];

    return _takenMedications.map((taken) {
      final medication = _medications.firstWhere((med) => med.id == taken.medicationId);
      return {
        'medication': medication,
        'date': taken.takenDate,
        'scheduleTime': taken.scheduleTime,
        'takenTime': taken.takenTime,
      };
    }).toList();
  }

  bool _isDuringDay(String time) {
    final hour = int.parse(time.split(':')[0]);
    return hour >= 6 && hour < 18;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _groupByDate(_getMedicationList());

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Medicações')),
      body: ListView(
        children: groupedData.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...entry.value.map((medInfo) {
                final med = medInfo['medication'] as MedicationPet;
                return ListTile(
                  title: Text(med.name),
                  subtitle: Text('Horário: ${medInfo['scheduleTime']} • Tomado: ${medInfo['takenTime']}'),
                  leading: Icon(_isDuringDay(medInfo['scheduleTime'] as String)
                      ? Icons.wb_sunny
                      : Icons.nights_stay),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
bottomNavigationBar: BottomNavigationWidgetsPet(
  pet: widget.pet,
  currentIndex: 1,
      ),
    );
  }
}
