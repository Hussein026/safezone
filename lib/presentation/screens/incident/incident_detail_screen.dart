import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/incident/incident_bloc.dart';
import '../../../bloc/incident/incident_event.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';
import '../../widgets/severity_badge.dart';

class IncidentDetailScreen extends StatelessWidget {
  const IncidentDetailScreen({super.key});

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'theft':
        return Icons.security;
      case 'fire':
        return Icons.local_fire_department;
      case 'accident':
        return Icons.car_crash;
      case 'suspicious activity':
        return Icons.visibility;
      case 'medical emergency':
        return Icons.medical_services;
      case 'natural disaster':
        return Icons.storm;
      default:
        return Icons.warning;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'theft':
        return AppColors.theft;
      case 'fire':
        return AppColors.fire;
      case 'accident':
        return AppColors.accident;
      case 'suspicious activity':
        return AppColors.suspicious;
      case 'medical emergency':
        return AppColors.medical;
      case 'natural disaster':
        return AppColors.disaster;
      default:
        return AppColors.grey;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final incident =
        ModalRoute.of(context)!.settings.arguments as IncidentModel;
    final categoryColor = _getCategoryColor(incident.category);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Incident Detail'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              context
                  .read<IncidentBloc>()
                  .add(IncidentFlagRequested(incidentId: incident.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Incident flagged')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_getCategoryIcon(incident.category),
                            color: categoryColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              incident.category,
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              incident.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SeverityBadge(severity: incident.severity),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    incident.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _timeAgo(incident.createdAt),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.person_outline,
                          size: 14, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        incident.isAnonymous
                            ? 'Anonymous'
                            : incident.reportedBy ?? 'Unknown',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatusChip(
                        'Ongoing',
                        incident.status == 'ongoing',
                        AppColors.ongoing,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        'Investigating',
                        incident.status == 'investigating',
                        AppColors.investigating,
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        'Resolved',
                        incident.status == 'resolved',
                        AppColors.resolved,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Lat: ${incident.latitude.toStringAsFixed(4)}, Lng: ${incident.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    Icons.thumb_up_outlined,
                    'Confirm\n${incident.confirmations}',
                    AppColors.primary,
                    () {
                      context.read<IncidentBloc>().add(
                            IncidentConfirmRequested(
                                incidentId: incident.id),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Incident confirmed!')),
                      );
                    },
                  ),
                  _buildActionButton(
                    Icons.visibility_outlined,
                    'Witness',
                    Colors.blue,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Marked as witness!')),
                      );
                    },
                  ),
                  _buildActionButton(
                    Icons.share_outlined,
                    'Share',
                    Colors.green,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Sharing incident...')),
                      );
                    },
                  ),
                  _buildActionButton(
                    Icons.check_circle_outline,
                    'Resolved',
                    Colors.teal,
                    () {
                      context.read<IncidentBloc>().add(
                            IncidentStatusUpdateRequested(
                              incidentId: incident.id,
                              status: 'resolved',
                            ),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Marked as resolved!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.15) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color : Colors.grey.shade300,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? color : AppColors.grey,
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}