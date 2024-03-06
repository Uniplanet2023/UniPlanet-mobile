import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc_event.dart';

void signInUser(email, password, context) async {
  context
      .read<AuthBloc>()
      .add(SignInEvent(email, password)); //add is trigger SignInEvent
}
