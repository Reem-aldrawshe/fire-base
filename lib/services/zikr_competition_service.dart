import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/zikr_competition.dart';

class ZikrCompetitionService {
  final supabase = Supabase.instance.client;

  Future<ZikrCompetition> createZikrCompetition(ZikrCompetition newComp) async {
    final response = await supabase
        .from('zikr_challenges')
        .insert(newComp.toMap())
        .select()
        .single();

    return ZikrCompetition.fromMap(response);
  }

  Future<ZikrCompetition?> getLatestUncompletedCompetition() async {
    final response = await supabase
        .from('zikr_challenges')
        .select()
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;

    final comp = ZikrCompetition.fromMap(response);

    if (comp.completedCount >= comp.targetCount) return null;

    return comp;
  }

  Future<void> updateCompletedCount(int id, int newCompleted) async {
    await supabase
        .from('zikr_challenges')
        .update({'completed_count': newCompleted}) 
        .eq('id', id);
  }

  Future<void> markCompetitionAsCompleted(int id) async {
    await supabase
        .from('zikr_challenges')
        .update({'completed_count': 999999})
        .eq('id', id);
  }
}
