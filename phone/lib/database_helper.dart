import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/sensor_data_model.dart';

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
CREATE TABLE sensorData (
  id $idType,
  heartRate $textType,
  calories $textType,
  steps $textType,
  distance $textType,
  speed $textType
)
''');
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
      heartRate: json['heartRate'] as String,
      calories: json['calories'] as String,
      steps: json['steps'] as String,
      distance: json['distance'] as String,
      speed: json['speed'] as String,
    )).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}