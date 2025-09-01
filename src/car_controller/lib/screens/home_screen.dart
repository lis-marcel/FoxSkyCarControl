import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/network_settings.dart';
import 'control_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ipController = TextEditingController(text: '192.168.4.1'); // Set default value here
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize text controller with current IP address from provider
    // This will override the default if a saved value exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final networkSettings = Provider.of<NetworkSettings>(context, listen: false);
      if (networkSettings.ipAddress.isNotEmpty) {
        _ipController.text = networkSettings.ipAddress;
      }
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter IP Address:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  // Remove prefixText and use hint text instead if needed
                  hintText: 'Enter IP address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an IP address';
                  }
                  
                  final ipRegex = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$');
                  if (!ipRegex.hasMatch(value)) {
                    return 'Please enter a valid IP address';
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the IP address
                      final networkSettings = Provider.of<NetworkSettings>(context, listen: false);
                      networkSettings.setIpAddress(_ipController.text);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Connected!')),
                      );
                      
                      // Navigate to the control screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ControlScreen()),
                      );
                    }
                  },
                  child: const Text('Connect'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}