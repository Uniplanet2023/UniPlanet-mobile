// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';

// class StateAddress extends StatefulWidget {
//   final Map<String, List<String>> stateCityMap;
//   final String? selectedState;
//   const StateAddress({super.key, required this.stateCityMap, this.selectedState});

//   @override
//   StateAddressState createState() => StateAddressState();
// }

// class StateAddressState extends State<StateAddress> {
//   final TextEditingController _typeAheadController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('TypeAhead Demo'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               // Settings action
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TypeAheadField<String>(
//               suggestionsCallback: (pattern) async {
//                 return widget.stateCityMap.keys
//                     .where(
//                       (state) =>
//                           state.toLowerCase().contains(pattern.toLowerCase()),
//                     )
//                     .toList();
//               },
//               builder: (context, controller, focusNode) {
//                 return TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   decoration: const InputDecoration(
//                     labelText: 'Select State',
//                     border: OutlineInputBorder(),
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   ),
//                 );
//               },
//               itemBuilder: (context, suggestion) {
//                 return ListTile(
//                   title: Text(suggestion),
//                 );
//               },
//               onSelected: (suggestion) {
//                 setState(() {
//                   widget.selectedState = suggestion;
//                   selectedCity = null;
//                   stateController.text = suggestion;
//                   cityController.clear();
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Shopping Cart',
//               style: TextStyle(fontSize: 24),
//             ),
//             const Spacer(),
//             const Center(
//               child: Text(
//                 'Your cart is empty',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//             const Spacer(),
//             const Text(
//               'Total: \$0.0',
//               style: TextStyle(fontSize: 18),
//               textAlign: TextAlign.right,
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Checkout action
//                 },
//                 child: const Text('Checkout'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
