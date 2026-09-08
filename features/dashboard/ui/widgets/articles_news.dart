import 'package:afaq_real_estate/features/dashboard/logic/home_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/di/di.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../data/response/response.dart';
import '../../logic/home_cubit.dart';

import '../../../../core/widgets/app_loading_indicator.dart';
class NewsArticleList extends StatelessWidget {
  const NewsArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(di())..emitGetNews(),
      child: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          return state.maybeWhen(
            initial: () => const SizedBox(),

            newsLoading: () =>
            const Center(child: AppLoadingIndicator()),

            newsSuccess: (data) {
              final news = data.data ?? [];

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return buildArticleItem(
                    context,
                    index: index,
                    items: news[index],
                  );
                },
              );
            },

            newsError: (error) {
              return Text(error.message ?? 'Error');
            },

            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    // Text(
    //   AppStrings.newsAndArticles.tr(),
    //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
    // ),
    //         ],
    //       ),
    //       verticalSpace(10),
    //       buildArticleItem(
    //         context,
    //         title:
    //             '3 أعضاء في المجلس البلدي يقترحون: ترخيص سراديب للمؤسسات الحكومية بمناطق السكن الخاص',

    //         articleUrl:
    //             'https://www.alqabas.com/article/5957092-3-%D8%A3%D8%B9%D8%B6%D8%A7%D8%A1-%D9%81%D9%8A-%D8%A7%D9%84%D9%85%D8%AC%D9%84%D8%B3-%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A-%D9%8A%D9%82%D8%AA%D8%B1%D8%AD%D9%88%D9%86-%D8%AA%D8%B1%D8%AE%D9%8A%D8%B5-%D8%B3%D8%B1%D8%A7%D8%AF%D9%8A%D8%A8-%D9%84%D9%84%D9%85%D8%A4%D8%B3%D8%B3%D8%A7%D8%AA-%D8%A7%D9%84%D8%AD%D9%83%D9%88%D9%85%D9%8A%D8%A9-%D8%A8%D9%85%D9%86%D8%A7%D8%B7%D9%82-%D8%A7%D9%84%D8%B3%D9%83%D9%86-%D8%A7%D9%84%D8%AE%D8%A7%D8%B5/', // رابط المقال
    //       ),
    //       buildArticleItem(
    //         context,
    //         title: 'طلال البحر: «عقارات الكويت» تتطلع إلى المستقبل بتفاؤل',
    //         articleUrl:
    //             'https://www.alqabas.com/article/5946952-%D8%B7%D9%84%D8%A7%D9%84-%D8%A7%D9%84%D8%A8%D8%AD%D8%B1-%D8%B9%D9%82%D8%A7%D8%B1%D8%A7%D8%AA-%D8%A7%D9%84%D9%83%D9%88%D9%8A%D8%AA-%D8%AA%D8%AA%D8%B7%D9%84%D8%B9-%D8%A5%D9%84%D9%89-%D8%A7%D9%84%D9%85%D8%B3%D8%AA%D9%82%D8%A8%D9%84-%D8%A8%D8%AA%D9%81%D8%A7%D8%A4%D9%84/',
    //       ),
    //       buildArticleItem(
    //         context,
    //         title:
    //             'د. شهد الشمالي.. أول عربية وكويتية تشارك في وضع دليل علاجي عالمي',

    //         articleUrl:
    //             'https://www.alqabas.com/article/5956612-%D8%AF-%D8%B4%D9%87%D8%AF-%D8%A7%D9%84%D8%B4%D9%85%D8%A7%D9%84%D9%8A-%D8%A3%D9%88%D9%84-%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9-%D9%88%D9%83%D9%88%D9%8A%D8%AA%D9%8A%D8%A9-%D8%AA%D8%B4%D8%A7%D8%B1%D9%83-%D9%81%D9%8A-%D9%88%D8%B6%D8%B9-%D8%AF%D9%84%D9%8A%D9%84-%D8%B9%D9%84%D8%A7%D8%AC%D9%8A-%D8%B9%D8%A7%D9%84%D9%85%D9%8A/', // رابط المقال
    //       ),
    //       verticalSpace(20),
    //     ],
    //   ),
    // );
  }
}

class ArticleWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const ArticleWebViewScreen(
      {super.key, required this.url, required this.title});

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => isLoading = true),
          onPageFinished: (url) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (isLoading) const Center(child: AppLoadingIndicator()),
      ],
    );
  }
}

Widget buildArticleItem(BuildContext context,
    {required NewsResponseData items, required int index}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleWebViewScreen(
            url: items.url ?? "",
            title: items.title ?? "",
          ),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 10.w),
          // المحتوى
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  items.title ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: ColorManager.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(15),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
