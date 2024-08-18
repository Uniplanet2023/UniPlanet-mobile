import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uniplanet/core/dependency_injection/auth.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/selectable_text.dart';
import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';
import 'package:uniplanet/features/housing/presentation/screens/full_image_page.dart';

class HousingDetailPage extends StatelessWidget {
  final HousingPost housing;

  const HousingDetailPage({super.key, required this.housing});

  @override
  Widget build(BuildContext context) {
    User user = getIt<AccountBloc>().state.account.user;
    return BlocListener<ChatBloc, ChatBlocState>(
      listener: (context, state) {
        if (state is CreatedChatRoomState) {
          Navigator.pushNamed(context, AppRoutes.chatPage, arguments: {
            "seller": state.chatRoomCreated.seller,
            "chatRoom": state.chatRoomCreated
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: List.generate(housing.images.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              imageUrls: housing.images,
                              initialIndex: index,
                            ),
                          ));
                        },
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              width: double.infinity,
                              height: 300,
                              imageUrl: housing.images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            const SizedBox(height: 3),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 230),
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            '\$${housing.monthlyPayment.toString()}/mo',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(housing.title),
                          const SizedBox(height: 8),
                          SelectableText(
                            '${housing.address}, ${housing.city}, ${housing.stateAddress}, ${housing.zipCode}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              user.id != housing.seller.id
                                  ? Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Implement appointment request functionality
                                          getIt<ChatBloc>()
                                              .add(CreateChatRoomEvent(
                                            buyer: getIt<AccountBloc>()
                                                .state
                                                .account
                                                .user,
                                            seller: housing.seller,
                                            productId: housing.id!,
                                            productName: housing.title,
                                            type: 'housing',
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: const Text(
                                            'Request an appointment'),
                                      ),
                                    )
                                  : Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Implement appointment request functionality
                                          getIt<GetHousingBloc>().add(
                                              DeleteHousingPostEvent(
                                                  id: housing.id!));
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Gender
                          RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: "Gender: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: housing.gender,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          //Property Details
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(
                              text: 'Property Type: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: housing.category,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ])),
                          const SizedBox(height: 16),
                          //Utility
                          RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: 'Utility: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: housing.isUtilityIncluded
                                    ? 'Included'
                                    : 'Not included',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: 'Security Deposit: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '\$${housing.securityDeposit}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Amenities:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          housing.housingConditions.isEmpty
                              ? const Text('No amenities')
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: housing.housingConditions
                                      .map((e) => Chip(label: Text(e)))
                                      .toList(),
                                ),
                          const SizedBox(height: 16),
                          const Text(
                            'Details:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableLinkText(
                            text: housing.description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40.0,
              left: 16.0,
              right: 16.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.black87),
                      onPressed: () async {
                        final tempDir = await getTemporaryDirectory();
                        final imagePath = '${tempDir.path}/temp_image.jpg';
                        final response = await DioHelper.instance.dio.get(
                          housing.images[0],
                          options: Options(responseType: ResponseType.bytes),
                        );
                        final file = File(imagePath);
                        await file.writeAsBytes(response.data);

                        // Share functionality here
                        const url = 'https://uniplanet.shop/';
                        final text = 'Check out this housing post:\n\n'
                            'Title: ${housing.title}\n'
                            'Location: ${housing.address}, ${housing.city}, ${housing.stateAddress}, ${housing.zipCode} \n'
                            'Monthly Payment: \$${housing.monthlyPayment}/mo\n'
                            'Category: ${housing.category}\n'
                            'Description: ${housing.description}\n\n'
                            'Download APP URL: $url';
                        Share.shareXFiles([XFile(imagePath)], text: text);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
