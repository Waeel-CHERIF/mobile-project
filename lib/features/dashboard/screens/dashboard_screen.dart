import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/providers/audio_provider.dart';
import 'package:audio_player_app/providers/user_provider.dart';
import 'package:audio_player_app/features/dashboard/widgets/listening_stats_card.dart';
import 'package:audio_player_app/features/dashboard/widgets/monthly_chart.dart';
import 'package:audio_player_app/features/dashboard/widgets/top_tracks_list.dart';
import 'package:audio_player_app/features/dashboard/widgets/monthly_goal_progress.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() { super.initState(); _loadData(); }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();
    final audioProvider = context.read<AudioProvider>();
    if (authProvider.currentUser != null) {
      final userId = authProvider.currentUser!.uid;
      userProvider.subscribeToStats(userId);
      userProvider.loadListeningStats(userId);
      audioProvider.loadCategories();
    }
  }

  Future<void> _editMonthlyGoal() async {
    final userProvider = context.read<UserProvider>();
    final controller = TextEditingController(text: userProvider.monthlyGoalHours.toString());
    final result = await showDialog<int>(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(AppStrings.setGoal, style: TextStyle(color: AppColors.textPrimary)),
      content: TextField(controller: controller, keyboardType: TextInputType.number, style: const TextStyle(color: AppColors.textPrimary), decoration: const InputDecoration(labelText: 'Hours per month', labelStyle: TextStyle(color: AppColors.textSecondary), border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => AppRouter.pop(context), child: const Text(AppStrings.cancel)),
        ElevatedButton(onPressed: () { final hours = int.tryParse(controller.text); if (hours != null && hours > 0) Navigator.of(context).pop(hours); }, child: const Text(AppStrings.save)),
      ],
    ));
    if (result != null) await userProvider.setMonthlyGoal(result);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final user = authProvider.currentUser;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(expandedHeight: 120, floating: true, backgroundColor: AppColors.background,
          flexibleSpace: FlexibleSpaceBar(title: Text(user.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)), titlePadding: const EdgeInsets.only(left: 16, bottom: 16)),
          actions: [
            IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => AppRouter.navigateTo(context, AppRouter.favorites)),
            IconButton(icon: const Icon(Icons.logout), onPressed: _showLogoutDialog),
          ],
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListeningStatsCard(totalListeningTime: userProvider.listeningStats?.totalListeningTime ?? Duration.zero, currentMonthHours: userProvider.currentMonthHours),
          const SizedBox(height: 24),
          MonthlyGoalProgress(currentHours: userProvider.currentMonthHours, goalHours: userProvider.monthlyGoalHours, onEditGoal: _editMonthlyGoal),
          const SizedBox(height: 24),
          MonthlyChart(dailyData: userProvider.listeningStats?.last7DaysData ?? {}),
          const SizedBox(height: 24),
          TopTracksList(topTracks: userProvider.listeningStats?.topTracks.map((e) => MapEntry(e.key, 'Track ${e.key}')).toList() ?? []),
          const SizedBox(height: 100),
        ]))),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => AppRouter.navigateTo(context, AppRouter.nowPlaying), icon: const Icon(Icons.play_arrow), label: const Text('Open Player'), backgroundColor: AppColors.primary),
    );
  }

  void _showLogoutDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Logout', style: TextStyle(color: AppColors.textPrimary)),
      content: const Text('Are you sure you want to logout?', style: TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => AppRouter.pop(context), child: const Text(AppStrings.cancel)),
        ElevatedButton(onPressed: () async { AppRouter.pop(context); await context.read<AuthProvider>().signOut(); if (!context.mounted) return; AppRouter.go(context, AppRouter.login); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: const Text('Logout')),
      ],
    ));
  }
}
