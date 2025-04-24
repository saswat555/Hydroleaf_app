// lib/src/screens/sensor_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/routes.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:hydroleaf_app/src/services/models.dart';

class SensorScreen extends StatefulWidget {
  static const routeName = Routes.sensor;

  final ApiService api;
  final String token;
  final DeviceResponse device;

  const SensorScreen({
    Key? key,
    required this.api,
    required this.token,
    required this.device,
  }) : super(key: key);

  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  late Future<SensorReading> _reading;

  @override
  void initState() {
    super.initState();
    _reading = widget.api.fetchSensorData(widget.token, widget.device.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor: ${widget.device.name}')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FutureBuilder<SensorReading>(
          future: _reading,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }
            final r = snap.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(label: 'Type', value: r.readingType),
                InfoRow(label: 'Value', value: r.value.toString()),
                InfoRow(
                  label: 'Time',
                  value: r.timestamp.toLocal().toString(),
                ),
                if (r.location != null)
                  InfoRow(label: 'Location', value: r.location!),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () => setState(() {
                    _reading = widget.api
                        .fetchSensorData(widget.token, widget.device.id);
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label, value;
  const InfoRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          SizedBox(
              width: 100.w,
              child: Text('$label:',
                  style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
