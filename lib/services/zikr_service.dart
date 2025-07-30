import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/zikr.dart'; 

class ZikrService {
  final SupabaseClient supabase = Supabase.instance.client;
  final String tableName = 'zikr'; 

  Future<List<Zikr>> getZikrs() async {
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from(tableName)
          .select()
          .order('created_at', ascending: false);

      return response.map((map) => Zikr.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching zikrs: $e');
      rethrow;
    }
  }

  Future<void> addZikr(Zikr zikr) async {
    try {
      await supabase.from(tableName).insert(zikr.toMap());
      print('Zikr added successfully: ${zikr.name}');
    } catch (e) {
      print('Error adding zikr: $e');
      rethrow;
    }
  }

  Future<void> updateZikrCompletedCount(int zikrId, int newCount) async {
    try {
      await supabase
          .from(tableName)
          .update({'completed_count': newCount}).eq('id', zikrId);
      print('Zikr $zikrId completed count updated to $newCount');
    } catch (e) {
      print('Error updating zikr completed count: $e');
      rethrow;
    }
  }
}