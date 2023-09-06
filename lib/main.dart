import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_knows/blocs/auth_bloc/auth_bloc.dart';
import 'package:who_knows/blocs/auth_bloc/auth_state.dart';
import 'package:who_knows/repos/user_repo.dart';
import 'package:who_knows/screens/login.dart';
import 'package:who_knows/widgets/bottom_nav.dart';
import 'config/constants.dart';
import 'package:who_knows/widgets/general/app_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  WidgetsBinding.instance.addObserver(new AppHandler(null));
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository),
      child: WhoKnows(
        userRepository: userRepository,
      ),
    ),
  );
}

class WhoKnows extends StatelessWidget {
  final UserRepository _userRepository;

  WhoKnows({UserRepository userRepository}) : _userRepository = userRepository;

  final appSystemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: appTheme,
      systemNavigationBarIconBrightness: Brightness.light);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who Knows',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Humans",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure ||
              state is AuthenticationInitial) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              child: LoginScreen(
                userRepository: _userRepository,
              ),
              value: appSystemTheme,
            );
          }
          if (state is AuthenticationSuccess) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              child:BottomNav(startPage: 0, user: state.firebaseUser),
              value: appSystemTheme,
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Center(
                child: Text("loading..."),
              ),
            ),
          );
        },
      ),
    );
  }
}
