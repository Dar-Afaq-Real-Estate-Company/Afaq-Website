import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/di.dart';
import '../../core/helper/spacing.dart';
import '../../core/widgets/search_widget.dart';
import '../dashboard/logic/home_cubit.dart';
import '../dashboard/ui/widgets/sections/section_services.dart';

class SectionsView extends StatefulWidget {
  const SectionsView({super.key});

  @override
  State<SectionsView> createState() => _SectionsViewState();
}

class _SectionsViewState extends State<SectionsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(10),
        SearchWidget(
          context,
          onTap: () {
            context.read<NavigationCubit>().changeIndex(1);
          },
        ),
        verticalSpace(20),
        Expanded(
          child: BlocProvider(
            create: (context) => di<FilterSctionCubit>(),
            child: GridView.builder(
              itemCount: sectionServicesList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                // final item = sectionServicesList[index];
                final sectionItem = sectionServicesList[index];

                final animation = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      (index / sectionServicesList.length),
                      1,
                      curve: Curves.easeOut,
                    ),
                  ),
                );

                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: buildSectionItem(
                      context,
                      sectionServicesList[index],
                      sectionItem.subCategories,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
