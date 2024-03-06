import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc_event.dart';

void optRequest(BuildContext context, email) async {
  context.read<AuthBloc>().add(RequestOtpEvent(email));
}
