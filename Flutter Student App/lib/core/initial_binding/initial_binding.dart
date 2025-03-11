import 'package:get/get.dart';
import 'package:opencentric_lms/controller/assignment_controller.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/controller/book_detail_controller.dart';
import 'package:opencentric_lms/controller/book_store_controller.dart';
import 'package:opencentric_lms/controller/cart_controller.dart';
import 'package:opencentric_lms/controller/category_controller.dart';
import 'package:opencentric_lms/controller/certificate_controller.dart';
import 'package:opencentric_lms/controller/chat_controller.dart';
import 'package:opencentric_lms/controller/classroom_controller.dart';
import 'package:opencentric_lms/controller/course_controller.dart';
import 'package:opencentric_lms/controller/course_detail_controller.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';
import 'package:opencentric_lms/controller/group_controller.dart';

import 'package:opencentric_lms/controller/localization_controller.dart';
import 'package:opencentric_lms/controller/meeting_controller.dart';
import 'package:opencentric_lms/controller/membership_controller.dart';
import 'package:opencentric_lms/controller/my_course_controller.dart';
import 'package:opencentric_lms/controller/explore_controller.dart';
import 'package:opencentric_lms/controller/home_controller.dart';
import 'package:opencentric_lms/controller/html_view_controller.dart';
import 'package:opencentric_lms/controller/language_controller.dart';
import 'package:opencentric_lms/controller/notification_controller.dart';
import 'package:opencentric_lms/controller/on_board_pager_controller.dart';
import 'package:opencentric_lms/controller/order_controller.dart';
import 'package:opencentric_lms/controller/payment_controller.dart';
import 'package:opencentric_lms/controller/resource_controller.dart';
import 'package:opencentric_lms/controller/search_controller.dart';
import 'package:opencentric_lms/controller/splash_controller.dart';
import 'package:opencentric_lms/controller/theme_controller.dart';
import 'package:opencentric_lms/repository/auth_repo.dart';
import 'package:opencentric_lms/repository/language_repo.dart';
import 'package:opencentric_lms/repository/my_course_repository.dart';
import 'package:opencentric_lms/repository/notification_repo.dart';
import 'package:opencentric_lms/repository/on_board_repository.dart';
import 'package:opencentric_lms/repository/search_repo.dart';
import 'package:opencentric_lms/repository/splash_repo.dart';
import 'package:opencentric_lms/training/controller/your_account_controller.dart';
import 'package:opencentric_lms/training/repository/your_account_repo.dart';
import '../../controller/coupon_controller.dart';
import '../../controller/course_detail_not_purchase_controller.dart';
import '../../controller/course_detail_offline_controller.dart';
import '../../controller/instructor_controller.dart';
import '../../controller/my_audio_player_controller.dart';
import '../../controller/my_course_offline_controller.dart';
import '../../controller/organization_controller.dart';
import '../../controller/quiz_controller.dart';
import '../../controller/user_controller.dart';
import '../../controller/video_player_controller.dart';
import '../../controller/wishlist_controller.dart';
import '../../repository/course_detail_repo.dart';
import '../../repository/explore_repository.dart';
import '../../repository/home_repository.dart';
import '../../repository/instructor_repository.dart';
import '../../repository/organization_repository.dart';
import '../../repository/quiz_repository.dart';
import '../../repository/user_repo.dart';
import '../../repository/wish_list_repository.dart';
import '../../training/repository/faq_repo.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => MyCourseOfflineController());
    Get.lazyPut(() => YourAccountController(yourAccountRepo: YourAccountRepo(apiClient: Get.find()), faqRepo: FaqRepo(apiClient: Get.find())));

    //common controller
    Get.lazyPut(() => SplashController(
        splashRepo:
            SplashRepo(apiClient: Get.find(), sharedPreferences: Get.find())));
    Get.lazyPut(() => AuthController(
        authRepo:
            AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find())));
    Get.lazyPut(() => NotificationController(
        notificationRepo: NotificationRepo(
            apiClient: Get.find(), sharedPreferences: Get.find())));
    Get.lazyPut(() => LanguageController(
        languageRepo: LanguageRepo(
            apiClient: Get.find(), sharedPreferences: Get.find())));
    Get.lazyPut(() => HomeController(
        homeRepository: HomeRepository(
            sharedPreferences: Get.find(), apiClient: Get.find())));
    Get.lazyPut(() => SearchController(
        searchRepo:
            SearchRepo(apiClient: Get.find(), sharedPreferences: Get.find())));
    Get.lazyPut(() => PaymentController(Get.find()));
    Get.lazyPut(() => OnBoardController(
        repository: OnBoardRepository(apiClient: Get.find())));
    Get.lazyPut(() => BookStoreController());
    Get.lazyPut(() => BookDetailController());
    //Get.lazyPut(() => ConversationController(
    //    conversationRepo: ConversationRepo(apiClient: Get.find())));
    Get.lazyPut(() => ExploreController(
        exploreRepository: ExploreRepository(apiClient: Get.find())));
    Get.lazyPut(() => CourseDetailController(
        courseDetailsRepository:
            CourseDetailsRepository(apiClient: Get.find())));
    Get.lazyPut(() => CourseDetailOfflineController(
        courseDetailsRepository:
            CourseDetailsRepository(apiClient: Get.find())));
    Get.lazyPut(() => CourseDetailNotPurchaseController(
        courseDetailsRepository:
            CourseDetailsRepository(apiClient: Get.find())));
    Get.lazyPut(() => InstructorController(
        repository: InstructorRepository(apiClient: Get.find())));
    Get.lazyPut(() => OrganizationController(
        repository: OrganizationRepository(apiClient: Get.find())));
    Get.lazyPut(() => MyCourseController(
        repository: MyCourseRepository(apiClient: Get.find())));
    Get.lazyPut(() => WishListController(
        repository: WishListRepository(apiClient: Get.find())));
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => MembershipController());
    Get.lazyPut(() => CouponController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => CourseController());
    Get.lazyPut(() => CertificateController());

    Get.lazyPut(() => LocalizationController(
        sharedPreferences: Get.find(), apiClient: Get.find()));
    Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
    Get.lazyPut(() => ClassroomController());
    Get.lazyPut(() => MyVideoPlayerController());
    Get.lazyPut(() => MyAudioPlayerController());
    Get.lazyPut(() => MeetingController());
    Get.lazyPut(() => AssignmentController());
    Get.lazyPut(() => ForumController());
    Get.lazyPut(() => GroupController());
    Get.lazyPut(
        () => QuizController(quizRepo: QuizRepository(apiClient: Get.find())));
    Get.lazyPut(() => HtmlViewController(
        splashRepo:
            SplashRepo(apiClient: Get.find(), sharedPreferences: Get.find())));
    Get.lazyPut(() => ResourceController());
    Get.lazyPut(() => UserController(
        userRepo:
            UserRepo(apiClient: Get.find(), sharedPreferences: Get.find())));
  }
}
