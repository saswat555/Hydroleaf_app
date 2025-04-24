import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/providers/auth_provider.dart';
import 'package:hydroleaf_app/src/providers/farm_provider.dart';
import 'package:hydroleaf_app/src/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/routes.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:provider/provider.dart';

class FarmListScreen extends StatefulWidget {
  const FarmListScreen({Key? key}) : super(key: key);
  @override
  _FarmListScreenState createState() => _FarmListScreenState();
}

class _FarmListScreenState extends State<FarmListScreen> {
  late FarmProvider _farmProv;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _farmProv = context.read<FarmProvider>();
    if (_farmProv.farms.isEmpty) {
      _farmProv.loadFarms();
    }
  }

  Future<void> _refresh() => _farmProv.loadFarms();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Farms')),
      body: Consumer<FarmProvider>(
        builder: (ctx, prov, _) {
          if (prov.farms.isEmpty) {
            return prov.farms.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : const Center(child: Text('No farms registered.'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: prov.farms.length,
              itemBuilder: (ctx, i) {
                final f = prov.farms[i];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(Icons.park,
                        color: Theme.of(context).colorScheme.primary),
                    title: Text(f.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(f.location ?? 'No location'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.farmDetail,
                      arguments: {'farmId': f.id},
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          Routes.registerFarm,
          arguments: {
            'apiService': context.read<ApiService>(),
            'token': context.read<AuthProvider>().token!,
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
