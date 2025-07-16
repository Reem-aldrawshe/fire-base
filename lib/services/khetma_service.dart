import 'package:serag_app/models/khetma.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KhetmaService {
  final supabase = Supabase.instance.client;

  Future<List<Khetma>> getKhetmas() async {
    final res = await supabase.from('Khetma').select().order('created_at');
    return (res as List).map((e) => Khetma.fromMap(e)).toList();
  }

  Future<void> addKhetma(Khetma khatma) async {
    await supabase.from('khatma').insert(khatma.toMap());
  }
}
