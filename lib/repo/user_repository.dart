import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final supabase = Supabase.instance.client;

  Future<String?> getUserRole() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    print("Current user ID: ${user?.id}");
    if (user == null) return null;

    final response = await supabase
        .from('profiles')
        .select('role') // select only the role column
        .eq('id', user.id)
        .maybeSingle();

    print("Supabase role response raw: $response");

    // response might be null or Map<String, dynamic>
    if (response != null) {
      final role = response['role'];
      print("Role found: $role");
      return role as String?;
    }

    return null;
  }
}
