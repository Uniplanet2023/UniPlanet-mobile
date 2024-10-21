import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/features/upload/presentation/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/housing/housing_bloc.dart';
import 'package:uniplanet/features/upload/presentation/widgets/adding_form/ad_form.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final addProductFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductUploadedState) {
              Navigator.pop(context, AppRoutes.bottomBarPage);
            }
          },
        ),
        BlocListener<HousingBloc, HousingState>(
          listener: (context, state) {
            if (state is HousingImagesUploaded) {
              Navigator.pop(context, AppRoutes.bottomBarPage);
            } else if (state is HousingPostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post uploaded successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: const Text(
              'New listing',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: addProductFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    AdFormWidget(addProductFormKey: addProductFormKey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
