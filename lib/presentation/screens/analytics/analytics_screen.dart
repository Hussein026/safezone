import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/incident/incident_bloc.dart';
import '../../../bloc/incident/incident_event.dart';
import '../../../bloc/incident/incident_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<IncidentBloc>().add(IncidentLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Safety Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<IncidentBloc, IncidentState>(
        builder: (context, state) {
          if (state is IncidentLoading) {
            return const Center(
                child: CircularProgressIndicator(
                    color: AppColors.primary));
          }
          if (state is IncidentLoaded) {
            return _buildAnalytics(context, state.incidents);
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildAnalytics(
      BuildContext context, List<IncidentModel> incidents) {
    final total = incidents.length;
    final ongoing =
        incidents.where((i) => i.status == 'ongoing').length;
    final resolved =
        incidents.where((i) => i.status == 'resolved').length;
    final critical =
        incidents.where((i) => i.severity == 'critical').length;

    final categoryCount = <String, int>{};
    for (final incident in incidents) {
      categoryCount[incident.category] =
          (categoryCount[incident.category] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSafetyScoreCard(),
          const SizedBox(height: 16),
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Total', total.toString(),
                  AppColors.primary, Icons.list_alt),
              const SizedBox(width: 12),
              _buildStatCard('Ongoing', ongoing.toString(),
                  Colors.orange, Icons.warning_outlined),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Resolved', resolved.toString(),
                  Colors.green, Icons.check_circle_outline),
              const SizedBox(width: 12),
              _buildStatCard('Critical', critical.toString(),
                  Colors.red, Icons.priority_high),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Incidents by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: categoryCount.isEmpty
                ? const Center(
                    child: Text('No incidents yet',
                        style: TextStyle(color: AppColors.grey)))
                : Column(
                    children: categoryCount.entries.map((entry) {
                      final percentage = total > 0
                          ? entry.value / total
                          : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${entry.value} (${(percentage * 100).toStringAsFixed(0)}%)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percentage,
                                backgroundColor:
                                    Colors.grey.shade200,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Incidents by Severity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSeverityCircle(
                  'Low',
                  incidents
                      .where((i) => i.severity == 'low')
                      .length,
                  AppColors.low,
                ),
                _buildSeverityCircle(
                  'Medium',
                  incidents
                      .where((i) => i.severity == 'medium')
                      .length,
                  AppColors.medium,
                ),
                _buildSeverityCircle(
                  'High',
                  incidents
                      .where((i) => i.severity == 'high')
                      .length,
                  AppColors.high,
                ),
                _buildSeverityCircle(
                  'Critical',
                  incidents
                      .where((i) => i.severity == 'critical')
                      .length,
                  AppColors.critical,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Peak Danger Hours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildHourBar('Morning (6-12)', 0.3),
                const SizedBox(height: 8),
                _buildHourBar('Afternoon (12-18)', 0.5),
                const SizedBox(height: 8),
                _buildHourBar('Evening (18-24)', 0.8),
                const SizedBox(height: 8),
                _buildHourBar('Night (0-6)', 0.6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Safety Score',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '72/100',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Moderate Risk — Stay Alert',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.shield,
            color: Colors.white54,
            size: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityCircle(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildHourBar(String label, double value) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                value > 0.6 ? AppColors.critical : AppColors.medium,
              ),
              minHeight: 10,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(value * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}