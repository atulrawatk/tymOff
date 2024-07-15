import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:shimmer/shimmer.dart';

class ContentListingShimmerLoading extends StatefulWidget {
  @override
  ContentListingShimmerLoadingState createState() =>
      ContentListingShimmerLoadingState();
}

class ContentListingShimmerLoadingState
    extends State<ContentListingShimmerLoading> {
  // full screen width and height
  double _width = 0.0;
  double _cardWidth = 150.0;
  int _cardHorizontalCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _width = MediaQuery.of(context).size.width;
      _cardHorizontalCount = _width ~/ _cardWidth;
    });
  }


  @override
  Widget build(BuildContext context) {
    return staggeredGridViewContent();
  }

  Widget staggeredGridViewContent() {
    return StaggeredGridView.countBuilder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: 20,
      primary: false,
      crossAxisCount: _cardHorizontalCount * 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemBuilder: (context, index) {

        return getShimmerContent(index);
      },
      staggeredTileBuilder: (index) => new StaggeredTile.fit(_cardHorizontalCount),
    );
  }

  Widget getShimmerContent(int gridIndex) {
    Color color = ColorUtils().randomShimmerLoadingColorGeneratorByIndex(gridIndex);

    Widget widgetShimmerContent = Container();

    double height = getHeightAsPerColumnRow(gridIndex);
 
    widgetShimmerContent = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: new BorderRadius.only(
          topLeft:  const  Radius.circular(4.0),
          topRight: const  Radius.circular(4.0),
          bottomLeft: const  Radius.circular(4.0),
          bottomRight: const  Radius.circular(4.0),
        ),
      ),
      margin: EdgeInsets.all(2.0),
      width: _cardWidth,
      height: height,
      //color: Colors.grey,
    );
    return widgetShimmerContent;
  }

  var heightsColumns = [100.0, 150.0, 180.0, 150.0, 170.0, 220.0, 120.0];
  var heightsEvenColumn = [100.0, 150.0, 180.0, 150.0, 170.0, 220.0, 120.0];
  var heightsOddColumn = [150.0, 120.0, 150.0, 200.0, 140.0, 180.0, 160.0];

  double getHeightAsPerColumnRow(int gridIndex) {
    int indexOfHeight = gridIndex % (heightsColumns?.length ?? 0);
    return heightsColumns[indexOfHeight];
  }
}
