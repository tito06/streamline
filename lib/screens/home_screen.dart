import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/blocs/user_role/user_role_bloc.dart';
import 'package:stream_line/blocs/user_role/user_role_event.dart';
import 'package:stream_line/blocs/user_role/user_role_state.dart';
import 'package:stream_line/repo/user_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => UserRoleBloc(UserRepository())..add(LoadUserRole()),
        child:
            BlocBuilder<UserRoleBloc, UserRoleState>(builder: (context, state) {
          if (state is UserRoleLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserRoleLoaded) {
            print(state.role);
            if (state.role == "admin") {
              return Container(
                color: Colors.white,
                child: Text("ADMIN"),
              );
            } else {
              return Container(
                color: Colors.white,
                child: Text("No Role"),
              );
            }
          } else {
            return Container(
              color: Colors.white,
              child: Text("dadada"),
            );
          }
          return const SizedBox();
        }));
  }
}
