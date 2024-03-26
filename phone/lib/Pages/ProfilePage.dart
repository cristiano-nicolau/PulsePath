import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/Pages/Login.dart';
import '../services/database_helper.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  final dbHelper = DatabaseHelper.instance;

  Map<dynamic, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    String? userId = await storage.read(key: 'id');
    print('user id: $userId'); // Debugging (remove later)

    if (userId != null) {
      int parsedUserId = int.parse(userId);
      Map<dynamic, dynamic> userInfo =
          await dbHelper.fetchUsersInfo(parsedUserId);
      setState(() {
        this.userInfo = userInfo;
      });
    } else {
      // Tratar caso em que userId é nulo
      print('User ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold), // Tornar o texto em negrito
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            // Container para o ícone de logout
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey, // Cor de fundo preta
            ),
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white, // Cor do ícone branco
                ),
                onPressed: () async {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildUserInfoItem('Name', userInfo['name'] ?? ''),
            _buildUserInfoItem('Email', userInfo['email'] ?? ''),
            _buildUserInfoItem('Phone', userInfo['phone'] ?? ''),
            _buildUserInfoItem('Weight', userInfo['weight'] ?? ''),
            _buildUserInfoItem('Height', userInfo['height'] ?? ''),
            _buildUserInfoItem('Age', userInfo['age'] ?? ''),
            _buildUserInfoItem('Gender', userInfo['gender'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
            color: Colors.yellow.withOpacity(0.1),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFFFBDC8E),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '$label: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o diálogo
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    // Executar logout
                    storage.deleteAll();
                    // Por exemplo, navegar para a tela de login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
