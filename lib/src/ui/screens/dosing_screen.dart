// lib/src/screens/dosing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/routes.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:hydroleaf_app/src/services/models.dart';

class DosingScreen extends StatefulWidget {
  static const routeName = Routes.dosing;

  final ApiService api;
  final String token;
  final int deviceId;
  const DosingScreen(
      {Key? key,
      required this.api,
      required this.token,
      required this.deviceId})
      : super(key: key);

  @override
  _DosingScreenState createState() => _DosingScreenState();
}

class _DosingScreenState extends State<DosingScreen> {
  late Future<List<DosingOperation>> _history;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _history = widget.api.fetchDosingHistory(widget.token, widget.deviceId);
  }

  Future<void> _runDosing() async {
    setState(() => _running = true);
    try {
      final result =
          await widget.api.executeDosing(widget.token, widget.deviceId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dosing run: ${result.status}')),
      );
      _loadHistory();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $err')),
      );
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dosing: ${widget.deviceId}')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FutureBuilder<List<DosingOperation>>(
          future: _history,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }
            final ops = snap.data!;
            if (ops.isEmpty) {
              return const Center(child: Text('No dosing history.'));
            }
            return ListView.separated(
              itemCount: ops.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (ctx, i) {
                final op = ops[i];
                return ExpansionTile(
                  title: Text(op.timestamp.toLocal().toString()),
                  subtitle: Text(op.status),
                  children: op.actions.map((a) {
                    return ListTile(
                      title: Text('${a.chemicalName} (Pump ${a.pumpNumber})'),
                      subtitle: Text('${a.doseMl} ml – ${a.reasoning}'),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _running ? null : _runDosing,
        icon: _running
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.play_arrow),
        label: const Text('Run Dosing'),
      ),
    );
  }
}
