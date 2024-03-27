import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../models/heart_rate_model.dart';
import '../models/sensor_data_model.dart';
import '../models/users.dart';
import '../models/userinfo.dart';

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
    print("Database initialized at $path");

    //await deleteDatabase(path);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const id = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

 await db.execute('''
    CREATE TABLE IF NOT EXISTS sensorData (
      id $idType,
      userId $id,
      heartRate $textType,
      calories $textType,
      steps $textType,
      distance $textType,
      speed $textType,
      water $textType,
      receivedDate $textType
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

      print('DatabaseHelper: Tabela users criada com sucesso');
      // Cria a tabela usersInfo se ela ainda não existir
      await db.execute('''
        CREATE TABLE IF NOT EXISTS info (
          id $idType,
          userId $id,
          weight $textType,
          height $textType,
          age $textType,
          gender $textType
          )
        ''');

        print('DatabaseHelper: Tabela info criada com sucesso');
        print('DatabaseHelper: Tabelas criadas com sucesso');
  }

  Future<int> insertSensorData(SensorData data) async {
    final db = await instance.database;
    final timestamp = DateTime.now().toString();
    final map = data.toMap();
    final id = await db.insert('sensorData', data.toMap());
    map['receivedDate'] = timestamp;
    print('InsertSensorData: Inserido com sucesso | ID: $id, Heart Rate: ${data.heartRate}, Calories: ${data.calories}, Steps: ${data.steps}, Distance: ${data.distance}, Speed: ${data.speed}, Water: ${data.water}, Received Date: $timestamp');
    return id;
  }


  Future<List<SensorData>> fetchSensorData() async {
    final db = await instance.database;
    final result = await db.query('sensorData');
    print('FetchSensorData: Dados buscados com sucesso | Quantidade de registos: ${result.length}');

    return result.map((json) => SensorData.fromMap(json)).toList();
  }

  Future<List<SensorData>> fetchTodaysHeartRateData() async {
  final db = await database;
  final today = DateTime.now();
  final startDate = DateTime(today.year, today.month, today.day);
  final endDate = DateTime(today.year, today.month, today.day, 23, 59, 59);

  final List<Map<String, dynamic>> maps = await db.query(
    'sensorData',
    where: "receivedDate BETWEEN ? AND ?",
    whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    orderBy: "receivedDate ASC", // Order by date ascending to get chronological order
  );

  print("This is the map:");
  print(maps);

  return List.generate(maps.length, (i) {
    return SensorData.fromMap(maps[i]);
  });
}

Future<List<HeartRateExtremes>> fetchWeeklyHeartRateData() async {
  final db = await database;
  final endDate = DateTime.now();
  final startDate = endDate.subtract(Duration(days: 6));

  String startDateStr = startDate.toIso8601String().split('T').first;
  String endDateStr = endDate.toIso8601String().split('T').first;

  final result = await db.rawQuery('''
    SELECT 
      MIN(heartRate) AS minHeartRate, 
      MAX(heartRate) AS maxHeartRate, 
      DATE(receivedDate) AS date 
    FROM sensorData 
    WHERE DATE(receivedDate) BETWEEN ? AND ? 
    GROUP BY DATE(receivedDate)
    ORDER BY DATE(receivedDate) ASC
  ''', [startDateStr, endDateStr]);

  print(result);

  return result.map((row) => HeartRateExtremes.fromMap(row)).toList();
}

  Future<List<HeartRateExtremes>> fetchMonthlyHeartRateData() async {
  final db = await database;
  final endDate = DateTime.now();
  final startDate = endDate.subtract(Duration(days: 29)); // Changed to fetch the last 30 days

  String startDateStr = startDate.toIso8601String().split('T').first;
  String endDateStr = endDate.toIso8601String().split('T').first;

  final result = await db.rawQuery('''
    SELECT 
      MIN(heartRate) AS minHeartRate, 
      MAX(heartRate) AS maxHeartRate, 
      DATE(receivedDate) AS date 
    FROM sensorData 
    WHERE DATE(receivedDate) BETWEEN ? AND ? 
    GROUP BY DATE(receivedDate)
    ORDER BY DATE(receivedDate) ASC
  ''', [startDateStr, endDateStr]);

  print(result);

  return result.map((row) => HeartRateExtremes.fromMap(row)).toList();
}




    // Fetch sensor data for the last day
  Future<List<SensorData>> fetchDailySensorData() async {
    final db = await instance.database;
  final result = await db.query(
    'sensorData',
    orderBy: "receivedDate DESC",
    limit: 1, // Only fetch the most recent entry
  );
  print('FetchMostRecentSensorData: Most recent data fetched successfully');
  print(result);
  return result.map((json) => SensorData.fromMap(json)).toList();

}

  // Fetch the last record of each day for the last 7 days
  Future<List<SensorData>> fetchWeeklySensorData() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      WITH DateGroups AS (
        SELECT
          DATE(receivedDate) AS dateOnly,
          MAX(receivedDate) AS maxReceivedDate
        FROM sensorData
        WHERE receivedDate >= DATE('now', '-6 days')
        GROUP BY dateOnly
      )
      SELECT s.* FROM sensorData s
      INNER JOIN DateGroups d ON DATE(s.receivedDate) = d.dateOnly AND s.receivedDate = d.maxReceivedDate
      ORDER BY s.receivedDate DESC
    ''');
    return result.map((json) => SensorData.fromMap(json)).toList();
  }

    // Fetch the last record of each day for the last 30 days
  Future<List<SensorData>> fetchMonthlySensorData() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      WITH DateGroups AS (
        SELECT
          DATE(receivedDate) AS dateOnly,
          MAX(receivedDate) AS maxReceivedDate
        FROM sensorData
        WHERE receivedDate >= DATE('now', '-29 days')
        GROUP BY dateOnly
      )
      SELECT s.* FROM sensorData s
      INNER JOIN DateGroups d ON DATE(s.receivedDate) = d.dateOnly AND s.receivedDate = d.maxReceivedDate
      ORDER BY s.receivedDate DESC
    ''');
    return result.map((json) => SensorData.fromMap(json)).toList();
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
    final id = await db.insert('info', data.toMap());
    print('InsertUsersInfo: Inserido com sucesso | ID: $id, Weight: ${data.weight}, Height: ${data.height}, Age: ${data.age}, gender: ${data.gender}');
    return id;
  }

  //buscar info do user + os dados do user atraves do id recebido + token
  Future<Map<dynamic,dynamic>> fetchUsersInfo(int userId) async {
    final db = await instance.database;
    final user_info = await db.query('info', where: 'userId = ?', whereArgs: [userId]);
    final user_data = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    print('FetchUsersInfo: Dados buscados com sucesso | Quantidade de registos: ${user_info.length}');
    print('FetchUsersInfo: Dados buscados com sucesso | Quantidade de registos: ${user_data.length}');

    if (user_info.isNotEmpty && user_data.isNotEmpty) {
      return {
        'id': user_info[0]['id'] as int?,
        'weight': user_info[0]['weight'] as String,
        'height': user_info[0]['height'] as String,
        'age': user_info[0]['age'] as String,
        'gender': user_info[0]['gender'] as String,
        'name': user_data[0]['name'] as String,
        'email': user_data[0]['email'] as String,
        'phone': user_data[0]['phone'] as String,
      };
    } else {
      return {};
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
