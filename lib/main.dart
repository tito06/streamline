import 'package:flutter/material.dart';
import 'package:stream_line/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: "https://guqviutqhcxakkqymxwf.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd1cXZpdXRxaGN4YWtrcXlteHdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0Mzk0MDcsImV4cCI6MjA3MzAxNTQwN30.ekcRT1w-a0oeBv-J5-yG1JD6uoAqqwDahgDlf4whezM");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
