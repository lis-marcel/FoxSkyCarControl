import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/network_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  double _wheelsAngle = 50;
  double _speed = 0;
  DateTime _lastAngleUpdate = DateTime.now();
  DateTime _lastSpeedUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Allow all orientations when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _sendSpeed(String ipAddress) async {
    try {
      final response = await http.post(
        Uri.parse('http://$ipAddress/setSpeed'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'speed': _speed.toInt()}),
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to send speed: ${response.statusCode}');
      }

    } catch (e) {
      debugPrint('Error sending speed: $e');
    }
  }

  Future<void> _sendAngle(String ipAddress) async {
    try {
      final response = await http.post(
        Uri.parse('http://$ipAddress/setAngle'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'angle': _wheelsAngle.toInt()}),
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to send wheel angle: ${response.statusCode}');
      }

    } catch (e) {
      debugPrint('Error sending angle: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final networkSettings = Provider.of<NetworkSettings>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Currently connected to: ${networkSettings.ipAddress}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: <Widget>[
          // Left column with vertical speed slider
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Speed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 3, // Rotate to make vertical
                    child: Slider(
                      value: _speed,
                      max: 100,
                      onChanged: (double value) {
                        setState(() {
                          _speed = value;
                        });

                        final now = DateTime.now();
                        if (now.difference(_lastSpeedUpdate).inMilliseconds > 100) {
                          _lastSpeedUpdate = now;
                          _sendSpeed(networkSettings.ipAddress);
                        }
                      },
                      onChangeEnd: (double value) {
                        _sendSpeed(networkSettings.ipAddress);
                      },
                    ),
                  ),
                ),
                Text('${_speed.toInt()}%', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          
          // Middle column (empty space)
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          
          // Right column with horizontal wheels angle slider
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Steering', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Slider(
                  value: _wheelsAngle,
                  min: -100,
                  max: 100,
                  onChanged: (double value) {
                    setState(() {
                      _wheelsAngle = value;
                    });

                    final now = DateTime.now();
                    if (now.difference(_lastAngleUpdate).inMilliseconds > 100) {
                      _lastAngleUpdate = now;
                      _sendAngle(networkSettings.ipAddress);
                    }
                  },

                  onChangeEnd: (double value) {
                    _sendAngle(networkSettings.ipAddress);
                  },
                ),
                Text('${_wheelsAngle.toInt()}°', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}