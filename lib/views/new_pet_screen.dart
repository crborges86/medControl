import 'package:flutter/material.dart';
import 'package:med_control/controllers/pet_controller.dart';
import 'package:med_control/models/pet.dart';
import 'package:med_control/views/profile_selection_screen.dart';

class NewProfilePetScreen extends StatefulWidget {
  const NewProfilePetScreen({super.key});

  @override
  NewProfilePetScreenState createState() => NewProfilePetScreenState();
}

class NewProfilePetScreenState extends State<NewProfilePetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final PetController _petController = PetController();

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  // Método para salvar o novo perfil de pet
    Future<Pet?> _savePet() async {
    if (_formKey.currentState!.validate()) {
      final newProfile = Pet(
        name: _nameController.text,
        birthdate: _birthdateController.text,
        species: _speciesController.text,
        breed: _breedController.text,
      );

      await _petController.addPet(newProfile);
      return newProfile;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Pet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do pet';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(labelText: 'Espécie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a espécie do pet';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Raça'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento (dd/mm/yyyy)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de nascimento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    print('Botão Salvar clicado');
                    final newPet = await _savePet();
                    if (newPet != null) {
                      print('Pet salvo com sucesso');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSelectionScreen(),
                        ),
                      );
                    } else {
                      print('Falha ao salvar o pet');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao salvar o pet. Verifique os dados.')),
                      );
                    }
                  },
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