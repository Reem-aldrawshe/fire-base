import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/khetma.dart';

class KhetmaService {
  final supabase = Supabase.instance.client;

  Future<List<Khetma>> getKhetmas() async {
  final res = await supabase
      .from('serag')
      .select()
      .order('created_at');

  print(res);

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
