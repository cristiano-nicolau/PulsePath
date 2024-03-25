import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../models/sensor_data_model.dart';
import '../models/users.dart';
import '../models/UsersInfo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sensordata.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

 await db.execute('''
    CREATE TABLE IF NOT EXISTS sensorData (
      id $idType,
      userId $idType,
      heartRate $textType,
      calories $textType,
      steps $textType,
      distance $textType,
      speed $textType
    )
  ''');

  // Cria a tabela users se ela ainda não existir
  await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id $idType,
      name $textType,
      email $textType UNIQUE,
      phone $textType,
      password $textType
    )
  ''');

  // Cria a tabela usersInfo se ela ainda não existir
  await db.execute('''
    CREATE TABLE IF NOT EXISTS usersInfo (
      id $idType,
      userId $idType,
      weight $textType,
      height $textType,
      age $textType,
      gender $textType,
      )''');
  }

  Future<int> insertSensorData(SensorData data) async {
    final db = await instance.database;
    final id = await db.insert('sensorData', data.toMap());
    print('InsertSensorData: Inserido com sucesso | ID: $id, Heart Rate: ${data.heartRate}, Calories: ${data.calories}, Steps: ${data.steps}, Distance: ${data.distance}, Speed: ${data.speed}');
    return id;
  }


  Future<List<SensorData>> fetchSensorData() async {
    final db = await instance.database;
    final result = await db.query('sensorData');
    print('FetchSensorData: Dados buscados com sucesso | Quantidade de registos: ${result.length}');

    return result.map((json) => SensorData(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      heartRate: json['heartRate'] as String,
      calories: json['calories'] as String,
      steps: json['steps'] as String,
      distance: json['distance'] as String,
      speed: json['speed'] as String,
    )).toList();
  }

  // dar register de um user
Future<Map<String, dynamic>?> insertUserData(UserData data) async {
  try {
    final db = await instance.database;
    
    // Verifique a unicidade do email antes de inserir na base de dados
    final existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [data.email],
    );
    if (existingUser.isNotEmpty) {
      // Se o email já existe na base de dados, retorne null indicando falha na inserção
      print('Erro: O email ${data.email} já está em uso.');
      return null;
    }
    
    // Insira os dados na base de dados
    final id = await db.insert('users', data.toMap());
    print('InsertUserData: Inserido com sucesso | ID: $id, Name: ${data.name}, Email: ${data.email}, Phone: ${data.phone}, Password: ${data.password}');
    
    // Gere o token para o usuário inserido
    final userData = UserData(
      id: id,
      name: data.name,
      email: data.email,
      phone: data.phone,
      password: data.password,
    );
    final token = generateToken(userData);
    
    // Retorne os dados do usuário e o token
    return {
      'token': token,
      'name': data.name,
      'id': id,
    };
  } catch (e) {
    // Se ocorrer uma exceção, imprima o erro e retorne null indicando falha na inserção
    print('Erro ao inserir usuário: $e');
    return null;
  }
}


  // login de um user atraves do seu email e password

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
    print('FetchUserData: Data fetched successfully | Number of records: ${result.length}');

    if (result.isNotEmpty) {
      final userData = UserData(
        id: result[0]['id'] as int?,
        name: result[0]['name'] as String,
        email: result[0]['email'] as String,
        phone: result[0]['phone'] as String,
        password: result[0]['password'] as String,
      );
      
      // Generate token here (e.g., using JWT)
      final token = generateToken(userData);

      return {
        'token': token,
        'id': result[0]['id'] as int?,
        'name': result[0]['name'] as String,
      };
    } else {
      return null;
    }
  }

  // Function to generate token (e.g., using JWT)
  String generateToken(UserData userData) {
    // Your token generation logic here
    final jwt = JWT(
      {
        'uid': userData.id,
        'name': userData.name,
        'email': userData.email,

      },
    );
    final token = jwt.sign(SecretKey('mymasterultrastrongsecretkey'));

    return token;

  }

 //insere info do user na base dados
  Future<int> insertUsersInfo(UserInfo data) async {
    final db = await instance.database;
    final id = await db.insert('usersInfo', data.toMap());
    print('InsertUsersInfo: Inserido com sucesso | ID: $id, Weight: ${data.weight}, Height: ${data.height}, Age: ${data.age}, gender: ${data.gender}');
    return id;
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
