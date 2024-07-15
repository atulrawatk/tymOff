import 'package:flutter/material.dart';

import 'ContentListing.dart';
import 'ContentListing.dart';

class ContentListingSearchConstant extends StatelessWidget {

  final _contentListing = ContentListing(
    isContentTypeFilterVisible: true,
    isGenreFilterVisible: true,
    isGenresSelected: true,
  );

  static final riContentListingKey1 = const Key('__RIKEY1_ContentListingSearchConstant__');

  @override
  Widget build(BuildContext context) {

    print("Munish -> Nice 1 ");

    return Container(
      // color: Theme.of(context).backgroundColor,
      child: NotificationListener<ScrollNotification>(
        key: riContentListingKey1,
        onNotification: (ScrollNotification scrollInfo) {
          print("Munish -> Nice -> ${scrollInfo.metrics.pixels}");
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          }
        },
        child: _contentListing,
      ),
    );
  }
}

/*

class ContentListingSearchConstant extends StatefulWidget {
  @override
  ContentListingSearchConstantState createState() => ContentListingSearchConstantState();
}

class ContentListingSearchConstantState extends State<ContentListingSearchConstant>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive {
    return true;
  }

  final _contentListing = ContentListing(
    isContentTypeFilterVisible: true,
    isGenreFilterVisible: true,
    isGenresSelected: true,
  );

  Widget build(BuildContext context) {
    super.build(context);
    return _contentListing;
  }
}
*/
