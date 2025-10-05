import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/blocs/user_role/user_role_event.dart';
import 'package:stream_line/blocs/user_role/user_role_state.dart';
import 'package:stream_line/repo/user_repository.dart';

class UserRoleBloc extends Bloc<UserRoleEvent, UserRoleState> {
  final UserRepository userRepository;

  UserRoleBloc(this.userRepository) : super(UserRoleIntial()) {
    on<LoadUserRole>(_loadUserRole);
  }

  Future<void> _loadUserRole(
      LoadUserRole event, Emitter<UserRoleState> emit) async {
    emit(UserRoleLoading());
    try {
      final role = await userRepository.getUserRole();
      if (role == null) {
        emit(UserRoleError("No Role Found"));
      } else {
        emit(UserRoleLoaded(role.toString()));
      }
    } catch (e) {
      emit(UserRoleError("No Role Found"));
    }
  }
}
