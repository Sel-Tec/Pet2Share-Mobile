//
//  ServiceConfig.h
//  pet2share
//
//  Created by Tony Kieu on 8/2/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#ifndef pet2share_ServiceConfig_h
#define pet2share_ServiceConfig_h

///------------------------------------------------------------------------------
///
/// Turn on the flag LOCALWEBSERVICE_TEST and specify local web service url to
/// requests locally or on a speficic host.
///
///------------------------------------------------------------------------------

// #define LOCALWEBSERVICE_TEST 1         // Turn on local testing mode

#define PET2SHARE_DEV_LOCAL_URL             @"http://192.168.200.7:8087"
#define PET2SHARE_DEV_URL                   @"http://service.pet2share.com"
#define PET2SHARE_QA_URL                    @""
#define PET2SHARE_STAGING_URL               @""
#define PET2SHARE_PROD_URL                  @"http://service.pet2share.com"

#define PET2SHARE_DEV_LOCAL_WEBSERVICE_PATH @"/Service_Main.svc"
#define PET2SHARE_DEV_WEBSERVICE_PATH       @"/Service_Main.svc"
#define PET2SHARE_QA_WEBSERVICE_PATH        @""
#define PET2SHARE_STAGING_WEBSERVICE_PATH   @""
#define PET2SHARE_PROD_WEBSERVICE_PATH      @"/Service_Main.svc"

#define PET2SHARE_DEV_KEY                   @"dev"
#define PET2SHARE_QA_KEY                    @"qa"
#define PET2SHARE_STAGING_KEY               @"staging"
#define PET2SHARE_PROD_KEY                  @"production"

///------------------------------------------------------------------------------
/// ENDPOINTS
///------------------------------------------------------------------------------

#define LOGIN_ENDPOINT                      @"LoginUser"
#define REGISTER_ENDPOINT                   @"Register"
#define GETUSERPROFILE_ENDPOINT             @"GetUserProfile"
#define UPDATEUSERPROFILE_ENDPOINT          @"UpdateUserProfile"
#define INSERTPETPROFILE_ENDPOINT           @"InsertPetProfile"
#define UPDATEPETPROFILE_ENDPOINT           @"UpdatePetProfile"
#define UPLOADUSERPICTURE_ENDPOINT          @"UploadUserPic"
#define UPLOADPETPICTURE_ENDPOINT           @"UploadPetPic"
#define GETPOSTSBYUSER_ENDPOINT             @"getPostsByUser"
#define GETFEEDSREQUEST_ENDPOINT            @"GetMyFeed"
#define GETPOSTSBYPET_ENDPOINT              @"getPostsByPet"
#define ADDPOST_ENDPOINT                    @"AddPost"
#define ADDPHOTOPOST_ENDPOINT               @"AddPhotoPost"
#define UPDATEPOST_ENDPOINT                 @"UpdatePost"
#define DELETEPOST_ENDPOINT                 @"DeletePost"
#define DELETEPOSTBYPOSTER_ENDPOINT         @"DeletePostByPoster"
#define GETCOMMENTS_ENDPOINT                @"GetComments"
#define ADDCOMMENT_ENDPOINT                 @"AddComment"
#define UPDATECOMMENT_ENDPOINT              @"UpdateComment"
#define DELETECOMMENT_ENDPOINT              @"DeleteComment"
#define DELETECOMMENTBYUSER_ENDPOINT        @"DeleteCommentByUser"

#endif