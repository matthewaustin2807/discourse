import 'package:discourse/pages/discussionforum/create_discussion_entry_page.dart';
import 'package:discourse/pages/marketpage/create_market_listing_page.dart';
import 'package:discourse/pages/discussionforum/discussion_entry_page.dart';
import 'package:discourse/pages/discussionforum/discussion_forum_page.dart';
import 'package:discourse/pages/marketpage/my_listing_page.dart';
import 'package:discourse/pages/myaccounts/my_bookmarks_page.dart';
import 'package:discourse/pages/myaccounts/my_review_detail_page.dart';
import 'package:discourse/pages/myaccounts/my_reviews_page.dart';
import 'package:discourse/pages/myaccounts/my_account_page.dart';
import 'package:discourse/pages/reviewdigest/all_review_page.dart';
import 'package:discourse/pages/reviewdigest/comparison_result_page.dart';
import 'package:discourse/pages/reviewdigest/instructor_page.dart';
import 'package:discourse/pages/reviewdigest/review_detail_page.dart';
import 'package:discourse/pages/reviewdigest/review_digest.dart';
import 'package:discourse/pages/reviewdigest/selecting_compare_page.dart';
import 'package:discourse/pages/writereview/successful_review_page.dart';
import 'package:discourse/pages/writereview/write_review_page.dart';
import 'package:discourse/service/bookmark_service.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:discourse/service/course_service.dart';
import 'package:discourse/service/discussion_service.dart';
import 'package:discourse/service/instructor_service.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:discourse/service/upload_service.dart';
import 'package:discourse/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:discourse/pages/home_page.dart';
import 'package:discourse/pages/marketpage/listing_detail_page.dart';
import 'package:discourse/pages/marketpage/market_page.dart';
import 'package:logging/logging.dart';
import 'package:discourse/service/service.dart';

/// Application State class which controls the navigation in the app.
class ApplicationState extends ChangeNotifier {
  final Map<String, Service> services = {
    'courseService': CourseService(),
    'instructorService': InstructorService(),
    'courseReviewService': CourseReviewService(),
    'bookmarkService': BookmarkService(),
    'fileUploadService': FileUploadService(),
    'discussionService': DiscussionService(),
  };

  late Widget currentShownPage;
  List<Widget> navigationStack = [];
  List<String> navigationNameStack = [];
  List<int> navigationIdxStack = [];
  int currentPageIdxBottomNav = 2;

  /// Pages accessible from MyAccount Page
  Set<String> pagesInMyAccount = {
    '/myaccount',
    '/myreviews',
    '/myreviewdetail',
    '/mybookmarks'
  };

  /// Pages accessible from the Bottom Navigation Bar
  Map<String, int> pagesInBottomNav = {
    '/homepage': 2,
    '/reviewdigest': 0,
    '/writereview': 1,
    '/discussionforum': 3,
    '/marketplace': 4
  };

  final log = Logger('Application State');

  /// Initializing Application State for Testing
  void init() {
    currentShownPage = HomePage(
        firebaseAuth: FirebaseAuth.instance,
        courseReviewService:
            services['courseReviewService'] as CourseReviewService);
    navigationStack.add(currentShownPage);
    navigationIdxStack.add(pagesInBottomNav['/homepage']!);
    navigationNameStack.add('/homepage');
    currentPageIdxBottomNav = navigationIdxStack[navigationIdxStack.length - 1];
  }

  /// Returns whether the bottom nav UI should update
  bool showInBottomNav() {
    return !pagesInMyAccount
        .contains(navigationNameStack[navigationNameStack.length - 1]);
  }

  /// Clears the Navigation Stack and add HomePage to it.
  void _clearNavstackAndAddHome() {
    navigationStack.clear();
    navigationIdxStack.clear();
    navigationNameStack.clear();

    navigationNameStack.add('/homepage');
    navigationIdxStack.add(pagesInBottomNav['/homepage']!);
    navigationStack.add(HomePage(
        firebaseAuth: FirebaseAuth.instance,
        courseReviewService:
            services['courseReviewService'] as CourseReviewService));
  }

  /// Given an index of the Bottom Navigation Bar, navigate to that page
  void navigateFromBottomNav(int idx) {
    switch (idx) {
      case 0:
        _clearNavstackAndAddHome();
        currentShownPage = ReviewDigest(
          instructorService: services['instructorService'] as InstructorService,
          courseService: services['courseService'] as CourseService,
          courseReviewService:
              services['courseReviewService'] as CourseReviewService,
          bookmarkService: services['bookmarkService'] as BookmarkService,
          firebaseAuth: FirebaseAuth.instance,
        );
        navigationNameStack.add('/reviewdigest');
        navigationIdxStack.add(pagesInBottomNav['/reviewdigest']!);
        break;
      case 1:
        _clearNavstackAndAddHome();
        currentShownPage = WriteReviewPage(
          courseService: services['courseService']! as CourseService,
          instructorService: services['instructorService'] as InstructorService,
        );
        navigationNameStack.add('/writereview');
        navigationIdxStack.add(pagesInBottomNav['/writereview']!);
        break;
      case 2:
        _clearNavstackAndAddHome();
        currentShownPage = navigationStack[navigationStack.length - 1];
        break;
      case 3:
        _clearNavstackAndAddHome();
        currentShownPage = DiscussionForumPage(
          discussionService: services['discussionService'] as DiscussionService,
        );
        navigationNameStack.add('/discussionforum');
        navigationIdxStack.add(pagesInBottomNav['/discussionforum']!);
        break;
      case 4:
        _clearNavstackAndAddHome();
        currentShownPage = MarketPage(
          marketPageItemService: MarketPageItemService(),
        );
        navigationNameStack.add('/marketplace');
        navigationIdxStack.add(pagesInBottomNav['/marketplace']!);
        break;
    }
    navigationStack.add(currentShownPage);
    currentPageIdxBottomNav = navigationIdxStack[navigationIdxStack.length - 1];
    notifyListeners();
  }

  /// Navigate through the different pages in the app given the route. Optional parameters could be passed in state objects from individual pages.
  void changePages(
    String route, {
    dynamic param1,
    dynamic param2,
  }) {
    switch (route) {
      case '/homepage':
        _clearNavstackAndAddHome();
        currentShownPage = navigationStack[navigationStack.length - 1];
      case '/mybookmarks':
        currentShownPage = MyBookmarksPage(
          courseReviewService:
              services['courseReviewService'] as CourseReviewService,
          firebaseAuth: FirebaseAuth.instance,
        );
        navigationNameStack.add('/mybookmarks');
      case '/myreviewdetail':
        currentShownPage = MyReviewDetailPage(review: param1);
        navigationNameStack.add('/myreviewdetail');
      case '/myreviews':
        currentShownPage = MyReviewPage(
          courseReviewService:
              services['courseReviewService'] as CourseReviewService,
          firebaseAuth: FirebaseAuth.instance,
        );
        navigationNameStack.add('/myreviews');
      case '/myaccount':
        currentShownPage = MyAccount(
          courseReviewService:
              services['courseReviewService'] as CourseReviewService,
          firebaseAuth: FirebaseAuth.instance,
          fileUploadService: services['fileUploadService'] as FileUploadService,
        );
        navigationNameStack.add('/myaccount');
      case '/reviewdigest':
        currentShownPage = ReviewDigest(
          instructorService: services['instructorService'] as InstructorService,
          courseService: services['courseService'] as CourseService,
          courseReviewService:
              services['courseReviewService'] as CourseReviewService,
          bookmarkService: services['bookmarkService'] as BookmarkService,
          firebaseAuth: FirebaseAuth.instance,
          initiallySearchedCourse: param1,
        );
        navigationNameStack.add('/reviewdigest');
        navigationIdxStack.add(pagesInBottomNav['/reviewdigest']!);
      case '/reviewdetail':
        currentShownPage = ReviewDetailPage(
          review: param1,
          isBookmarked: param2,
        );
        navigationNameStack.add('/reviewdetail');
      case '/instructordetail':
        currentShownPage = InstructorPage(
          instructorId: param1,
          instructorService: services['instructorService'] as InstructorService,
        );
        navigationNameStack.add('/instructordetail');
      case '/allreviews':
        currentShownPage = AllReviewPage(
          courseReview: param1,
        );
        navigationNameStack.add('/allreviews');
      case '/selectcompare':
        currentShownPage = SelectCourseToComparePage(
          instructorService: services['instructorService'] as InstructorService,
          courseService: services['courseService'] as CourseService,
          courseReviewService:
              services['courseReviewService'] as CourseReviewService,
          bookmarkService: services['bookmarkService'] as BookmarkService,
          firebaseAuth: FirebaseAuth.instance,
          firstCourse: param1,
        );
        navigationNameStack.add('/selectcompare');
      case '/compareresult':
        currentShownPage = ComparisonResultPage(
          firstCourse: param1,
          secondCourse: param2,
          firebaseAuth: FirebaseAuth.instance,
          bookmarkService: services['bookmarkService'] as BookmarkService,
        );
        navigationNameStack.add('/compareresult');
      case '/writereview':
        currentShownPage = WriteReviewPage(
          courseService: services['courseService']! as CourseService,
          instructorService: services['instructorService'] as InstructorService,
        );
        navigationNameStack.add('/writereview');
        navigationIdxStack.add(pagesInBottomNav['/writereview']!);
      case '/successfulreview':
        currentShownPage = const SuccessfulReviewPage();
        navigationNameStack.add('/successfulreview');
      case '/discussionforum':
        currentShownPage = DiscussionForumPage(
          discussionService: services['discussionService'] as DiscussionService,
        );
        navigationNameStack.add('/discussionforum');
        navigationIdxStack.add(pagesInBottomNav['/discussionforum']!);
      case '/creatediscussionpage':
        currentShownPage = CreateDiscussionEntryPage(
            discussionService:
                services['discussionService'] as DiscussionService);
        navigationNameStack.add('/creatediscussionpage');
      case '/discussionentry':
        if (param1 != null) {
          currentShownPage = DiscussionEntryPage(
            entryId: param1,
            discussionService:
                services['discussionService'] as DiscussionService,
          );
          navigationNameStack.add('/discussionentry');
        }
      case '/marketplace':
        currentShownPage = MarketPage(
          marketPageItemService: MarketPageItemService(),
        );
        navigationNameStack.add('/marketplace');
        navigationIdxStack.add(pagesInBottomNav['/marketplace']!);
      case '/marketplacedetail':
        if (param1 != null) {
          currentShownPage = ListingDetailPage(item: param1);
          navigationNameStack.add('/marketplacedetail');
        }
      case '/createmarketlisting':
        currentShownPage = CreateMarketListingPage(
          marketPageItemService: MarketPageItemService(),
          fileUploadService: FileUploadService(),
        );
        navigationNameStack.add('/createmarketlisting');
      case '/mylisting':
        currentShownPage = MyListingPage(
          marketPageItemService: MarketPageItemService(),
          userService: UserService(),
        );
        navigationNameStack.add('/mylisting');
    }
    navigationStack.add(currentShownPage);
    currentPageIdxBottomNav = navigationIdxStack[navigationIdxStack.length - 1];
    notifyListeners();
  }

  /// Pops from the navigation stack. Used for back buttons in the App Bar
  void navigationPop() {
    navigationStack.removeLast();

    if (pagesInBottomNav
        .containsKey(navigationNameStack[navigationNameStack.length - 1])) {
      navigationIdxStack.removeLast();
      currentPageIdxBottomNav =
          navigationIdxStack[navigationIdxStack.length - 1];
    }
    navigationNameStack.removeLast();
    currentShownPage = navigationStack[navigationStack.length - 1];

    notifyListeners();
  }
}
