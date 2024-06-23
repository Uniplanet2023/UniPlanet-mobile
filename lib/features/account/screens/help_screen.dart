import 'package:flutter/material.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/common/routes/names.dart';
import 'package:uniplanet/features/account/widgets/menu_section.dart';
import 'package:uniplanet/constants/text_size_formats.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DeleteUserCompleteState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.authPage, (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Help'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  'Contact us\n'),
              content(
                  'Should you have any inquiries regarding the uniplanet Marketplace app, or should you encounter any technical difficulties or bugs, please do not hesitate to reach out to us via website: '),
              content('https://uniplanet.shop/pages/contact-us.',
                  color: Colors.blue),
              content(
                  'We are committed to providing you with the best possible experience and appreciate your feedback.'),
              const Divider(
                thickness: 0.1,
              ),
              subTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nSelling a Product'),
              content(
                  'To list a product for sale, kindly follow these detailed instructions:\n\n 1. Proceed to the \'Sell\' page within the application.\n 2. Complete the provided form by uploading up to five images of the product, entering the product name, specifying the price (if the product is not offered for free), indicating the preferred meeting location for product exchange, providing a detailed description, and selecting the appropriate product category.\n 3. Once all pertinent information is accurately filled in, click on the \'Sell\' button located at the bottom of the page to officially list your product on the marketplace.\n 4. Potential buyers will reach out to you regarding the product, and these communications will be accessible under the \'Selling\' tab within the \'Chat\' screen.\n 5. In the event of multiple interested buyers, select a prospective buyer and arrange a meeting time and location for the product exchange.\n 6. Upon receipt of payment for the product (applicable for non-free products), proceed to hand over the product to complete the transaction.\n 7. Following the successful completion of the transaction, ensure to remove the listing from the marketplace.\n\n This process is designed to be straightforward and secure, facilitating a smooth transaction between you and the buyer.'),
              secondarySubTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nEditing listed Product information'),
              content(
                  '\nTo update the price or modify details of your product listing, please follow these steps:\n'
                  '1. Navigate to the \'Profile\' page.\n'
                  '2. Access \'My Listings\' to view your current product listings.\n'
                  '3. Select the listing you wish to modify. Slide the listing item to the left to reveal the \'Edit\' button, then tap it to modify the product information.\n'
                  '4. After adjusting the details as needed, tap \'Edit\' to apply your changes.\n\n'
                  'This procedure ensures that your product listings are always accurate and up-to-date, reflecting the most current information for potential buyers.'),
              secondarySubTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nRemoving Product from the market'),
              content(
                  '\nTo withdraw a product listing from the marketplace, please execute the following steps:\n 1. Proceed to the \'Profile\' page.\n 2. Select \'My Listings\' to review your active product listings.\n 3. Click on the \'Remove from Market\' option to initiate the removal of the product listing.\n 4. Confirm your intention by selecting the \'Remove\' button.\n\nThis process ensures that your product is promptly removed from the marketplace, allowing you to manage your listings effectively and maintain an up-to-date offering to potential buyers.'),
              secondarySubTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nDeleting a Product from the App'),
              content(
                  '\nTo permanently remove a product from your sales history, kindly follow these steps:\n'
                  '1. Navigate to the \'Profile\' page.\n'
                  '2. Access \'Sold Products\' or \'My Listings\' to review your products.\n'
                  '3. For the product you wish to remove, slide the item from right to left to reveal the \'Remove\' button.\n'
                  '4. Confirm your decision by selecting the \'Delete\' button.\n\n'
                  'By following these steps, you can efficiently manage your sales history and ensure that only relevant and up-to-date information is retained in your records.'),
              const Divider(
                thickness: 0.1,
              ),
              subTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nBuying a Product'),
              content(
                  '\nTo purchase a product, please adhere to the following steps:\n 1. Navigate to the \'Home\' page and select your desired product, which will redirect you to the Product Detail page.\n 2. Click the \'Chat\' button located at the bottom right of the Product Detail page to initiate a conversation with the seller regarding the product.\n 3. Once an agreement has been reached concerning the sale of the product, coordinate a suitable time and location for the transaction with the seller.value.\n 4. Upon verifying that the product\'s condition matches its advertisement, proceed with payment (unless the product is offered at no cost) and collect the item. '),
              const Divider(
                thickness: 0.1,
              ),
              secondarySubTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nMarking a Product as On Sale or Sold'),
              content(
                  '\nTo update the status of your product to "On Sale" or "Sold", please follow these steps:\n'
                  '1. Navigate to the \'Profile\' page.\n'
                  '2. Go to either \'Sold\' or \'My Listings\' to locate the product you wish to update.\n'
                  '3. Slide the item from left to right across the entire width of the screen to change its status.\n\n'
                  'Following these steps will allow you to efficiently manage the status of your products.'),
              const Divider(
                thickness: 0.1,
              ),
              subTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nEnable/Disable notifications'),
              content(
                  'To modify your notification preferences, please navigate through the following path: \nProfile -> Account Settings -> Notifications.'),
              subTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nEdit Profile'),
              secondarySubTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nChange name and Password'),
              content(
                  'To modify your name and Password, please navigate through the following path: \nProfile -> Account Settings.'),
              secondarySubTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nChange Profile Picture'),
              content(
                  'To update your profile picture, please follow these steps: Open your Profile, tap on your current profile picture avatar, and then select a new image from your photo gallery.'),
              subTitleText(
                  color: Theme.of(context).colorScheme.tertiary,
                  '\nDelete Account'),
              content(
                  'To permanently remove all your data from our system, you may proceed with deleting your account. Please be advised that this action is irreversible. \n'
                  'To initiate the account deletion process, kindly click on the "Delete Account" button provided below. \n'
                  'Your data will be permanently removed 7 days later. If you sign in before this period ends, the deletion request will be cancelled, and your data will remain in our system.\n'),
              Material(
                elevation: 0.2,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    MenuSection(
                      title: 'Delete Account',
                      icon: Icons.delete_forever_outlined,
                      color: Colors.red,
                      ontap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Icon(
                                Icons.warning_amber,
                                color: Colors.red,
                                size: 50,
                              ),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Do you want really to delete your account? You will not be able to undo this action.',
                                    style: TextStyle(
                                        overflow: TextOverflow.visible),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<AuthBloc>()
                                        .add(const DeleteUserEvent());
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
