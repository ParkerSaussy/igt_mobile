import 'package:get/get.dart';

import '../modules/activities/activities_detail/activities_detail_binding.dart';
import '../modules/activities/activities_detail/activities_detail_view.dart';
import '../modules/activities/add_activities_screen/add_activities_screen_binding.dart';
import '../modules/activities/add_activities_screen/add_activities_screen_view.dart';
import '../modules/activities/filter/filter_binding.dart';
import '../modules/activities/filter/filter_view.dart';
import '../modules/chat_details_screen/chat_details_screen_binding.dart';
import '../modules/chat_details_screen/chat_details_screen_view.dart';
import '../modules/common_modules/about_us/about_us_binding.dart';
import '../modules/common_modules/about_us/about_us_view.dart';
import '../modules/common_modules/animated_splash/animated_splash_binding.dart';
import '../modules/common_modules/animated_splash/animated_splash_view.dart';
import '../modules/common_modules/contactus/contactus_binding.dart';
import '../modules/common_modules/contactus/contactus_view.dart';
import '../modules/common_modules/faq/faq_binding.dart';
import '../modules/common_modules/faq/faq_view.dart';
import '../modules/common_modules/help_screen/help_screen_binding.dart';
import '../modules/common_modules/help_screen/help_screen_view.dart';
import '../modules/common_modules/notifications/notifications_binding.dart';
import '../modules/common_modules/notifications/notifications_view.dart';
import '../modules/common_modules/onboarding_screen/onboarding_screen_binding.dart';
import '../modules/common_modules/onboarding_screen/onboarding_screen_view.dart';
import '../modules/common_modules/settings/settings_binding.dart';
import '../modules/common_modules/settings/settings_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/document/add_document/add_document_binding.dart';
import '../modules/document/add_document/add_document_view.dart';
import '../modules/document/documents/documents_binding.dart';
import '../modules/document/documents/documents_view.dart';
import '../modules/expense/add_expanses/add_expanses_binding.dart';
import '../modules/expense/add_expanses/add_expanses_view.dart';
import '../modules/expense/expanse_guest_list_tabs/expanse_guest_list_tabs_binding.dart';
import '../modules/expense/expanse_guest_list_tabs/expanse_guest_list_tabs_view.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_activities/expanse_activities_binding.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_activities/expanse_activities_view.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_pay/expanse_pay_binding.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_pay/expanse_pay_view.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_resolution_tabs_binding.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_resolution_tabs_view.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_resolutions/expanse_resolutions_binding.dart';
import '../modules/expense/expanse_resolution_tabs/expanse_resolutions/expanse_resolutions_view.dart';
import '../modules/lrf/forgot_password/forgot_password_binding.dart';
import '../modules/lrf/forgot_password/forgot_password_view.dart';
import '../modules/lrf/login/login_binding.dart';
import '../modules/lrf/login/login_view.dart';
import '../modules/lrf/otp_screen/otp_screen_binding.dart';
import '../modules/lrf/otp_screen/otp_screen_view.dart';
import '../modules/lrf/reset_password/reset_password_binding.dart';
import '../modules/lrf/reset_password/reset_password_view.dart';
import '../modules/lrf/signup/signup_binding.dart';
import '../modules/lrf/signup/signup_view.dart';
import '../modules/profile/change_password/change_password_binding.dart';
import '../modules/profile/change_password/change_password_view.dart';
import '../modules/profile/edit_profile/editprofile_binding.dart';
import '../modules/profile/edit_profile/editprofile_view.dart';
import '../modules/profile/my_profile/myprofile_binding.dart';
import '../modules/profile/my_profile/myprofile_view.dart';
import '../modules/subscription_plan_screen/subscription_plan_screen_binding.dart';
import '../modules/subscription_plan_screen/subscription_plan_screen_view.dart';
import '../modules/trip/poll_detail/city_poll_details/city_poll_details_binding.dart';
import '../modules/trip/poll_detail/city_poll_details/city_poll_details_view.dart';
import '../modules/trip/poll_detail/date_poll_details/date_poll_details_binding.dart';
import '../modules/trip/poll_detail/date_poll_details/date_poll_details_view.dart';
import '../modules/trip/poll_detail/poll_detail_binding.dart';
import '../modules/trip/poll_detail/poll_detail_view.dart';
import '../modules/trip/trip_detail/trip_detail_binding.dart';
import '../modules/trip/trip_detail/trip_detail_view.dart';
import '../modules/trip_creation_module/add_guest_import/add_guest_import_binding.dart';
import '../modules/trip_creation_module/add_guest_import/add_guest_import_view.dart';
import '../modules/trip_creation_module/added_guest_list/added_guest_list_binding.dart';
import '../modules/trip_creation_module/added_guest_list/added_guest_list_view.dart';
import '../modules/trip_creation_module/create_trip/create_trip_binding.dart';
import '../modules/trip_creation_module/create_trip/create_trip_view.dart';
import '../modules/trip_creation_module/event_trip_list_screen/event_trip_list_screen_binding.dart';
import '../modules/trip_creation_module/event_trip_list_screen/event_trip_list_screen_view.dart';
import '../modules/trip_creation_module/search_contact_screen/search_contact_screen_binding.dart';
import '../modules/trip_creation_module/search_contact_screen/search_contact_screen_view.dart';
import '../modules/trip_creation_module/select_trip_image/select_trip_image_binding.dart';
import '../modules/trip_creation_module/select_trip_image/select_trip_image_view.dart';
import '../modules/trip_creation_module/trip_guest_list/trip_guest_list_binding.dart';
import '../modules/trip_creation_module/trip_guest_list/trip_guest_list_view.dart';
import '../modules/trip_memories/add_new_photos/add_new_photos_binding.dart';
import '../modules/trip_memories/add_new_photos/add_new_photos_view.dart';
import '../modules/trip_memories/preview_trip_memories/preview_trip_memories_binding.dart';
import '../modules/trip_memories/preview_trip_memories/preview_trip_memories_view.dart';
import '../modules/trip_memories/trip_memories_screen/trip_memories_screen_binding.dart';
import '../modules/trip_memories/trip_memories_screen/trip_memories_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String getInitPage() {
    return Routes.ANIMATED_SPLASH;
  }

  static final routes = [
    GetPage(
      name: _Paths.ANIMATED_SPLASH,
      page: () => const AnimatedSplashView(),
      binding: AnimatedSplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREEN,
      page: () => const OnboardingScreenView(),
      binding: OnboardingScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.OTP_SCREEN,
      page: () => const OtpScreenView(),
      binding: OtpScreenBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_TRIP,
      page: () => const CreateTripView(),
      binding: CreateTripBinding(),
      children: [
        GetPage(
          name: _Paths.CITY_POLL_DETAILS,
          page: () => const CityPollDetailsView(),
          binding: CityPollDetailsBinding(),
        ),
        GetPage(
          name: _Paths.DATE_POLL_DETAILS,
          page: () => const DatePollDetailsView(),
          binding: DatePollDetailsBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.MYPROFILE,
      page: () => const MyProfileView(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDITPROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGEPASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.TRIP_DETAIL,
      page: () => const TripDetailView(),
      binding: TripDetailBinding(),
    ),
    GetPage(
      name: _Paths.POLL_DETAIL,
      page: () => const PollDetailView(),
      binding: PollDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADD_GUEST_IMPORT,
      page: () => const AddGuestImportView(),
      binding: AddGuestImportBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_TRIP_LIST_SCREEN,
      page: () => const EventTripListScreenView(),
      binding: EventTripListScreenBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_CONTACT_SCREEN,
      page: () => const SearchContactScreenView(),
      binding: SearchContactScreenBinding(),
    ),
    GetPage(
      name: _Paths.TRIP_GUEST_LIST,
      page: () => const TripGuestListView(),
      binding: TripGuestListBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITIES_DETAIL,
      page: () => const ActivitiesDetailView(),
      binding: ActivitiesDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ACTIVITIES_SCREEN,
      page: () => const AddActivitiesScreenView(),
      binding: AddActivitiesScreenBinding(),
    ),
    GetPage(
      name: _Paths.FILTER,
      page: () => const FilterView(),
      binding: FilterBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DOCUMENT,
      page: () => const AddDocumentView(),
      binding: AddDocumentBinding(),
    ),
    GetPage(
      name: _Paths.DOCUMENTS,
      page: () => const DocumentsView(),
      binding: DocumentsBinding(),
    ),
    GetPage(
      name: _Paths.CONTACTUS,
      page: () => const ContactusView(),
      binding: ContactusBinding(),
    ),
    GetPage(
      name: _Paths.ADD_NEW_PHOTOS,
      page: () => const AddNewPhotosView(),
      binding: AddNewPhotosBinding(),
    ),
    GetPage(
      name: _Paths.PREVIEW_TRIP_MEMORIES,
      page: () => const PreviewTripMemoriesView(),
      binding: PreviewTripMemoriesBinding(),
    ),
    GetPage(
      name: _Paths.TRIP_MEMORIES_SCREEN,
      page: () => const TripMemoriesScreenView(),
      binding: TripMemoriesScreenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EXPANSES,
      page: () => const AddExpansesView(),
      binding: AddExpansesBinding(),
    ),
    GetPage(
      name: _Paths.EXPANSE_RESOLUTION_TABS,
      page: () => const ExpanseResolutionTabsView(),
      binding: ExpanseResolutionTabsBinding(),
    ),
    GetPage(
      name: _Paths.EXPANSE_GUEST_LIST_TABS,
      page: () => const ExpanseGuestListTabsView(),
      binding: ExpanseGuestListTabsBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUTUS,
      page: () => const AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: _Paths.ADDED_GUEST_LIST,
      page: () => const AddedGuestListView(),
      binding: AddedGuestListBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_DETAILS_SCREEN,
      page: () => const ChatDetailsScreenView(),
      binding: ChatDetailsScreenBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION_PLAN_SCREEN,
      page: () => const SubscriptionPlanScreenView(),
      binding: SubscriptionPlanScreenBinding(),
    ),
    GetPage(
      name: _Paths.EXPANSE_ACTIVITIES,
      page: () => const ExpanseActivitiesView(),
      binding: ExpanseActivitiesBinding(),
    ),
    GetPage(
      name: _Paths.EXPANSE_RESOLUTIONS,
      page: () => const ExpanseResolutionsView(),
      binding: ExpanseResolutionsBinding(),
    ),
    GetPage(
      name: _Paths.EXPANSE_PAY,
      page: () => const ExpansePayView(),
      binding: ExpansePayBinding(),
    ),
    GetPage(
      name: _Paths.HELP_SCREEN,
      page: () => const HelpScreenView(),
      binding: HelpScreenBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_TRIP_IMAGE,
      page: () => const SelectTripImageView(),
      binding: SelectTripImageBinding(),
    ),
  ];
}
