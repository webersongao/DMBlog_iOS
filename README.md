# WBSBlog

著名开源内容管理系统Wordpress的移动iOS版（非官方），目前仅支持Wordpress，后续将开放支Zblog

WBSBlog is an open source *Wordpress* client for iOS, released under the MIT License .

## 目录简介
* WBSJsonApi ——— 包含API和API返回数据的封装模型
* Utils、Lib ——— 常用的工具方法、类扩展及第三方库
* home、tag、Left_bar...... ——— 各个具体界面
* Main ViewControllers ——— 主要的视图控制器（作为基类或使用较广的控制器）


演示
---
1、博客首页

![](OtherResource/home.jpeg)

2、功能边栏

![](OtherResource/leftbar.jpeg)

3、搜索

![](OtherResource/search.jpeg)

4、设置

![](OtherResource/setting.jpeg)

## 运行项目
1. 下载zip文件
2. 打开project即可
3. Libs 文件中包含 JSONAPI库 和 XMLRPC库 可以另作他用。


## 项目用到的开源类库、组件

序号 | 类库名称 | 说明
------------- | ------------- | -------------
1             | AFNetworking  | 网络请求
2             | MMDrawerController   | MMDrawerController https://github.com/mutualmobile/MMDrawerController
3             | WBSJsonApi   | Wordpress JSON API https://github.com/webersongao/WBSJsonApi
4             | RESideMenu       | 侧拉栏
5             | MBProgressHUD    | 显示提示或加载进度
6             | SDWebImage       | 加载网络图片和缓存图片
7             | TTTAttributedLabel | 支持富文本显示的label
8             | GPUImage         | 实现模糊效果
9             | Mansory | 自动布局框架
10            | FontAwesome      | 图标字体（ http://fortawesome.github.io/Font-Awesome/icons/ ）
11            | MZDayPicker      | 日期
12            | ToMarkdown       | 解析文章为markdown
13            | GHMarkdownParser  |解析文章为HTML

## 开源协议

WBSBlog app is under the MIT License . See [the LICENSE file](https://github.com/webersongao/WBSBlog/blob/master/LICENSE) for more details.


更新记录
======
v0.1.2 2017-02-10

>1、JSON API 登录。

>2、修改项目框架为根Tabbar。

v0.1.1 2016-07-19

>1、完善项目介绍。

>2、修改pch文件。

v0.1 2016-07-19

>1、创建项目。

>2、完善基本界面。

版本信息
-------
>版本: V0.1.2

>作者: Weberson Gao

>作者博客：http://www.swiftartisan.com

>作者邮箱: weberson@163.com

参考资料
=======

1、[JSON API](https://wordpress.org/plugins/json-api/other_notes/)

2、[iUnlocker](https://github.com/iMuFeng/iUnlocker)

3、[JSON API User](https://wordpress.org/plugins/json-api-user)

4、[WordPress-API-iOS](https://github.com/wordpress-mobile/WordPress-API-iOS)

5、[JSON API Notes](https://github.com/webersongao/WBSBlog/blob/master/OtherResource/wordpress-json-api-http-sample-data.md)

6、[WP_REST_API_Documentation](http://v2.wp-api.org)


