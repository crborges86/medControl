import 'package:flutter/material.dart';
import 'package:med_control/controllers/pet_controller.dart';
import 'package:med_control/models/pet.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  EditPetScreenState createState() => EditPetScreenState();
}

class EditPetScreenState extends State<EditPetScreen> {
final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthdateController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;

  final PetController _petController = PetController();


  @override
  void initState() {
    super.initState();
   _nameController = TextEditingController(text: widget.pet.name);
    _birthdateController = TextEditingController(text: widget.pet.birthdate);
    _speciesController = TextEditingController(text: widget.pet.species);
    _breedController = TextEditingController(text: widget.pet.breed);
  }
  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  // Método para salvar o perfil atualizado
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedPet = Pet(
        id: widget.pet.id,
        name: _nameController.text,
        birthdate: _birthdateController.text,
        species: _speciesController.text,
        breed: _breedController.text,
      );

      await _petController.updatePet(updatedPet);

      Navigator.pop(context, updatedPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdateController,
                decoration: const InputDecoration(
                    labelText: 'Data de Nascimento (dd/mm/yyyy)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de nascimento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _speciesController,
                decoration:
                    const InputDecoration(labelText: 'Espécie'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Raça'),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
