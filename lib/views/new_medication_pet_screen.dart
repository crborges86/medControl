import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:med_control/controllers/medication_pet_controller.dart';
import 'package:med_control/models/medication_pet.dart';
import 'package:med_control/models/pet.dart';

class NewMedicationPetScreen extends StatefulWidget {
  final Pet pet;

  const NewMedicationPetScreen({super.key, required this.pet});

  @override
  NewMedicationPetScreenState createState() => NewMedicationPetScreenState();
}

class NewMedicationPetScreenState extends State<NewMedicationPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _stockController = TextEditingController();
  final List<String> _scheduleTimes = [];
  final _scheduleTimeController = TextEditingController();
  Color _selectedColor = Colors.blue;
  final MedicationPetController _medicationController = MedicationPetController();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _stockController.dispose();
    _scheduleTimeController.dispose();
    super.dispose();
  }

  void _addScheduleTime(String horario) {
    setState(() {
      _scheduleTimes.add(horario);
    });
  }

  void _removeScheduleTime(int index) {
    setState(() {
      _scheduleTimes.removeAt(index);
    });
  }

  Future<void> _saveMedication() async {
    if (_formKey.currentState?.validate() ?? false) {
      final medication = MedicationPet(
        petId: widget.pet.id!,
        name: _nameController.text,
        dosage: _dosageController.text,
        scheduleTimes: _scheduleTimes,
        stock: int.tryParse(_stockController.text) ?? 0,
        colorCode: _selectedColor.value.toString(),
        archived: false,
      );
      await _medicationController.addMedication(medication);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Medicação para o Pet"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosagem'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a dosagem' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || int.tryParse(value) == null
                    ? 'Informe uma quantidade válida'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text("Horários Agendados"),
              TextFormField(
                controller: _scheduleTimeController,
                decoration: const InputDecoration(labelText: 'Horário (hh:mm)'),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Adicionar horário"),
                onPressed: () {
                  if (_scheduleTimeController.text.trim().isNotEmpty) {
                    _addScheduleTime(_scheduleTimeController.text.trim());
                    _scheduleTimeController.clear();
                  }
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _scheduleTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_scheduleTimes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeScheduleTime(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Cor de identificação:"),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      Color? pickedColor = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Selecione uma cor'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (color) {
                                setState(() => _selectedColor = color);
                              },
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Confirmar'),
                              onPressed: () => Navigator.of(context).pop(_selectedColor),
                            ),
                          ],
                        ),
                      );
                      if (pickedColor != null) {
                        setState(() {
                          _selectedColor = pickedColor;
                        });
                      }
                    },
                    child: Container(
                      width: 110,
                      height: 48,
                      color: _selectedColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMedication,
                child: const Text("Salvar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}