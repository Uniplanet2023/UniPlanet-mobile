import 'package:uniplanet_mobile/bloc/auth-bloc/auth-bloc.dart';

void signInUser(email, password, context) async {
  context
      .read<AuthBloc>()
      .add(SignInEvent(email, password)); //add is trigger SignInEvent
}
