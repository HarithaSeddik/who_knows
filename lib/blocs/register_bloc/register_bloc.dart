import 'package:who_knows/blocs/register_bloc/register_event.dart';
import 'package:who_knows/blocs/register_bloc/register_state.dart';
import 'package:who_knows/repos/user_repo.dart';
import 'package:who_knows/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc(UserRepository userRepository)
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChange) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<RegisterState> _mapLoginEmailChangeToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      {String email, String password}) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email, password);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
