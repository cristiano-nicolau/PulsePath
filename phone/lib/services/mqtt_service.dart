import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'database_helper.dart';
import '../models/sensor_data_model.dart';

class MqttService {
  late MqttServerClient client;
  final dbHelper = DatabaseHelper.instance;
  final StreamController<SensorData> _dataUpdateController =
      StreamController<SensorData>.broadcast();

  Stream<SensorData> get dataUpdates => _dataUpdateController.stream;

  Future<int?> getCurrentUserId() async {
    const storage = FlutterSecureStorage();
    String? userIdStr = await storage.read(key: 'id');
    if (userIdStr != null) {
      return int.parse(userIdStr);
    }
    return null;
  }

  Future<void> initializeMqttClient() async {
    client = MqttServerClient('broker.emqx.io', 'flutter_client_android');
    client.logging(on: true);

    // Configure callbacks
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    try {
      await client.connect();
      print('MQTT: Conectado com sucesso ao broker.');
    } catch (e) {
      print('MQTT: Exception na conexão - $e');
      client.disconnect();
    }

    // Subscribe to the topic
    const topic = 'sensor/data';
    client.subscribe(topic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('MQTT: Mensagem recebida - $payload');
      _handleSensorData(payload);
    });
  }

  void _handleSensorData(String payload) async {
    final parts = payload.split(', ');
    final heartRate = parts[0].split(': ')[1];
    final calories = parts[1].split(': ')[1];
    final steps = parts[2].split(': ')[1];
    final distance = parts[3].split(': ')[1];
    final speed = parts[4].split(': ')[1];
    final water = parts[5].split(': ')[1];
    final int? userId = await getCurrentUserId();

    if (userId == null) {
      print("User ID is null, cannot handle sensor data.");
      return;
    }

    final sensorData = SensorData(
      userId: userId,
      heartRate: heartRate,
      calories: calories,
      steps: steps,
      distance: distance,
      speed: speed,
      water: water,
      receivedDate: DateTime.now(),
    );

    dbHelper.insertSensorData(sensorData).then((id) {
      print('Sensor data inserted with id: $id');
    });

    _dataUpdateController.add(sensorData);
  }

  void onConnected() {
    print('Connected to MQTT broker.');
  }

  void onDisconnected() {
    print('Disconnected from MQTT broker.');
  }
}
