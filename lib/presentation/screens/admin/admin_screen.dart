import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/incident/incident_bloc.dart';
import '../../../bloc/incident/incident_event.dart';
import '../../../bloc/incident/incident_state.dart';
import '../../../core/constants/app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<IncidentBloc>().add(IncidentLoadRequested());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.broadcast_on_personal),
            onPressed: () => _showBroadcastDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<IncidentBloc, IncidentState>(
        builder: (context, state) {
          if (state is IncidentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is IncidentLoaded) {
            return Column(
              children: [
                _buildStatsRow(state.incidents),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.incidents.length,
                    itemBuilder: (context, index) {
                      final incident = state.incidents[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    incident.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: incident.severity == 'critical'
                                        ? Colors.red.shade100
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    incident.severity.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: incident.severity == 'critical'
                                          ? Colors.red
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              incident.description,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildActionButton(
                                  'Verify',
                                  Colors.green,
                                  () => context
                                      .read<IncidentBloc>()
                                      .add(IncidentStatusUpdateRequested(
                                        incidentId: incident.id,
                                        status: 'investigating',
                                      )),
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  'Resolve',
                                  Colors.blue,
                                  () => context
                                      .read<IncidentBloc>()
                                      .add(IncidentStatusUpdateRequested(
                                        incidentId: incident.id,
                                        status: 'resolved',
                                      )),
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  'Flag',
                                  Colors.red,
                                  () => context
                                      .read<IncidentBloc>()
                                      .add(IncidentFlagRequested(
                                        incidentId: incident.id,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No incidents found'));
        },
      ),
    );
  }

  Widget _buildStatsRow(List incidents) {
    final ongoing =
        incidents.where((i) => i.status == 'ongoing').length;
    final resolved =
        incidents.where((i) => i.status == 'resolved').length;
    final critical =
        incidents.where((i) => i.severity == 'critical').length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _buildStat('Total', incidents.length.toString(), AppColors.primary),
          _buildStat('Ongoing', ongoing.toString(), Colors.orange),
          _buildStat('Resolved', resolved.toString(), Colors.green),
          _buildStat('Critical', critical.toString(), Colors.red),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showBroadcastDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Broadcast Warning'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter emergency message...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Warning broadcast sent!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: const Text('Send',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}