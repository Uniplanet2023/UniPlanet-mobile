import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserRepository.getUser(context);

    return Container(
      height: 40,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 114, 226, 221),
            Color.fromARGB(255, 162, 236, 233),
          ],
          stops: [0.5, 1.0],
        ),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: const Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                // 'Delivery to ${user.name} - ${user.address}',
                '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5,
              top: 2,
            ),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}
