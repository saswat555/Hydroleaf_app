// lib/src/ui/screens/register_device_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:hydroleaf_app/src/services/models.dart';
import '../../routes.dart';

class RegisterDeviceScreen extends StatefulWidget {
  static const routeName = Routes.registerDevice;

  final ApiService apiService;
  final String token;

  const RegisterDeviceScreen({
    Key? key,
    required this.apiService,
    required this.token,
  }) : super(key: key);

  @override
  State<RegisterDeviceScreen> createState() => _RegisterDeviceScreenState();
}

class _RegisterDeviceScreenState extends State<RegisterDeviceScreen> {
  DeviceType _type = DeviceType.dosingUnit;
  final _macCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _endpointCtrl = TextEditingController();
  final _locCtrl = TextEditingController();

  // for dosing
  final List<PumpConfig> _pumps = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _macCtrl.dispose();
    _nameCtrl.dispose();
    _endpointCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  void _addPump() {
    setState(() {
      _pumps.add(PumpConfig(
        pumpNumber: _pumps.length + 1,
        chemicalName: '',
        chemicalDescription: null,
      ));
    });
  }

  Future<void> _submit() async {
    if (_macCtrl.text.isEmpty ||
        _nameCtrl.text.isEmpty ||
        _endpointCtrl.text.isEmpty) {
      setState(() => _error = 'Please fill all required fields');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_type == DeviceType.dosingUnit) {
        if (_pumps.isEmpty) {
          setState(() => _error = 'Add at least one pump configuration');
          return;
        }

        final dto = DosingDeviceCreate(
          macId: _macCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          httpEndpoint: _endpointCtrl.text.trim(),
          locationDescription:
              _locCtrl.text.trim().isEmpty ? null : _locCtrl.text.trim(),
          farmId: null,
          pumpConfigurations: _pumps
              .map((p) => PumpConfig(
                    pumpNumber: p.pumpNumber,
                    chemicalName: p.chemicalName,
                    chemicalDescription: p.chemicalDescription,
                  ))
              .toList(),
        );

        await widget.apiService.registerDosingDevice(widget.token, dto);
      } else {
        // sensor or other
        final dto = SensorDeviceCreate(
          macId: _macCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          type: _type,
          httpEndpoint: _endpointCtrl.text.trim(),
          locationDescription:
              _locCtrl.text.trim().isEmpty ? null : _locCtrl.text.trim(),
          farmId: null,
          sensorParameters: {}, // you can add real fields here
        );
        await widget.apiService.registerSensorDevice(widget.token, dto);
      }

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Device')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              SizedBox(height: 12.h),
            ],
            DropdownButtonFormField<DeviceType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Device Type'),
              items: DeviceType.values
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d.toApi()),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _macCtrl,
              decoration: const InputDecoration(labelText: 'MAC ID'),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _endpointCtrl,
              decoration: const InputDecoration(labelText: 'HTTP Endpoint'),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _locCtrl,
              decoration:
                  const InputDecoration(labelText: 'Location (optional)'),
            ),

            // dosing-specific
            if (_type == DeviceType.dosingUnit) ...[
              SizedBox(height: 24.h),
              Text('Pump Configurations',
                  style: Theme.of(context).textTheme.titleMedium),
              // Use List.generate so you have the index
              ...List.generate(_pumps.length, (idx) {
                final pump = _pumps[idx];
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: 'Pump #${pump.pumpNumber}'),
                        onChanged: (v) {
                          setState(() {
                            // replace the entire PumpConfig instance
                            _pumps[idx] = PumpConfig(
                              pumpNumber: pump.pumpNumber,
                              chemicalName: v,
                              chemicalDescription: pump.chemicalDescription,
                            );
                          });
                        },
                      ),
                    ),
                    if (idx == _pumps.length - 1)
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addPump,
                      ),
                  ],
                );
              }),
              if (_pumps.isEmpty)
                TextButton(
                  onPressed: _addPump,
                  child: const Text('Add Pump'),
                ),
            ],

            SizedBox(height: 32.h),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Register Device'),
                  ),
          ],
        ),
      ),
    );
  }
}
