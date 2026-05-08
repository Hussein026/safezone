import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../bloc/notification/notification_bloc.dart';
import '../../../bloc/notification/notification_event.dart';
import '../../../bloc/notification/notification_state.dart';
import '../../../data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  Color _getBorderColor(String type) {
    switch (type.toLowerCase()) {
      case 'critical':
        return Colors.red.shade700;
      case 'high':
        return Colors.orange.shade600;
      case 'medium':
        return Colors.amber.shade500;
      case 'low':
        return Colors.green.shade500;
      default:
        return AppColors.primary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'critical':
        return Icons.warning_rounded;
      case 'high':
        return Icons.notification_important;
      case 'medium':
        return Icons.info_outline;
      case 'low':
        return Icons.check_circle_outline;
      default:
        return Icons.notifications_outlined;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.notifications.isNotEmpty) {
                return TextButton(
                  onPressed: () =>
                      context.read<NotificationBloc>().add(ClearAllNotifications()),
                  child: const Text(
                    'Clear all',
                    style: TextStyle(color: AppColors.primary, fontSize: 14),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.grey),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: const TextStyle(fontSize: 14, color: AppColors.grey)),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined,
                        size: 72, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    const Text(
                      'No notifications yet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You're all caught up!",
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final borderColor = _getBorderColor(notif.type);

                return GestureDetector(
                  onTap: () {
                    if (!notif.isRead) {
                      context
                          .read<NotificationBloc>()
                          .add(MarkNotificationAsRead(notif.id));
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: notif.isRead
                          ? Border.all(color: Colors.grey.shade100)
                          : Border(
                              left: BorderSide(color: borderColor, width: 4),
                              top: BorderSide(color: Colors.grey.shade100),
                              right: BorderSide(color: Colors.grey.shade100),
                              bottom: BorderSide(color: Colors.grey.shade100),
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: borderColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(_getTypeIcon(notif.type),
                                color: borderColor, size: 20),
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
                                        notif.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: notif.isRead
                                              ? FontWeight.w400
                                              : FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                    if (!notif.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: borderColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.body,
                                  style: const TextStyle(fontSize: 12, color: AppColors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _timeAgo(notif.createdAt),
                                  style: const TextStyle(fontSize: 12, color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}