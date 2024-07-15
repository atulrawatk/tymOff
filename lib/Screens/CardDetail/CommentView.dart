import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/Network/Response/CommentPullResponse.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/DateTimeUtils.dart';


class CommentView extends StatelessWidget {

  final CommentPullDataList _commentData;
  CommentView(this._commentData);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[

          //getProfilePic(),

          Expanded(
            flex: 0,
            child:  _commentData?.user?.picUrl != null &&  _commentData.user.picUrl.length > 0 ? Center(
              child: Container(
                width: 30.0,
                height: 30.0,
                child: CachedNetworkImage(
                  imageUrl:  _commentData?.user?.picUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorUtils.lightGreyColor.withOpacity(0.3),width: 0.5),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover),
                    ),
                  ),
                  placeholderFadeInDuration: Duration(seconds: 1),
                  placeholder: (context, url) => SizedBox(
                      height: 6.0,
                      width: 6.0,
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorUtils.primaryColor),
                          strokeWidth: 2.0)
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ) : Center(
                  child: Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorUtils.lightGreyColor.withOpacity(0.1), width: 0.5),
                              color: ColorUtils.userPicBgColor,
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Image.asset(
                              "assets/dummy_user_profile.png",
                            ),
                  ),
      ),
          ),
          SizedBox(width: 10.0,),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomWidget.getText(_commentData?.user?.name??"",
                    style: Theme.of(context).textTheme.title.copyWith(fontSize: 14.0) ),
                SizedBox(height: 5.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CustomWidget.getText(_commentData?.comments??"", textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 13.0)),
                ),
                SizedBox(height: 5.0,),
                CustomWidget.getText(getCommentCreatedTime(), style: Theme.of(context).textTheme.body1),

              ],
            ),
          ),
        ],
      ),

    );
  }

  String getCommentCreatedTime(){
    var commentTime = "";
    if(_commentData.commentTime != null){
      commentTime = DateTimeUtils().formatTime(_commentData?.commentTime);
    }else{
      commentTime = _commentData?.commentText;
    }
    return commentTime;
  }


  Widget getProfilePic(){
    _commentData?.user?.picUrl != null &&  _commentData.user.picUrl.length > 0 ? Center(
      child: Container(
        width: 30.0,
        height: 30.0,
        child: CachedNetworkImage(
          imageUrl:  _commentData?.user?.picUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover),
            ),
          ),
          placeholderFadeInDuration: Duration(seconds: 1),
          placeholder: (context, url) => SizedBox(
              height: 6.0,
              width: 6.0,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorUtils.primaryColor),
                  strokeWidth: 2.0)
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    )
        : new Center(
      child: new Container(
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          color: ColorUtils.userPicBgColor,
          borderRadius: BorderRadius.circular(60.0),
        ),
        child: Image.asset(
          "assets/dummy_user_profile.png",
        ),
      ),
    );
  }
}
