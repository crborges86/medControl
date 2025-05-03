import 'package:flutter/material.dart';
import 'package:med_control/models/pet.dart';
import 'package:med_control/views/history_pet_screen.dart';
import 'package:med_control/views/pet_screen.dart';
import 'package:med_control/views/today_pet_screen.dart';


class BottomNavigationWidgetsPet extends StatefulWidget {
  final Pet pet;

  const BottomNavigationWidgetsPet({super.key, required this.pet, required int currentIndex});

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidgetsPet> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: 'Hoje',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Histórico',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Perfil',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });

        if (index == 0) {
          // Navegar para a tela Hoje
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TodayPetScreen(
                pet: widget.pet,
              ),
            ),
          );
        } else if (index == 1) {
          // Navegar para a tela Histórico
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryPetScreen(
                pet: widget.pet,
              ),
            ),
          );
        } else if (index == 2) {
          // Navegar para a tela Perfil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PetScreen(
                pet: widget.pet,
              ),
            ),
          );
        }
      },
    );
  }
}
