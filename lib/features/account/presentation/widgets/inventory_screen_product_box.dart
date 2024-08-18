import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sold_product/sold_product_bloc.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/home/widgets/build_product_box.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/models/product.dart';

class InventoryProductBox extends StatefulWidget {
  final List<Product> productList;
  final ScrollController controller;
  final bool isLoadingMore;
  final String title;
  const InventoryProductBox(
      {super.key,
      required this.title,
      required this.productList,
      required this.controller,
      required this.isLoadingMore});

  @override
  State<InventoryProductBox> createState() => _InventoryProductBoxState();
}

class _InventoryProductBoxState extends State<InventoryProductBox>
    with SingleTickerProviderStateMixin {
  SlidableController? slidableController;
  // Coachmark
  TutorialCoachMark? tutorialCoachMark;
  GlobalKey<CoachmarkDescState> coachmarkKey = GlobalKey<CoachmarkDescState>();
  List<TargetFocus> targets = [];
  int tutorialStep = 0;
  bool hasSeenMyListingTutorial = true;

  GlobalKey inventoryKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    slidableController = SlidableController(this);
    _checkFirstTimeUser();
  }

  @override
  void dispose() {
    slidableController?.dispose();
    super.dispose();
  }

  Future<void> _checkFirstTimeUser() async {
    if (widget.title != 'On Sale' && widget.title != 'Sold' ||
        widget.productList.isEmpty) {
      return;
    }

    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    if (widget.title == 'On Sale') {
      hasSeenMyListingTutorial =
          prefsHelper.getBool('hasSeenOnSaleTutorial') ?? false;
    }

    if (!hasSeenMyListingTutorial) {
      setState(() {
        hasSeenMyListingTutorial = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _showTutorial();
          Future.delayed(const Duration(seconds: 1), () {
            _openStartSlidable();
          });
        });
      });
      if (widget.title == 'On Sale') {
        prefsHelper.saveBool('hasSeenOnSaleTutorial', true);
      }
    }
  }

  _showTutorial() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onSkip: () {
          setState(() {
            hasSeenMyListingTutorial = true;
          });
          return true;
        },
        onFinish: () {
          setState(() {
            hasSeenMyListingTutorial = true;
          });
        },
        onClickTarget: (target) {
          log(target);
        })
      ..show(context: context);
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: "inventory-key",
        keyTarget: inventoryKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                      'Swipe right on this item to mark it as ${widget.title == 'On Sale' ? 'Sold' : 'On Sale'}',
                  skip: 'Skip',
                  next: 'Next',
                  onNext: () {
                    _handleNext();
                  },
                  onSkip: () {
                    _closeSlidable();
                    tutorialCoachMark?.finish();
                  },
                );
              })
        ],
        shape: ShapeLightFocus.RRect,
      ),
    ];
  }

  _handleNext() {
    tutorialStep++;
    if (tutorialStep == 1) {
      _openEndSlidable();
    } else {
      _closeSlidable();
      tutorialCoachMark?.finish();
    }
  }

  void _openStartSlidable() {
    if (widget.productList.isNotEmpty) {
      slidableController?.openStartActionPane(
          duration: const Duration(seconds: 1));
    }
  }

  void _openEndSlidable() {
    if (widget.productList.isNotEmpty) {
      slidableController?.openEndActionPane(
          duration: const Duration(seconds: 1));
    }
  }

  void _closeSlidable() {
    slidableController?.close();
  }

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index < widget.productList.length) {
              final product = widget.productList[index];
              return SlidableProduct(
                  hasSeenMyListingTutorial: hasSeenMyListingTutorial,
                  slidableController: slidableController,
                  widget: widget,
                  inventoryKey: inventoryKey,
                  product: product,
                  index: index);
            } else {
              return widget.isLoadingMore
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
          },
          // 40 list items
          childCount:
              widget.productList.length + (widget.isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }
}

class SlidableProduct extends StatelessWidget {
  const SlidableProduct({
    super.key,
    required this.hasSeenMyListingTutorial,
    required this.slidableController,
    required this.widget,
    required this.inventoryKey,
    required this.product,
    required this.index,
  });

  final bool hasSeenMyListingTutorial;
  final SlidableController? slidableController;
  final InventoryProductBox widget;
  final GlobalKey<State<StatefulWidget>> inventoryKey;
  final Product product;
  final int index;

  void _markAsSold(int index, BuildContext context) {
    // Delete from on sale and add to sold
    getIt<OnSaleProductBloc>().add(
      DeleteOnSaleProductEvent(
        product: widget.productList[index],
      ),
    );
    getIt<SoldProductBloc>().add(
      AddSoldProductEvent(
        product: widget.productList[index],
      ),
    );
    widget.productList[index].status = 'Sold';

    context
        .read<ProductBloc>()
        .add(UpdateProductEvent(product: widget.productList[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller:
          index == 0 && !hasSeenMyListingTutorial ? slidableController : null,
      enabled: widget.productList[index].seller.id == AuthRepository.userId,
      key: index == 0 && !hasSeenMyListingTutorial
          ? inventoryKey
          : ValueKey("${product.id}_${product.status}_$index"),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            _markAsSold(index, context);
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) => {_markAsSold(index, context)},
            icon: Icons.done,
            label: 'Mark as Sold',
            backgroundColor: Colors.green,
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => {
              Navigator.pushNamed(
                context,
                AppRoutes.editProductPage,
                arguments: widget.productList[index],
              )
            },
            icon: Icons.edit,
            label: 'Edit',
            backgroundColor: GlobalVariables.secondaryColor,
          ),
          SlidableAction(
            onPressed: (_) async => {
              getIt<ProductBloc>().add(
                  DeleteProductEvent(productId: widget.productList[index].id)),
              getIt<OnSaleProductBloc>().add(
                DeleteOnSaleProductEvent(
                  product: widget.productList[index],
                ),
              ),
              widget.productList.removeAt(index),
            },
            icon: Icons.delete,
            label: 'Remove',
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.productDetailsPage,
              arguments: product,
            );
          },
          child: Item(product: product)),
    );
  }
}

class CoachmarkDesc extends StatefulWidget {
  final String text;
  final String skip;
  final String next;
  final Function? onSkip;
  final Function? onNext;

  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = 'Skip',
    this.next = 'Next',
    this.onSkip,
    this.onNext,
  });

  @override
  State<CoachmarkDesc> createState() => CoachmarkDescState();
}

class CoachmarkDescState extends State<CoachmarkDesc> {
  late String text;
  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  void updateText(String text) {
    setState(() {
      this.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(text, style: const TextStyle(fontSize: 20, color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (widget.onSkip != null) {
                    widget.onSkip!();
                  }
                },
                child: Text(widget.skip),
              ),
              TextButton(
                onPressed: () {
                  updateText('Swipe left on this item to edit or remove it');
                  if (widget.onNext != null) {
                    widget.onNext!();
                  } else {
                    widget.onSkip!();
                  }
                },
                child: Text(widget.next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
