import 'package:opencentric_lms/data/model/response/language_model.dart';
import 'package:opencentric_lms/utils/images.dart';

class AppConstants {
  static const String appName = 'LMS-Faculty';

  static const String loginUrl = 'user/login?_format=json';
  static const String registerUrl = 'user/register?_format=json';
  // static String listLesson(String limit, String page) =>
  //     'jsonapi/lms_lesson/default?page[limit]=$limit&page[offset]=$page';
  static String logout(String token) => 'user/logout?_format=json&token=$token';

  static const String refreshToken = 'jwt/token';
  static const String sessionToken = 'session/token';
  static const String forgotPassword = 'lms-reset-pass';
  static String resetPassword(String uid) => 'user/$uid?_format=json';
  // Profile
  static String user(String uid) => 'lms-user/$uid?_format=json';
  static const String updateProfile = 'jsonapi/profile/student';

  // Course
  static String profile(String uid) => 'lms-update-user/$uid?_format=json';
  static const String myCourse = 'user/courses?_format=json';
  static const String addCourse = 'lms-add-course?_format=json';
  static String teacherCourse(String teacherUid) =>
      'teacher-courses/$teacherUid?_format=json';
  static const String myCourseNew = 'lms/user-courses';
  static String courseDetail(String id) => '/product/$id?_format=json';
  static const String courseNotPurchased =
      '/api-coures-unpurchased?_format=json';
  static const String lmsCourse = '/lms-courses';
  static String lesson(String lessonId) => 'lms-lesson/$lessonId?_format=json';
  static String listLessonModule(String courseId) => 'lms-get-module-by-course/$courseId';
  static String listLesson(String courseId) =>
      'lms-lesson-by-course/$courseId?_format=json';
  static const String lmsCheckCoursePayment = 'lms-check-course-payment';
  static const String lmsCheckPermission = 'lms-check-permission';
  static const String lmsUserCourseCheck = 'lms-user-course-check';
  static const String courseProgress = 'lms-course-progress';
  static const String lmsUpdateStatusLesson = 'lms-update-status-lesson';

  // Quiz
  static const String getListQuizByCourseId = 'lms-quiz-by-course';
  static const String getListQuizByLessonId = 'lms-quiz-by-lesson';
  static const String answerQuiz = 'lms-submit-quiz';
  static const String lmsGetQuizResult = 'lms-get-quiz-result';

  // Forum
  static const String getForum = 'lms-get-forums';
  static const String getListTopic = 'lms-get-topics';
  static String getTopic(String topicId) => 'lms-get-topic/$topicId';
  static const String createForum = 'lms-create-forum-topic';
  static const String createComment = 'lms-post-comment-forum-topic';
  static const String lmsGetForumsOffline = 'lms-get-forums-offline';

  // Faq
  static const String getFaq = 'lms-get-faq';

  // Group
  static const String getGroup = 'lms-get-groups';
  static String getGroupDetail(String groupId) => 'lms-get-group/$groupId';
  static const String requestJoinGroup = 'lms-group-request-membership';
  static const String adminUpdateRequest =
      'lms-group-update-request-membership';
  static const String lmsGroupRemoveMember = 'lms-group-remove-member';
  static const String addGroupMember = 'lms-group-add-member';
  static const String checkAdminGroup = 'lms-check-permission';
  static const String inviteUserGroup = 'lms-group-create_invitation';
  static const String getListRequestJoinGroup = 'lms-group-list-member-request';

  // Discussion
  static const String listDiscussion = 'lms-list-message-by-user';
  static const String getListChat = 'lms-get-thread-by-private-message';
  static const String lmsPostPrivateMessage = 'lms-post-private-message';

  // Language
  static const String language = 'lms-languages?_format=json';

  // Cart
  static String getCart(String userId) => 'lms-get-cart/$userId';
  static const String addToCart = 'lms-add-cart';
  static const String lmsRemoveItemCart = 'lms-remove-item-cart';
  static const String updateCompleteCart = 'lms-order-complete';
  static const String lmsStartCourse = 'lms-start-course';

  /// Membership
  static const String getMembership = 'lms-membership-api';

  ///---------------------------------------------------------------------------

  // Domain example of template
  static const String configUrl = 'configs';
  static const String onBoards = 'on-boards';

  static const String socialLoginUrl = 'social-login';

  static const String registerWithPhone = 'register-by-phone';
  static const String verifyPhoneOTP = 'verify-phone-otp';
  static const String resendPhoneOTP = 'resend-phone-otp';
  static const String getPhoneLoginOTP = 'get-login-otp';
  static const String verifyLoginPhoneOTP = 'verify-login-otp';
  static const String verifyEmailOTP = 'email-verify';
  static const String resendEmailOTP = 'resend-email-otp';

  static const String verifyOTPForForgotPassword = 'verify-otp';

  static const String explore = 'explore';
  static const String homeScreen = 'home-screen';
  static const String latestCourse = 'latest-courses';
  static const String instructorProfile = 'instructor/profile';
  static const String instructorCourseList = 'instructor/courses';
  static const String instructorStudentList = 'instructor/students';
  static const String followUnfollow = 'user/follow-unfollow';
  //organization
  static const String organizationProfile = 'organization/profile';
  static const String organizationCourseList = 'organization/courses';
  static const String organizationInstructorList = 'organization/instructors';
  //my course screen
  static const String myCourseList = 'user/my-courses';
  static const String myWishList = 'user/my-wishlists';
  static const String addOrRemoveWishList = 'user/add-remove-wishlist';
  //book store
  static const String bookStore = 'book-store';
  static const String latestBooks = 'latest-books';
  static const String bookDetail = 'book';
  static const String reviews = 'reviews';
  static const String writeReviews = 'user/write-review';

  //cart
  // static const String addToCart = 'user/add-to-cart';
  static const String saveProgress = 'user/save-progress';
  static const String removeFromCart = 'user/carts';
  static const String cartList = 'user/carts';
  static const String applyCoupon = 'user/apply-coupon';
  static const String couponList = 'user/coupons';
  static const String meetingList = 'user/student/meeting';
  static const String myAssignment = 'user/my-assignments';
  static const String myResources = 'user/my-resources';
  static const String submitAssignment = 'user/submit-assignment';

  static const String deleteAccount = 'user/delete-account';
  //order history
  static const String orderHistory = 'user/order-histories';

  //conversation
  static const String instructorsList = 'user/instructors';
  static const String sendMessage = "user/send-message";
  static const String allMessages = "user/messages";

  //search
  static const String searchCourses = "search-courses";
  //category
  static const String courseCategories = "categories";
  static const String categoryCourses = "category-courses";
  static const String certificates = "user/certificates";
  static const String certificateDownload = "user/certificate-download";
  static const String courseSection = "user/course-sections";
  //quiz
  static const String quizData = "user/questions";
  //notification
  static const String notificationApi = 'user/notifications';

  static const String theme = 'lms_theme';
  static const String token = 'lms_token';
  static const String logoutToken = 'logoutToken';
  static const String cookie = 'cookie';
  static const String uid = 'lms_uid';
  static const String csrfToken = 'lms_csrf_token';
  static const String countryCode = 'lms_country_code';
  static const String languageCode = 'lms_language_code';
  static const String userPassword = 'lms_user_password';
  static const String userNumber = 'lms_user_number';
  static const String userCountryCode = 'lms_user_country_code';
  static const String notification = 'lms_notification';
  static const String isOnBoardScreen = 'lms_on_board_seen';
  static const String topic = 'customer';
  static const String createForumOffline = 'create_forum_offline';
  static const String createCommentOffline = 'create_comment_offline';
  static const String localizationKey = 'X-localization';
  static const String configUri = '/api/v1/customer/config';
  static const String socialRegisterUrl = '/api/v1/auth/social-register';
  static const String tokenUrl = '/api/v1/customer/update/fcm-token';
  static const String notificationCount = '/api/v1/customer/notification';
  static const String resetPasswordUrl = '/api/v1/customer/notification';
  static const String customerInfoUrl = '/api/v1/customer/notification';
  static const String updateProfileUrl = '/api/v1/customer/notification';
  static const String verifyTokenUrl = '/api/v1/customer/notification';

  static const String pages = '/api/v1/customer/config/pages';

  static const String verifyPhoneUrl = '/api/v1/customer/config/pages';
  static const String subscriptionUrl = '/api/v1/customer/config/pages';
  static const String createChannel = 'createChannel';
  static const String getChannelList = 'get-channel-list';
  static const String getConversation = 'get-conversation';
  static const String searchHistory = 'search-history';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.us,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.arabicTwo,
        languageName: 'Việt Nam',
        countryCode: 'VN',
        languageCode: 'vi'),
  ];

  static const String anonymous = 'anonymous';
  static const String authenticated = 'authenticated';
  static const String membership = 'membership';
  static const String student = 'student';
  static const String teacher = 'teacher';
  static const String contentEditor = 'content_editor';
  static const String administrator = 'administrator';
  static const String hostZoomClass = 'host_zoom_class';
}
