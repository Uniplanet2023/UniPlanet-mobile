import 'package:flutter/material.dart';
import 'package:uniplanet/core/router/names.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.list,
  });
  final List<Map<String, dynamic>> list;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.category,
                    arguments: list[index]['name']),
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            15.0), // Adjust the radius as needed
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface, // Set the background color
                            borderRadius: BorderRadius.circular(
                                15.0), // Adjust the radius as needed
                          ),
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            list[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          list[index]['name'],
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
