// lib/src/ui/screens/dashboard_screen.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/providers/auth_provider.dart';
import 'package:hydroleaf_app/src/routes.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:provider/provider.dart';
import 'farm_list_screen.dart';
import '../widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<void> _statsFuture;
  int _farmCount = 0;
  int _deviceCount = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<void> _loadStats() async {
    final api = context.read<ApiService>();
    final token = context.read<AuthProvider>().token!;
    try {
      final farms = await api.fetchFarms(token);
      final devices = await api.fetchDevices(token);
      setState(() {
        _farmCount = farms.length;
        _deviceCount = devices.length;
      });
    } catch (e) {
      setState(() => _error = 'Failed to load stats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FutureBuilder(
          future: _statsFuture,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_error != null) {
              return Center(child: Text(_error!));
            }
            return Column(
              children: [
                SummaryCard(
                  title: 'Total Farms',
                  value: '$_farmCount',
                  icon: Icons.agriculture,
                ),
                SizedBox(height: 16.h),
                SummaryCard(
                  title: 'Active Devices',
                  value: '$_deviceCount',
                  icon: Icons.memory,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.list),
                  label: const Text('Manage Farms'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.farmList),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
