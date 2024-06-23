import 'package:flutter/material.dart';
import 'package:uniplanet/constants/text_size_formats.dart';

class TermsAndPolicies extends StatelessWidget {
  const TermsAndPolicies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Terms and Policies'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ExpansionTile(
                title: const Text(
                  'Terms of Use',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('View uniplanet Marketplace Terms of Use'),
                children: <Widget>[
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'Terms of Use'),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'INTRODUCTION'),
                        content(
                            '1. Welcome to the uniplanet Marketplace. These Terms of Use apply when you are using the uniplanet Marketplace mobile application (“App”) from within the United States of America. Please read these Terms of Use carefully.'),
                        content(
                            '2. By downloading this App, you are agreeing to the following terms, including those available by hyperlink, which are designed to ensure the correct use of the App, and any associated services for everyone.'),
                        content(
                            '3. Your use of the App and any of its features is also subject to the Privacy Policy, Forbidden Items Policy and any other agreements applicable to you at uniplanet.shop these are collectively known as the “Terms”. If you do not agree to these Terms, do not use the App or any of our associated services.'),
                        content(
                            '4. In these Terms, “Service” means the service you connect via the App or the Website, and the content we provide to you through it.'),
                        content(
                            '5. These Terms constitute a legally binding agreement between you and uniplanet LLC and are effective as of 1st January 2024.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'LICENSE TO USE APP'),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'We license you to use:'),
                        content(
                            '1. the App and any updates or supplements to it;'),
                        content(
                            '2. any related online documentation. (“Documentation”); and'),
                        content('3. the Service as permitted in these Terms.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'DESCRIPTION OF THE SERVICE'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'The type, detail, and service charge of the Service are as follows:'),
                        content(
                            '1. Type: mobile service providing local information'),
                        content('2. Service Name: uniplanet marketplace'),
                        content(
                            '3. Description: The Service provides college students with the opportunity to join a school community market which allows the user to post information in relation to second hand goods the user wishes to buy or sell and shares the user’s location information in order to identify fellow student buyers and sellers. The Service also provides local lifestyle and advertising.'),
                        content(
                            '4. Service Charge: There is no service charge for using the Service. However, this is subject to clause 5 below.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'SERVICE CHARGE'),
                        content(
                            '1. The Service provided by us is either paid or free. Separate paid services can only be used after paying the fee as indicated in the relevant service.'),
                        content(
                            '2. We may invoice a service charge for any paid Service in accordance with any method established by an electronic payment service provider that entered into an agreement with us or add it to the invoice designated by us to invoice the amount. We will notify you at the time of the amount of the service charge and you will be able to review and accept the charge before you use the service.'),
                        content(
                            '3. The cancellation or refund of the payment authorized by the use of the paid service shall be governed by any terms notified to you prior to your purchase and relevant laws and regulations.'),
                        content(
                            '4. Any request for refunds or for disclosure of personal information of the person who authorized the payment on the grounds of personal identity theft or payment fraud will be considered by us but we are not obliged to provide any such information on request unless required by law.'),
                        content(
                            '5. Any data charge incurred by the use of wireless services is separate and is governed by the policy of your mobile carrier. Any fees incurred when a thread is posted via such means as MMS is governed by the policy of your mobile carrier.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'YOUR PRIVACY'),
                        content(
                            '1. Under data protection legislation, we are required to provide you with certain information about who we are, how we process your personal data and for what purposes and your rights in relation to your personal data and how to exercise them. This information is provided in privacy policies and it is important that you read that information.'),
                        content(
                            '2. Please be aware that internet transmissions are never completely private or secure and that any message or information you send using the App or any Service may be read or intercepted by others, even if there is a special notice that a particular transmission is encrypted.'),
                        content(
                            '3. By agreeing to these Terms, you warrant to us that in using the Service you will comply with all applicable Data Protection laws and regulations.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText('REFUND POLICY'),
                        secondarySubTitleText(
                            'UniPlanet Ads Credit Refund Policy'),
                        content(
                            'At UniPlanet, we strive to provide the best advertising experience for our users. However, we understand that there may be situations where you need to request a refund for your unused Ads Credit. Please read our refund policy carefully to understand how refunds are processed.'),
                        secondarySubTitleText('Refund Eligibility'),
                        content(
                            'Unused Credits: If you have purchased Ads Credit but have not used them for advertising, you may request a partial refund.'),
                        content(
                            'Partially Used Credits: If you have started using your Ads Credit but have not exhausted the full amount, you may still request a partial refund for the remaining balance.'),
                        secondarySubTitleText('Refund Process'),
                        content(
                            '1. Request Submission: To request a refund, please contact our support team at uniplanet.info@gmail.com with your account details and the amount of Ads Credit you wish to refund.'),
                        content(
                            '2. Refund Calculation: A partial refund will be issued for the unused portion of your Ads Credit.'),
                        content(
                            'A transaction fee of approximately 3% to 5% will be deducted from the refundable amount to cover the cost of transaction processing.'),
                        secondarySubTitleText('Refund Processing Time'),
                        content(
                            ' Refund requests are processed within 5 ~ 7 business days. The refunded amount will be credited back to your original payment method.'),
                        secondarySubTitleText('Advertising Campaigns'),
                        content(
                            'If you have already initiated advertising campaigns and spent some portion of your Ads Credit, the refund will only apply to the remaining unused balance.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText('APPSTORE\'S TERMS ALSO APPLY'),
                        content(
                            'The ways in which you use the App and Documentation may also be controlled by the AppStore if using an Apple device or Googleplay if using an android and their rules and policies will apply instead of these Terms where there are differences between the two.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'SUPPORT FOR THE APP AND HOW TO TELL US ABOUT PROBLEMS'),
                        content(
                            '1. Contact us (including with complaints). If you think the App or the Service are faulty or misdescribed or wish to contact us for any other reason please email our customer service team at uniplanet.info@gmail.com.'),
                        content(
                            '2. How we will communicate with you. If we have to contact you we will do so by email, by SMS or by pre-paid post, using the contact details you have provided to us.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'HOW YOU MAY USE THE APP, INCLUDING HOW MANY DEVICES YOU MAY USE IT ON'),
                        content(
                            'The license granted to you in Clause 2 is in consideration of your agreement to abide by these Terms. This license does not extend to a right to use any uniplanet trademark and logo. You are solely responsible for all the information you submit to the App and any consequence that could result from your submission.'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'As a condition of using this App and Service, you may not:'),
                        content('1. violate any of these Terms;'),
                        content(
                            '2. import or export any product listed on the Service to or from a location outside of the United states of America;'),
                        content(
                            '3. modify, copy, publish, license, sell or otherwise commercialize this App or any information or software associated with this App;'),
                        content(
                            '4. use this App in any manner that could impair any of our sites in a way or interfere with any party\'s use of enjoyment of any of our sites;'),
                        content(
                            '5. otherwise transfer the App or the Service to someone else, whether for money, for anything else or for free;'),
                        content(
                            '6. copy the App, Documentation or Service, except as part of the normal use of the App or where it is necessary for the purpose of back-up or operational security;'),
                        content(
                            '7. translate, merge, adapt, vary, alter or modify, the whole or any part of the App, Documentation or Service nor permit the App or the Service or any part of them to be combined with, or become incorporated in, any other programs, except as necessary to use the App and the Service on devices as permitted in these Terms.'),
                        content(
                            '8. You must comply with any applicable third-party terms when using this App (for example your wireless data service agreement or Appstore agreement).'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'ACCEPTABLE USE RESTRICTIONS'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'You must not:'),
                        content(
                            '1. use the App or any Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these Terms, or act fraudulently or maliciously, for example, by hacking into or inserting malicious code, such as viruses, or harmful data, into the App, any Service or any operating system;'),
                        content(
                            '2. use the App or any Service to buy or sell any goods or services listed in uniplanet market\'s Forbidden Items Policy which is available here;'),
                        content(
                            '3. infringe our intellectual property rights or those of any third party in relation to your use of the App or any Service (to the extent that such use is not licensed by these Terms);'),
                        content(
                            '4. transmit any material that is defamatory, offensive or otherwise objectionable in relation to your use of the App or any Service;'),
                        content(
                            '5. use the App or any Service in a way that could damage, disable, overburden, impair or compromise our systems or security or interfere with other users;'),
                        content(
                            '6. collect or harvest any information or data from any Service or our systems or attempt to decipher any transmissions to or from the servers running any Service.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'NOTIFICATION'),
                        content(
                            'For the convenience of users, we may display a variety of information related to the use of the Service, such as various notices and the promotion of our other services in our Service or send them to the user\'s email address.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'YOU MUST BE 16 TO ACCEPT THESE TERMS'),
                        content(
                            'You must be 16 or over to accept these Terms, download the App and use our Service.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'IF SOMEONE ELSE OWNS THE PHONE OR DEVICE YOU ARE USING'),
                        content(
                            'If you download or stream the App onto any phone or other device not owned by you, you must have the owner\'s permission to do so. You will be responsible for complying with these Terms, whether or not you own the phone or other device.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'WE MAY COLLECT TECHNICAL DATA ABOUT YOUR DEVICE'),
                        content(
                            'By using the App or any of the services we offer, you agree to us collecting and using technical information about the devices you use the App on and related software, hardware and peripherals to improve our products and to provide any Service to you.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'WE MAY COLLECT LOCATION DATA (BUT YOU CAN TURN LOCATION SERVICES OFF)'),
                        content(
                            'Our Service will need to make use of location data sent from your device. We will obtain location information from a location information service provider that collects location information on your device. We offer a service that allows users to become a member of a local community based on their current location and upload posts related to the local community with other users. Another service we provide is to provide lifestyle and advertising based on location. When accessing the App on your device, you will receive a notification which will give you the choice of whether to consent to our collection of location data. If you do not consent to us accessing this data, then your use of the App and the Service we are able to provide will be affected. By providing consent we and our affiliates\' and licensees\' may transmit, collect, retain, maintain, process and use your location data and queries to provide and improve location-based and road traffic-based products and services. For further information on how we collect and use location data, please refer to our Privacy Policy.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'WE ARE NOT RESPONSIBLE FOR OTHER WEBSITES YOU LINK TO'),
                        content(
                            '1. The App or any service we offer may contain links to other independent websites which are not provided by us. Such independent sites are not under our control, and we are not responsible for and have not checked and approved their content or their privacy policies (if any).'),
                        content(
                            '2. You will need to make your own independent judgment about whether to use any such independent sites, including whether to buy any products or services offered by them.'),
                        content(
                            '3. You agree not to hold us responsible for anything other users post or do.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'INTELLECTUAL PROPERTY RIGHTS'),
                        content(
                            '1. Any content you upload will be considered non-confidential and non-proprietary. You retain all of your ownership rights in your content, but you grant to us and other users of the App and Service a limited license to use, store, copy or modify that content and to distribute and make available to third parties. The license allows us to show posts in search results of search engines (such as Google, Bing), to use posts in any type of advertisement of the App and Service including on Facebook and social media and to use posts for service notices or operational content. We also have the right to disclose your identity to any third party who is claiming that any content posted or uploaded by you constitutes a violation of their intellectual property rights or of their right to privacy.'),
                        content(
                            '2. You may, at any time, request us to delete, exclude from search results or render the posts private via the Customer Centre or by contacting the webmaster. You may withdraw your consent at any time for us to use your posts for our own marketing purposes and this will have no affect on your continued use of the App and Service.'),
                        content(
                            '3. We have the right to remove any posts you make if, in our opinion, your post does not comply with these Terms. You are solely responsible for securing and backing up your content.'),
                        content(
                            '4. You warrant that, where necessary, you have obtained the requisite permissions and consents to:'),
                        content(
                            '5. use the intellectual property of another Service user or third-party; or'),
                        content(
                            '6. make reference to another Service user or third-party in any content posted by you or any person accessing the Service whilst logged into the App or Website.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'OUR RESPONSIBILITY FOR LOSS OR DAMAGE SUFFERED BY YOU'),
                        content(
                            '1. We are responsible to you for foreseeable loss and damage caused by us. If we fail to comply with these Terms, we are responsible for any loss or damage you suffer that is a foreseeable result of our breaching these Terms or our failing to use reasonable care and skill, but we are not responsible for any loss or damage that is not foreseeable. Loss or damage is foreseeable if either it is obvious that it will happen or if, at the time you accepted these Terms, both we and you knew it might happen.'),
                        content(
                            '2. We do not exclude or limit in any way our liability to you where it would be unlawful to do so. This includes liability for death or personal injury caused by our negligence or the negligence of our employees, agents or subcontractors or for fraud or fraudulent misrepresentation. '),
                        content(
                            '3. When we are liable for damage to your property. If defective digital content that we have supplied damages a device or digital content belonging to you, we will either repair the damage or pay you compensation. However, we will not be liable for damage that you could have avoided by following our advice to apply an update offered to you free of charge or for damage that was caused by you failing to correctly follow installation instructions or to have in place the minimum system requirements advised by us. '),
                        content(
                            '4. We are not liable for business losses. The App and Service is for domestic and private use. If you use the App or the Service for any commercial, business or resale purpose we will have no liability to you for any loss of profit, loss of business, business interruption, or loss of business opportunity. '),
                        content(
                            '5. Limitations to the App and the Service. The App and the Service are provided for general information and entertainment purposes only. They do not offer advice on which you should rely. You must obtain professional or specialist advice before taking, or refraining from, any action on the basis of information obtained from the App or the Service. Although we make reasonable efforts to update the information provided by the App and the Service, we make no representations, warranties or guarantees, whether expressed or implied, that such information is accurate, complete or up to date. '),
                        content(
                            '6. Check that the App and the Service are suitable for you. The App and the Service have not been developed to meet your individual requirements. Please check that the facilities and functions of the App and the Service (as described on the Appstore or Googleplay) meet your requirements.'),
                        content(
                            '7. We are not responsible for events outside our control. If our provision of the Service or support for the App or the Service is delayed by an event outside our control then we will contact you as soon as possible to let you know and we will take steps to minimize the effect of the delay. Provided we do this we will not be liable for delays caused by the event but if there is a risk of substantial delay you may contact us to end your contract with us and receive a refund for any services you have paid for but not received.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'RELEASE'),
                        content(
                            'If you have a dispute with one or more users of the Service, you release us (and our officers, directors, agents, subsidiaries, joint ventures and employees) from any and all claims, demands and damages (actual and consequential) of every kind and nature, known or unknown, arising out of or in any way connected with such disputes.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'CHANGES TO THESE TERMS'),
                        content(
                            '1. We may amend the Terms, the instructions on how to use the Service, and announcements in order to reflect any changes in the law or the Service, etc. In the event we amend these Terms, we shall display the amended items on the individual start-up screen of the App, and subject to the below, the amended Terms shall become effective seven (7) days after the notice has been given. Where the proposed amendments are substantial, the amended Terms shall become effective thirty (30) days after the giving of notice. '),
                        content(
                            '2. If you do not accept the notified changes you may not be permitted to continue to use the Service.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'UPDATE TO THE APP AND CHANGES TO THE SERVICE'),
                        content(
                            '1. In principle, the Service can be used throughout the year and twenty-four (24) hours a day. However, we may suspend the Service on the grounds of work-related or technical matters, and for a certain period of time set by us for the purpose of management.'),
                        content(
                            '2. The Service may be temporarily suspended for regular or temporary inspection for maintenance and repair of equipment, or other significant reasons. In such an event, we will give prior notice in the App delivery screen. If the Service is interrupted for reasons that cannot be predicted, we will notify you immediately upon being made aware of the situation.'),
                        content(
                            '3. From time to time we may automatically update the App and change the Service to improve performance, enhance functionality, reflect changes to the operating system or address security issues. Alternatively, we may ask you to update the App for these reasons.'),
                        content(
                            '4. If you choose not to install such updates you may not be able to continue using the App and the Service.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'WE MAY END YOUR RIGHTS TO USE THE APP AND THE SERVICE IF YOU BREAK THESE TERMS'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'We may end your rights to use the App and Service at any time by contacting you if you have breached these Terms in a serious way. We may restrict or suspend your use of the Service in the event of each of the following:'),
                        content(
                            '1. you deliberately or negligently interfere with the management of the Service;'),
                        content(
                            '2. you falsified or provided any misleading information when registering or when using the App;'),
                        content(
                            '3. if it is unavoidable due to the maintenance, repair, or construction of equipment for the Service;'),
                        content(
                            '4. there is a disruption in the use of the Service due to an emergency, malfunctions in the Service equipment, or the overload in the use of the Service;'),
                        content(
                            '5. we deem that continuing the provision of the Service is inappropriate on other serious grounds;'),
                        content(
                            '6. obstruction of the provision of the Service or access to the Service by using a method other than that instructed by us;'),
                        content(
                            '7. collection, use or disclosure of information of other users without permission;'),
                        content(
                            '8. use of the Service for profit or publicity purposes;'),
                        content(
                            '9. sending or posting information violating good public order or morals and any applicable law such as obscene materials or information infringing on copyright or other forms of intellectual property;'),
                        content(
                            '10. copying, modifying, distributing, selling, assigning, lending, providing as security the App or any associated service or part of the software included therein, or allowing another person to engage in such use without our consent;'),
                        content(
                            '11. reproducing, disassembling, imitating, or otherwise modify the App, such as attempting to reverse-engineer the software or extract the source code; or'),
                        content(
                            '12. failure to comply with any relevant laws and regulations or these Terms. Where we restrict or suspend the use of the Service due to the provisions of the paragraphs above, we shall inform you as to the reasons why the suspension/restriction has occurred and the period of suspension/restriction if possible.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'TERMINATION OF THIS AGREEMENT (DE-REGISTRATION)'),
                        content(
                            '1. If you no longer wish to use the Service, you may, at any given time, request the termination of this agreement through the menu option. We will process the request in an expeditious manner in accordance with the law. However, for the prevention of misuse of the Service such as fraud, a user who is engaged in an on-going transaction or a transaction-related dispute may be restricted from '),
                        content(
                            '2. On termination, all data such as the user\'s information or the posts uploaded by the user will be deleted excluding any information retained as required by law and in accordance with our Privacy Policy or as per below. Posts uploaded by a user that are scrapped or otherwise shared and displayed by a third party, engagements in chats, or added posts to a third party\'s post, will not be deleted but instead remain in our Service within the scope necessary to allow the other users\' use of the Service in its normal capacity.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'WE MAY TRANSFER THIS AGREEMENT TO SOMEONE ELSE'),
                        content(
                            'We may transfer our rights and obligations under these Terms to another organization. We will always tell you in writing if this happens and we will ensure that the transfer will not affect your rights.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'YOU NEED OUR CONSENT TO TRANSFER YOUR RIGHTS TO SOMEONE ELSE'),
                        content(
                            'You may only transfer your rights or your obligations under these Terms to another person if we agree in writing.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'IF A COURT FINDS PART OF THIS CONTRACT ILLEGAL, THE REST WILL CONTINUE IN FORCE'),
                        content(
                            'Each of the paragraphs of these Terms operates separately. If any court or relevant authority decides that any of them are unlawful, the remaining paragraphs will remain in full force and effect.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'EVEN IF WE DELAY IN ENFORCING THIS CONTRACT, WE CAN STILL ENFORCE IT LATER'),
                        content(
                            'Even if we delay in enforcing this contract, we can still enforce it later. If we do not insist immediately that you do anything you are required to do under these Terms, or if we delay in taking steps against you in respect of your breaking this contract, that will not mean that you do not have to do those things and it will not prevent us taking steps against you at a later date.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'WHICH LAWS APPLY TO THIS CONTRACT AND WHERE YOU MAY BRING LEGAL PROCEEDINGS'),
                        content(
                            'These terms and other policies posted on the Servier are governed by the laws of the United States of America applicable therein.'),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle:
                    const Text('View uniplanet Marketplace Privacy Policy'),
                children: <Widget>[
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText('Privacy Policy',
                            color: Theme.of(context).colorScheme.tertiary),
                        const SizedBox(
                          height: 20,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'Effective Date: June 2023'),
                        const SizedBox(
                          height: 10,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'INTRODUCTION'),
                        content(
                            'uniplanet LLC. and our affiliates ("Company" or "We") respect your privacy and are committed to protecting it by complying with this privacy policy (this "Policy").'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'This Policy sets out:'),
                        content(
                            '- The types of information we may collect or that app users ("you") may provide when you download, install, register with, access or use the uniplanet Marketplace mobile application software ("App") and any of the services accessible through the App available on "uniplanet.shop" or other sites of ours (the "Service Sites", and collectively with the App, "uniplanet Marketplace") regarding the collection, use, storage, transfer, and protection of your personal data.\n - Our practices for collecting, using, maintaining, protecting, and disclosing that information.\nWe will only use your personal information in accordance with this Policy unless otherwise required by applicable law. We take steps to ensure that the personal information that we collect about you is adequate, relevant, not excessive, and used for limited purposes.\nPrivacy laws in the United States of America generally define "personal information" as any information about an identifiable individual, which includes information that can be used to identify, locate, or contact an individual, alone or when combined with other personal or identifying information.'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'This Policy applies only to information we collect through or in connection with uniplanet Marketplace, in email, text, and other electronic communications sent through or in connection with uniplanet Marketplace. This Policy DOES NOT apply to information that:'),
                        content(
                            '- We collect offline.\n - You provide to or are collected by any third party.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'SCOPE AND CONSENT'),
                        content(
                            'Please read this policy carefully to understand our policies and practices for collecting, processing, and storing your information. If you do not agree with our policies and practices, do not download, register with, or use the App or visit the Service Sites.\n\nBy downloading, registering with, using or visiting the App and/or the Service Sites, you indicate that you understand, accept and consent to us for the collection, use, disclosure and retention of your personal information as described in this Policy.\n\nThis policy may change from time to time (see Changes to Our Privacy Policy). Your continued use of the App and visits to the Service Sites after we make changes indicates that you accept and consent to those changes, so please check the Policy periodically for updates. We will notify you in advance of any material changes to this Policy and obtain your consent to any new ways that we collect, use, and disclose your personal information.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'INFORMATION WE COLLECT ABOUT YOU AND HOW WE COLLECT IT'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'We collect information about you through:'),
                        content(
                            'Direct interactions with you when you provide it to us, for example, by filling in applications or corresponding with us.\nAutomated technologies or interactions, when you use the App or the Services Sites, for example, usage details, and IP addresses.'),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'Information You Provide to Us'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'When you download, register with, or use the App or access, use or visit the Service Sites, we may ask you to provide:'),
                        content(
                            '- Information by filling in forms in the uniplanet Marketplace app. This includes information you provide when registering to use the App and/or Service Sites, subscribing to our service, posting material, or requesting further services. We may also ask you for information when you report a problem with the App.\n- Records and copies of your correspondence, including emails if you contact us.\n- Your responses to surveys that we might ask you to complete for research or other purposes.\n- Details of transactions you carry out through the App and/or Service Sites.\n\n Your search queries on uniplanet Marketplace.\nYou may also provide information (including without limitation profile images, photos, or other digital content) for publication or display ("posted") on public areas of the App and/or the Service Sites (collectively, "User Contributions"). You post and transmit User Contributions to others at your own risk. We cannot control the actions of third parties with whom you may choose to share your User Contributions. Therefore, we do not guarantee that unauthorized persons will not view your User Contributions.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'Automatic Information Collection and Tracking Technologies'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'When you download, access, and use the App, it may automatically collect:'),
                        content(
                            '- Usage details: When you access and use the App or the Service Sites, we may automatically collect certain details of your access to and use of the App or the Service Sites, including traffic data, location data, logs, and other communication data and the resources that you access and use on or through the App.\n- Device information: We may collect information about your mobile device and internet connection, including the device\'s unique device identifier, IP address, operating system, and mobile network information.\n- Stored information and files: The App also may access metadata and other information associated with other files stored on your device. This may include, for example, photographs, audio and video clips, personal contacts, and address book information.\n- School information: The App collects information about the location of your school and authenticates your school enrollment status.'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'The information we collect automatically is statistical information and may include personal information. We may maintain it or associate it with personal information we collect in other ways, or that you provide to us. This usage information helps us to improve our App and to deliver a more personalized service, including by helping us to: '),
                        content(
                            '- Estimate our audience size and usage patterns.\n- Store information about your preferences and customize our App according to your individual interests.\n- Speed up your searches.\n- Recognize you when you use the App.\n\n If you do not want us to collect this information, do not download the App or delete it from your device. For more information, see How We Use Your Information. Note, however, that opting out of the App\'s collection of location information will cause its location-based features to be disabled.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'Third-Party Information Collection'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'When you use the App or its content, certain third parties collect information about you or your device. These third parties may include: '),
                        content(
                            '- Other users of the App.\n- Analytics companies.\n\n For more information about how you can opt out of receiving targeted advertising, see Choices About How We Use and Disclose Your Information.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'HOW WE USE YOUR INFORMATION'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'We use information that we collect about you or that you provide to us, including any personal information:'),
                        content(
                            '- To verify accounts and your activity.\n- To provide you with the App and its contents.\n- To provide you with information, products or services that you request from us.\n- To fulfill the purposes for which you provided it or that were described when it was collected or any other purpose for which you provide it.\n- To determine your Schools\' market for purposes of the App and the Services Sites.\n- To carry out our obligations and enforce our rights in any contracts with you, including for billing and collection or to comply with legal requirements.\n- To notify you when App updates are available, and of changes to any products or services we offer or provide through it.\n- To improve our App, products or services, or customer relationships and experiences.\n- To detect and remedy violations of our terms or policies.\n- To respond to user inquiries.\n- To combat harmful conduct, detect and prevent fraud, suspicious activity, spam and other bad experiences\nTo maintain the integrity of our App and Services Sites, and promote safety and security on and off of our App and Service Sites\nFor online and offline marketing purposes.\n- To allow you to participate in interactive features, social media, or other features on our App.\n- To measure or understand the effectiveness of the advertising we serve to you and others, and to deliver relevant advertising to you.\n- For any other purpose with your consent.'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'Usage information that we collect helps us to improve our App and to deliver a better and more personalized experience, including by enabling us to:'),
                        content(
                            '- Estimate our audience size and usage patterns.\n- Store information about your preferences, allowing us to customize our App according to your individual interests.\n- Speed up your searches.\n- Recognize you when you use the App.\n\nWe use location information we collect to: (i) determine your schools’ market for purposes of the App and the Services Sites; (ii) deliver content and advertisements to you in respect of such market; and (iii) to verify your identity and prevent fraud, suspicious activity, spam and other violations of our terms or policies.\n\n We may also use your information to contact you about our own and third parties\' goods and services that may be of interest to you, as permitted by law. If you do not want us to use your information in this way, please do not download the App or delete it from your device.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'DISCLOSURE OF YOUR INFORMATION'),
                        content(
                            'We may disclose aggregated information about our users, and information that does not identify any individual, without restriction.'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'We may disclose personal information that we collect or you provide as described in this privacy policy:'),
                        content(
                            '- To our subsidiaries and affiliates.\n- According to applicable law, to a buyer or other successor in the event of a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of uniplanet LLC.\'s assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which personal information held by uniplanet LLC. about our customers and users is among the assets transferred.\n- To contractors, service providers, and other third parties we use to support our business, such as analytics and search engine providers that help us optimize and improve our services. We contractually require these third parties to keep personal information confidential, use it only for the purposes for which we disclose it to them, and to process personal information following the same standards set out in this policy.\n- For any other purpose we disclose when you provide the information with your consent.\n- To comply with any court order, law, or legal process, including to respond to any government or regulatory request, according to applicable law.\n- To enforce our rights arising from any contracts between you and us, including the App terms and conditions.\n- If we believe disclosure is necessary or appropriate to protect the rights, property, or safety of Daangn Inc., its affiliates, our customers, or others. This includes exchanging information with other companies and organizations for fraud prevention and credit risk reduction.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'TRANSFERRING YOUR PERSONAL INFORMATION'),
                        content(
                            'We may transfer personal information that we collect or that you provide us to contractors, service providers, and other third parties we use to support the App (such as analytics providers that assist us with App improvement and optimization) and who are contractually obligated to keep personal information confidential, to use it only for the purposes for which we disclose it to them, and to process the personal information with the same standards set out in this policy.\n\n We may process, store, and transfer your personal information in and to other countries with different privacy laws that may or may not be as comprehensive as United States law. In these circumstances, the governments, courts, law enforcement, or regulatory agencies of that country may be able to obtain access to your personal information. Whenever we engage a service provider, we require that its privacy and security standards comply with this policy and applicable United States laws.\n\n By submitting your personal information or engaging with the App, you consent to this transfer, storage, or processing.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'CHOICES ABOUT HOW WE USE AND DISCLOSE YOUR INFORMATION'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'We strive to provide you with choices regarding the personal information you provide to us. We have created mechanisms to provide you with the following control over your information:'),
                        content(
                            '- Location Information. In order to deliver our services, the App will collect and use real-time information about your device\'s location. If you block the use of location information, the App may be inaccessible or not function properly.\n- Promotional Offers from the Company. If you have opted in to receive certain emails and/or push notifications from us but no longer wish for us to use your contact information to promote our own or third parties\' products or services, you can opt-out by sending us an email stating your request to  or by opting out of receiving promotional push notifications in the App. If we have sent you a promotional email, you may unsubscribe by clicking the unsubscribe link we have included in the email. This opt-out does not apply to information provided to the Company as part of a product purchase, warranty registration, product service experience, or other transactions. You can also always opt-out by logging into the App and adjusting your user preferences in your account profile by checking or unchecking the relevant boxes or by sending us an email stating your request to .'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'DATA SECURITY'),
                        content(
                            'The security of your personal information is very important to us. We use physical, electronic, and administrative measures designed to secure your personal information from accidental loss and from unauthorized access, use, alteration, and disclosure. We store all information you provide to us behind firewalls on secure servers. Any data, information and transactions will be encrypted using SSL technology and/or AES (256-bit Advanced Encryption Standard). Once we have received your information, we will use strict security features and procedures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way. We will collect and store personal data on your devices using application data caches and browser web storage (including HTML5 and other technology).\n\n The safety and security of your information also depends on you. Where we have given you (or you have chosen) a password for access to certain parts of our App, you are responsible for keeping it confidential. We ask you not to share your password with anyone. We urge you to be careful about giving out information in public areas of the App which any user can view. Certain services include chat room or forum features. Ensure when using these features that you do not submit any personal data that you do not want to be seen, collected or used by other users. We have put in place procedures to deal with any suspected personal data breach and will notify you and any applicable regulator when we are legally required to do so.\n\n Unfortunately, the transmission of information via the Internet and mobile platforms is not completely secure. Although we do our best to protect your personal information, we cannot guarantee the security of your personal information transmitted through the App. Any transmission of personal information is at your own risk. We are not responsible for circumvention of any App privacy settings or security measures.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'DATA RETENTION'),
                        content(
                            'Except as otherwise permitted or required by applicable law or regulation, we will only retain your personal information for as long as necessary to fulfill the purposes we collected it for, including for the purposes of satisfying any legal, accounting, or reporting requirements. Under some circumstances we may anonymize or aggregate your personal information so that it can no longer be associated with you. We reserve the right to use such anonymous and de-identified data for any legitimate business purpose without further notice to you or your consent.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'ACCESSING AND CORRECTING YOUR PERSONAL INFORMATION'),
                        content(
                            'It is important that the personal information we hold about you is accurate and current. Please keep us informed if your personal information changes. By law you have the right to request access to and to correct the personal information that we hold about you.\n\nYou can review and change your personal information by logging into the App and visiting your account profile page.\n\nIf you want to review, verify, correct, or withdraw consent to the use of your personal information you may also send us an email at uniplanet.info@gmail.com to request access to, correct, or delete any personal information that you have provided to us. We may not accommodate a request to change information if we believe the change would violate any law or legal requirement or cause the information to be incorrect.\n\nWe may request specific information from you to help us confirm your identity and your right to access, and to provide you with the personal information that we hold about you or make your requested changes. Applicable law may allow or require us to refuse to provide you with access to some or all of the personal information that we hold about you, or we may have destroyed, erased, or made your personal information anonymous in accordance with our record retention obligations and practices. If we cannot provide you with access to your personal information, we will inform you of the reasons why, subject to any legal or regulatory restrictions.'),
                        const SizedBox(
                          height: 10,
                        ),
                        secondarySubTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'We will provide access to your personal information, subject to exceptions set out in applicable privacy legislation. Examples of such exceptions include:'),
                        content(
                            '- Information protected by solicitor-client privilege.\n- Information that is part of a formal dispute resolution process.\n- Information that is about another individual that would reveal their personal information or confidential commercial information.\n- Information that is prohibitively expensive to provide.\n\nIf you are concerned about our response or would like to correct the information provided, you may contact our Privacy Officer at.'),
                        content(
                            '\n\nIf you delete your User Contributions from the App, copies of your User Contributions may remain viewable in cached and archived pages or might have been copied or stored by other App users. Proper access and use of information provided on the App, including User Contributions, is governed by our terms of use at.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'CHILDREN UNDER THE AGE OF 16'),
                        content(
                            'Our App is not intended for children under 16 years of age. No one under age 16 may provide any personal information to or on the App. We do not knowingly collect personal information from children under 16. If you are under 16, do not use or provide any information on this App or on or through any of its features/register on the App, make any purchases through the App, use any of the interactive or public comment features of this App, or provide any information about yourself to us, including your name, address, or any email address you may use. If we learn we have collected or received personal information from a child under 16 without verification of parental consent, we will delete that information. If you believe we might have any information from or about a child under 16, please contact us at.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'WITHDRAWING YOUR CONSENT'),
                        content(
                            'Where you have provided your consent to the collection, use, and transfer of your personal information, you may have the legal right to withdraw your consent under certain circumstances. To withdraw your consent, if applicable, contact us at . Please note that if you withdraw your consent we may not be able to provide you with a particular product or service. We will explain the impact to you at the time to help you make your decision.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'CHANGES TO OUR PRIVACY POLICY'),
                        content(
                            'We may update our privacy policy from time to time. It is our policy to post any changes we make to our privacy policy on this page. If we make material changes to how we treat our users\' personal information, we will post the new privacy policy on this page with a notice that the privacy policy has been updated and notify you with an in-App alert the first time you use the App after we make the change.'),
                        content(
                            '\n\nWe include the date the privacy policy was last revised at the top of the page. You are responsible for ensuring we have an up-to-date, active, and deliverable email address for you, and for periodically visiting this privacy policy to check for any changes.'),
                        const SizedBox(
                          height: 20,
                        ),
                        subTitleText(
                            color: Theme.of(context).colorScheme.tertiary,
                            'CONTACT INFORMATION AND CHALLENGING COMPLIANCE'),
                        content(
                            '\nWe welcome your questions, comments, and requests regarding this privacy policy and our privacy practices. Please contact us at:'),
                        content(
                            '\nPrivacy officer : Sije Park\nuniplanet LLC.\n324 62nd st, West New York, NJ, 07093'),
                        content(
                            '\nWe have procedures in place to receive and respond to complaints or inquiries about our handling of personal information and our compliance with this policy and with applicable privacy laws. To discuss our compliance with this policy please contact our Privacy Officer using the contact information listed above.'),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
