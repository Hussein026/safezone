import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/incident_model.dart';
import 'severity_badge.dart';

class IncidentCard extends StatelessWidget {
  final IncidentModel incident;
  final VoidCallback? onTap;

  const IncidentCard({
    super.key,
    required this.incident,
    this.onTap,
  });

  IconData get _categoryIcon {
    switch (incident.category.toLowerCase()) {
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

  Color get _categoryColor {
    switch (incident.category.toLowerCase()) {
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

  String get _timeAgo {
    final now = DateTime.now();
    final diff = now.difference(incident.createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_categoryIcon, color: _categoryColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
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
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SeverityBadge(severity: incident.severity),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    incident.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 12, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.thumb_up_outlined,
                          size: 12, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${incident.confirmations}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: incident.status == 'ongoing'
                              ? AppColors.ongoing.withOpacity(0.1)
                              : incident.status == 'resolved'
                                  ? AppColors.resolved.withOpacity(0.1)
                                  : AppColors.investigating.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          incident.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: incident.status == 'ongoing'
                                ? AppColors.ongoing
                                : incident.status == 'resolved'
                                    ? AppColors.resolved
                                    : AppColors.investigating,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}