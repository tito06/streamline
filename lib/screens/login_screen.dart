import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/blocs/auth/login_bloc.dart';
import 'package:stream_line/blocs/auth/login_event.dart';
import 'package:stream_line/blocs/auth/login_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is OnFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }

          if (state is OnSuccess) {}
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(label: Text("Email")),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(label: Text("Password")),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (state is OnLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(OnLogin(
                            _emailController.text.trim(),
                            _passwordController.text.trim()));
                      },
                      child: const Text("Login"))
              ],
            ),
          );
        },
      ),
    );
  }
}
