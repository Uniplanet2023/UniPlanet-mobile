import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';
import 'package:uniplanet/features/housing/presentation/widgets/housing_card.dart';

class HousingListPage extends StatefulWidget {
  const HousingListPage({super.key});

  @override
  State<HousingListPage> createState() => _HousingListPageState();
}

class _HousingListPageState extends State<HousingListPage> {
  @override
  void initState() {
    super.initState();
    getIt<GetHousingBloc>().add(FetchHousingPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Housing List'),
      ),
      body: BlocBuilder<GetHousingBloc, GetHousingState>(
        builder: (context, state) {
          if (state is HousingPostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HousingPostsError) {
            return Center(child: Text(state.message));
          }
          if (state is HousingPostsLoaded) {
            return ListView.builder(
              itemCount: state.housingPosts.length,
              itemBuilder: (context, index) {
                return HousingPostCard(housing: state.housingPosts[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
