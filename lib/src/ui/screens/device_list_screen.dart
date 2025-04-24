// lib/src/screens/device_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/routes.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:hydroleaf_app/src/services/models.dart';

class DeviceListScreen extends StatefulWidget {
  static var routeName = Routes.deviceList;

  final ApiService apiService;
  final String token;

  const DeviceListScreen({
    Key? key,
    required this.apiService,
    required this.token,
  }) : super(key: key);

  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  late Future<List<DeviceResponse>> _futureDevices;

  @override
  void initState() {
    super.initState();
    _futureDevices = widget.apiService.fetchDevices(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Devices')),
      body: FutureBuilder<List<DeviceResponse>>(
        future: _futureDevices,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final devices = snap.data!;
          if (devices.isEmpty) {
            return const Center(child: Text('No devices found.'));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: devices.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (ctx, i) {
              final d = devices[i];
              return ListTile(
                title: Text(d.name),
                subtitle: Text(d.type.toApi()),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.deviceDetail,
                  arguments: {'device': d, 'token': widget.token},
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          Routes.registerDevice,
          arguments: widget.token,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
