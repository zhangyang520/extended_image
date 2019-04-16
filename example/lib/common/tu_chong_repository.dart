import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:example/common/tu_chong_source.dart';
import 'dart:async';
import 'dart:convert';

/**
 * @Description:    数据仓库
 * @Author:         sun
 * @CreateDate:     2019/4/16 19:22
 * @UpdateUser:     sun
 * @UpdateDate:    2019/4/16 19:22
 * @UpdateRemark:   修改内容
 * @Version:        1.0
 * @email           13520335872@163.com
 */
class TuChongRepository extends LoadingMoreBase<TuChongItem> {

  //页面的角标
  int pageindex = 1;

  @override
  // TODO: implement hasMore
  //有加载更多的数据
  bool _hasMore = true;
  //强制刷新
  bool forceRefresh = false;

  //返回值: 是否有更多
  bool get hasMore => (_hasMore && length < 100) || forceRefresh;


  /**
   * 刷新功能
   */
  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {

    _hasMore = true;
    pageindex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    //强制刷新中 .....
    forceRefresh = !clearBeforeRequest;
    //请求刷新 结果
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  /**
   * 加载数据
   */
  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    // TODO: implement getData
    String url = "";
    //如果数组长度 ==0
    if (this.length == 0) {
      //初始化的url
      url = "https://api.tuchong.com/feed-app";
    } else {
      //请求参数的id
      int lastPostId = this[this.length - 1].post_id;

      /**
       * url的拼接
       */
      url =
          "https://api.tuchong.com/feed-app?post_id=$lastPostId&page=$pageindex&type=loadmore";
    }
    
    //是否成功
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      //延迟 操作的时间
      //await Future.delayed(Duration(milliseconds: 500, seconds: 1));
      //get 方法请求结果
      var result = await HttpClientHelper.get(url);
      //json 最后解析成实体
      var source = TuChongSource.fromJson(json.decode(result.body));
      
      //首页 清空集合
      if (pageindex == 1) {
        //执行 清空操作
        this.clear();
      }

      /**
       * 集合 遍历
       */
      source.feedList.forEach((item) {
        //判断 是否有图片
        if (item.hasImage && !this.contains(item) && hasMore) {
          //加入到集合中
          this.add(item);
        }
      });
      
      //是否有更多
      _hasMore = source.feedList.length != 0;
      //角标自增
      pageindex++;
//      this.clear();
//      _hasMore=false;
      isSuccess = true;
    } catch (exception) {
      isSuccess = false;
      print(exception);
    }
    return isSuccess;
  }
}
