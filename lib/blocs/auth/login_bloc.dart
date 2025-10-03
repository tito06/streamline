
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/blocs/auth/login_event.dart';
import 'package:stream_line/blocs/auth/login_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<OnLogin>(_onLogin);
  }

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> _onLogin(OnLogin event, Emitter<LoginState> emit) async {
    emit(OnLoading());

    try {
      final response = await _supabaseClient.auth
          .signInWithPassword(email: event.username, password: event.password);

      if (response.user != null) {
        emit(OnSuccess(response.user!.id));
      } else {
        emit(OnFailure("Something went wrong."));
      }
    } catch (e) {
      emit(OnFailure(e.toString()));
    }
  }
}
