// lib/src/screens/device_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/routes.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:hydroleaf_app/src/services/models.dart';

class DeviceDetailScreen extends StatelessWidget {
  static const routeName = Routes.deviceDetail;

  final ApiService api;
  final String token;
  final DeviceResponse device;

  const DeviceDetailScreen({
    Key? key,
    required this.api,
    required this.token,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(label: 'ID', value: device.id.toString()),
            InfoRow(label: 'Type', value: device.type.toApi()),
            InfoRow(label: 'Endpoint', value: device.httpEndpoint),
            InfoRow(
                label: 'Location', value: device.locationDescription ?? '—'),
            InfoRow(label: 'Active', value: device.isActive ? 'Yes' : 'No'),
            InfoRow(label: 'Firmware', value: device.firmwareVersion ?? '—'),
            InfoRow(
              label: 'Last Seen',
              value: device.lastSeen != null
                  ? device.lastSeen!.toLocal().toString()
                  : 'Never',
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.sensors),
                    label: const Text('Sensor'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.sensor,
                        arguments: {
                          'api': api,
                          'token': token,
                          'deviceId': device.id,
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.local_drink),
                    label: const Text('Dosing'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.dosing,
                        arguments: {
                          'api': api,
                          'token': token,
                          'device': device,
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
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
