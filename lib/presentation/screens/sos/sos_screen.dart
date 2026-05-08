import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/sos/sos_bloc.dart';
import '../../../bloc/sos/sos_event.dart';
import '../../../bloc/sos/sos_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/location_service.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _isCountingDown = false;
  int _countdown = 3;

  void _startSos() async {
    setState(() {
      _isCountingDown = true;
      _countdown = 3;
    });
    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _countdown = i - 1);
    }
    final position = await LocationService.getCurrentLocation();
    if (!mounted) return;
    context.read<SosBloc>().add(SosActivated(
          latitude: position?.latitude ?? 0,
          longitude: position?.longitude ?? 0,
        ));
    setState(() => _isCountingDown = false);
  }

  void _cancelSos() {
    setState(() => _isCountingDown = false);
    context.read<SosBloc>().add(SosCancelled());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SOS Emergency'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SosBloc, SosState>(
        listener: (context, state) {
          if (state is SosActive) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SOS Alert Sent! Help is on the way.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is SosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (state is SosActive)
                  _buildActiveView()
                else
                  _buildMainView(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainView() {
    return Column(
      children: [
        const Text(
          'Emergency SOS',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hold the button for 3 seconds\nto send emergency alert',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey),
        ),
        const SizedBox(height: 60),
        GestureDetector(
          onLongPressStart: (_) => _startSos(),
          onLongPressEnd: (_) {
            if (_isCountingDown) _cancelSos();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isCountingDown ? 180 : 160,
            height: _isCountingDown ? 180 : 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: _isCountingDown ? 30 : 15,
                  spreadRadius: _isCountingDown ? 10 : 5,
                ),
              ],
            ),
            child: Center(
              child: _isCountingDown
                  ? Text(
                      '$_countdown',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sos, size: 60, color: Colors.white),
                        Text(
                          'HOLD',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.call),
            label: const Text(
              'Call 112',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        _buildFirstAidSection(),
      ],
    );
  }

  Widget _buildActiveView() {
    return Column(
      children: [
        const Icon(Icons.sos, size: 100, color: AppColors.primary),
        const SizedBox(height: 24),
        const Text(
          'SOS Alert Active!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your location has been shared\nwith emergency contacts',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _cancelSos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "I'm Safe - Cancel SOS",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstAidSection() {
    final tips = [
      {'icon': Icons.favorite, 'title': 'CPR', 'desc': '30 compressions, 2 breaths'},
      {'icon': Icons.healing, 'title': 'Bleeding', 'desc': 'Apply firm pressure to wound'},
      {'icon': Icons.local_fire_department, 'title': 'Burns', 'desc': 'Cool with water for 10 mins'},
      {'icon': Icons.air, 'title': 'Choking', 'desc': '5 back blows, 5 abdominal thrusts'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'First Aid Guide',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...tips.map((tip) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(tip['icon'] as IconData,
                      color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(tip['desc'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.grey)),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}