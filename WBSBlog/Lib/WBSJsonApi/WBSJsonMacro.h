//
//  WBSJsonMacro.h
//  WBSBlog
//
//  Created by Weberson on 2017/2/10.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#ifndef WBSJsonMacro_h
#define WBSJsonMacro_h


/// header
#define KHttp           @"http://"

#define KHttps          @"https://"

#define KBase_Api       @"api"


/// 方法 User

#define KUser_Versioninfo    @"user/info"  // JSON API User 中的info

#define KUser_Construct    @"user/__construct"

#define KUser_Register    @"user/register"

#define KUser_Avatar    @"user/get_avatar"

#define KUser_Get_Userinfo   @"user/get_userinfo"

#define KUser_Retrieve_Password    @"user/retrieve_password"

#define KUser_Validate_AuthCookie    @"user/validate_auth_cookie"

#define KUser_Generate_auth_cookie    @"user/generate_auth_cookie"

#define KUser_Get_CurrentUserinfo    @"user/get_currentuserinfo"

#define KUser_Get_user_meta    @"user/get_user_meta"

#define KUser_Update_user_meta    @"user/update_user_meta"

#define KUser_Delete_user_meta    @"user/delete_user_meta"

#define KUser_Update_user_meta_vars    @"user/update_user_meta_vars"

#define KUser_Xprofile    @"user/xprofile"

#define KUser_Xprofile_update    @"user/xprofile_update"

#define KUser_fb_connect    @"user/fb_connect"

#define KUser_Post_comment    @"user/post_comment"



/// 方法 core

#define KJsonApi_Versioninfo    @"info"

#define KBase_Get_recent_posts    @"get_recent_posts"

#define KBase_Get_posts    @"get_posts"

#define KBase_Get_post    @"get_post"

#define KBase_Get_page    @"get_page"

#define KBase_Get_date_posts    @"get_date_posts"

#define KBase_Get_category_posts    @"get_category_posts"

#define KBase_Get_tag_posts    @"get_tag_posts"

#define KBase_Get_author_posts    @"get_author_posts"

#define KBase_Get_search_results    @"get_search_results"

#define KBase_Get_date_index    @"get_date_index"

#define KBase_Get_category_index    @"get_category_index"

#define KBase_Get_tag_index    @"get_tag_index"

#define KBase_Get_author_index    @"get_author_index"

#define KBase_Get_page_index    @"get_page_index"

#define KBase_Get_nonce    @"get_nonce"


///  Posts

#define KPosts_Create_post    @"posts/create_post"

#define KPosts_Update_post    @"posts/update_post"

#define KPosts_Delete_post    @"posts/delete_post"


///  Widgets

#define KWidgets_Get_sidebar    @"widgets/get_sidebar"

///  Respond

#define KRespond_Submit_comment    @"respond/submit_comment"



#endif /* WBSJsonHeader_h */
