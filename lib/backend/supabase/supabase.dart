import 'package:supabase_flutter/supabase_flutter.dart';
export 'database/database.dart';

String _kSupabaseUrl = 'https://skohfcmzfaenqtapsxub.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNrb2hmY216ZmFlbnF0YXBzeHViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4MDA3NzUsImV4cCI6MjA3ODM3Njc3NX0.y0IPlmM7v9h39jyUsegkcI0dAZCFsuKns4T3OpFnIIg';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: _kSupabaseAnonKey,
        debug: true,
        authOptions:
            const FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
      );
}
