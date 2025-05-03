import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_control/controllers/pet_controller.dart';
import 'package:med_control/controllers/profile_controller.dart';
import 'package:med_control/models/pet.dart';
import 'package:med_control/models/profile.dart';
import 'package:med_control/views/new_pet_screen.dart';
import 'package:med_control/views/new_profile_screen.dart';
import 'package:med_control/views/today_screen.dart';
import 'package:med_control/views/today_pet_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  ProfileSelectionScreenState createState() => ProfileSelectionScreenState();
}

class ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final ProfileController _profileController = ProfileController();
  final PetController _petController = PetController();

  List<Profile> _profiles = [];
  List<Pet> _pets = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final profiles = await _profileController.getProfiles();
    final pets = await _petController.getPets();

    setState(() {
      _profiles = profiles;
      _pets = pets;
    });
  }

  void _navigateToAddProfile() async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewProfileScreen()),
    );

    if (result != null) {
      _loadProfiles();
    }
  }

  void _navigateToAddProfilePet() async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewProfilePetScreen()),
    );

    if (result != null) {
      _loadProfiles();
    }
  }

  void _navigateToToday(Profile profile) async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TodayScreen(profile: profile)),
    );

    if (result == true) {
      _loadProfiles();
    }
  }

  void _navigateToPetToday(Pet pet) async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TodayPetScreen(pet: pet)),
    );

    if (result == true) {
      _loadProfiles();
    }
  }

  int calcularIdade(String dataNascimento) {
    final nascimento = DateFormat('dd/MM/yyyy').parse(dataNascimento);
    final hoje = DateTime.now();

    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }

    return idade;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção de Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pessoas cadastradas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: _profiles.isEmpty
                ? const Center(child: Text('Nenhum perfil encontrado.'))
                : ListView.builder(
                    itemCount: _profiles.length,
                    itemBuilder: (context, index) {
                      final profile = _profiles[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(profile.name),
                        subtitle: Text('Idade: ${calcularIdade(profile.birthdate)} anos'),
                        onTap: () => _navigateToToday(profile),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pets cadastrados',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: _pets.isEmpty
                ? const Center(child: Text('Nenhum pet encontrado.'))
                : ListView.builder(
                    itemCount: _pets.length,
                    itemBuilder: (context, index) {
                      final pet = _pets[index];
                      return ListTile(
                        leading: const Icon(Icons.pets),
                        title: Text(pet.name),
                        subtitle: Text('Idade: ${calcularIdade(pet.birthdate)} anos'),
                        onTap: () => _navigateToPetToday(pet),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Nova Pessoa'),
              onPressed: _navigateToAddProfile,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Novo Pet'),
              onPressed: _navigateToAddProfilePet,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}