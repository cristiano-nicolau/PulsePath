import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/Pages/Charts.dart';
import 'package:phone/Pages/DataPage.dart';
import 'package:phone/Pages/Login.dart';
import 'package:phone/components/NavigationBar.dart';
import 'package:phone/components/card.dart';
import 'package:phone/services/mqtt_service.dart';
import 'package:phone/styles/colors.dart';
import '../services/database_helper.dart';
import '../../models/sensor_data_model.dart';
import 'ProfilePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  NavBarItem _selectedItem = NavBarItem.Home;
  void _onNavBarItemSelected(NavBarItem selectedItem) {
    setState(() {
      _selectedItem = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _buildBody(), // Método para construir o corpo da página com base no item selecionado
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: _selectedItem,
        onItemSelected: _onNavBarItemSelected,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedItem) {
      case NavBarItem.Profile:
        return ProfilePage();
      case NavBarItem.Home:
        return SensorDataPage();
      case NavBarItem.Charts:
        return ChartsPage();
    }
  }
}
