import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../../data/models/incident_model.dart';
class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.incidentsBox);
    await Hive.openBox(AppConstants.notificationsBox);
    await Hive.openBox(AppConstants.userBox);
  }

  // ─── INCIDENTS ──────────────────────────────────────

  static Future<void> cacheIncidents(List<IncidentModel> incidents) async {
    final box = Hive.box(AppConstants.incidentsBox);
    await box.clear();
    for (var incident in incidents) {
      await box.put(incident.id, incident.toMap());
    }
  }

  static List<IncidentModel> getCachedIncidents() {
    final box = Hive.box(AppConstants.incidentsBox);
    return box.values
        .map((e) => IncidentModel.fromMap(
            Map<String, dynamic>.from(e), e['id'] ?? ''))
        .toList();
  }

  // ─── DRAFT INCIDENTS ────────────────────────────────

  static Future<void> saveDraftIncident(Map<String, dynamic> draft) async {
    final box = Hive.box(AppConstants.incidentsBox);
    await box.put('draft', draft);
  }

  static Map<String, dynamic>? getDraftIncident() {
    final box = Hive.box(AppConstants.incidentsBox);
    final draft = box.get('draft');
    if (draft == null) return null;
    return Map<String, dynamic>.from(draft);
  }

  static Future<void> clearDraftIncident() async {
    final box = Hive.box(AppConstants.incidentsBox);
    await box.delete('draft');
  }

  // ─── USER ────────────────────────────────────────────

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final box = Hive.box(AppConstants.userBox);
    await box.put('current_user', user);
  }

  static Map<String, dynamic>? getUser() {
    final box = Hive.box(AppConstants.userBox);
    final user = box.get('current_user');
    if (user == null) return null;
    return Map<String, dynamic>.from(user);
  }

  static Future<void> clearUser() async {
    final box = Hive.box(AppConstants.userBox);
    await box.delete('current_user');
  }
}