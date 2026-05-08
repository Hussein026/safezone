import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../bloc/incident/incident_bloc.dart';
import '../../../bloc/incident/incident_event.dart';
import '../../../bloc/incident/incident_state.dart';
import '../../../data/models/incident_model.dart';
import '../../widgets/incident_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = ['All', 'Theft', 'Fire', 'Accident', 'Medical'];

  @override
  void initState() {
    super.initState();
    context.read<IncidentBloc>().add(IncidentLoadRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IncidentModel> _applyFilters(List<IncidentModel> incidents) {
    List<IncidentModel> filtered = List.from(incidents);
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((i) =>
              i.category.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((i) =>
              i.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              i.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SafeZone Feed',
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.black),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<IncidentBloc, IncidentState>(
        builder: (context, state) {
          if (state is IncidentLoaded && state.isOffline) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.orange.shade100,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off,
                          color: Colors.orange.shade800, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'You are offline. Showing cached data.',
                        style: TextStyle(
                            color: Colors.orange.shade800, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          }
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, IncidentState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search incidents...',
              hintStyle:
                  const TextStyle(fontSize: 14, color: AppColors.grey),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.grey),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildList(context, state),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, IncidentState state) {
    if (state is IncidentLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state is IncidentError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppColors.grey),
            const SizedBox(height: 12),
            Text(state.message,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.grey),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<IncidentBloc>()
                  .add(IncidentLoadRequested()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state is IncidentLoaded) {
      final filtered = _applyFilters(state.incidents);
      if (filtered.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined,
                  size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No results for "$_searchQuery"'
                    : 'No incidents in this category',
                style: const TextStyle(
                    fontSize: 14, color: AppColors.grey),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          context.read<IncidentBloc>().add(IncidentLoadRequested());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final incident = filtered[index];
            return IncidentCard(
              incident: incident,
              onTap: () => Navigator.pushNamed(
                context,
                '/incident-detail',
                arguments: incident,
              ),
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }
}