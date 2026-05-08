import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CommunityGroup {
  final String id;
  final String name;
  final int membersCount;
  final double safetyScore;
  final String neighborhood;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.membersCount,
    required this.safetyScore,
    required this.neighborhood,
  });
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Mock data — replace with real BLoC/repo when available
  final List<CommunityGroup> _groups = [
    CommunityGroup(id: '1', name: 'Downtown Watch', membersCount: 42, safetyScore: 8.4, neighborhood: 'Downtown'),
    CommunityGroup(id: '2', name: 'Westside Patrol', membersCount: 27, safetyScore: 7.1, neighborhood: 'West Side'),
    CommunityGroup(id: '3', name: 'Northgate Safety', membersCount: 15, safetyScore: 9.0, neighborhood: 'Northgate'),
  ];

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final neighborhoodController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Create Group',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                labelStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: neighborhoodController,
              decoration: InputDecoration(
                labelText: 'Neighborhood',
                labelStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _groups.add(CommunityGroup(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    membersCount: 1,
                    safetyScore: 0.0,
                    neighborhood: neighborhoodController.text.trim().isEmpty
                        ? 'Unknown'
                        : neighborhoodController.text.trim(),
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinGroupDialog() {
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Join with Code',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        content: TextField(
          controller: codeController,
          decoration: InputDecoration(
            labelText: 'Enter group code',
            labelStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Joining group with code: ${codeController.text}'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Color _safetyColor(double score) {
    if (score >= 8.0) return Colors.green.shade600;
    if (score >= 6.0) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Community',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _showJoinGroupDialog,
            icon: const Icon(Icons.group_add_outlined, color: AppColors.primary),
            tooltip: 'Join with code',
          ),
        ],
      ),
      body: _groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.groups_outlined, size: 72, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'No groups yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create or join a neighborhood watch group',
                    style: TextStyle(fontSize: 14, color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: _groups.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final group = _groups[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shield_outlined,
                              color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 12, color: AppColors.grey),
                                  const SizedBox(width: 2),
                                  Text(
                                    group.neighborhood,
                                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.people_outline,
                                      size: 12, color: AppColors.grey),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${group.membersCount} members',
                                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              group.safetyScore.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _safetyColor(group.safetyScore),
                              ),
                            ),
                            Text(
                              'Safety',
                              style: TextStyle(
                                fontSize: 12,
                                color: _safetyColor(group.safetyScore),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateGroupDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Group', style: TextStyle(fontSize: 14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}