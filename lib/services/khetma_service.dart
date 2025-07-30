import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/khetma.dart';

class KhetmaService {
  final supabase = Supabase.instance.client;

  Future<List<Khetma>> getKhetmas({required bool isPublic}) async {
    final res = await supabase
        .from('serag')
        .select()
        .eq('is_public', isPublic)
        .order('created_at');

    return (res as List).map((e) => Khetma.fromMap(e)).toList();
  }

  Future<int> addKhetma(Khetma khetma) async {
    final response = await supabase
        .from('serag')
        .insert(khetma.toMap())
        .select('id')
        .single();

    return response['id'];
  }
}
