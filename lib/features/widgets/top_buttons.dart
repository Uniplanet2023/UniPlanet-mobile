// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uniket/bloc/auth-bloc/auth-bloc.dart';
// import 'package:uniket/bloc/userBloc/user_bloc.dart';
// import 'package:uniket/features/account/widgets/account_button.dart';
// import 'package:uniket/repository/user_repo.dart';

// class TopButtons extends StatelessWidget {
//   const TopButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             AccountButton(
//               text: 'Your Orders',
//               onTap: () {},
//             ),
//             AccountButton(
//               text: 'Turn Seller',
//               onTap: () {},
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             AccountButton(
//                 text: 'Log Out',
//                 onTap: () => context.read<AuthBloc>().add(const LogoutEvent())),
//             AccountButton(
//               text: 'Your Wish List',
//               onTap: () {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
