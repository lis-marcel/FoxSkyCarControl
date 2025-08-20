import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/network_settings.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  double _wheelsAngle = 50;
  double _speed = 0;
  bool year2023 = true;

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
                  max: 100,
                  onChanged: (double value) {
                    setState(() {
                      _wheelsAngle = value;
                    });
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