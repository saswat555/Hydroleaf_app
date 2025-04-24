// lib/src/ui/screens/farm_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FarmDetailScreen extends StatelessWidget {
  final int farmId;
  const FarmDetailScreen({Key? key, required this.farmId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final data = [
      charts.Series<int, int>(
        id: 'PH',
        data: [6, 6, 6, 6],
        domainFn: (v, i) => i!,
        measureFn: (v, _) => v,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Farm $farmId Details')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sensor Trends',
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16.h),
            Expanded(
              child: charts.LineChart(data),
            ),
          ],
        ),
      ),
    );
  }
}
