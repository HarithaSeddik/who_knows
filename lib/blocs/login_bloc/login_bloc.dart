import 'package:firebase_auth/firebase_auth.dart';
import 'package:who_knows/blocs/login_bloc/login_event.dart';
import 'package:who_knows/blocs/login_bloc/login_state.dart';
import 'package:who_knows/repos/user_repo.dart';
import 'package:who_knows/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //final UserRepository _userRepository;

  LoginBloc(UserRepository userRepository)
      : //_userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChange) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginEmailChangeToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield LoginState.loading();
    try {
      String uid = await UserRepository(firebaseAuth: FirebaseAuth.instance).signInWithCredentials(email, password);
      if (uid == null) yield LoginState.failure().copyWith(isVerified: false);
      else yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
