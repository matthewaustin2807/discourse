import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/model/tag.dart';
import 'package:discourse/pages/discussionforum/create_discussion_entry_page.dart';
import 'package:discourse/pages/discussionforum/discussion_entry_page.dart';
import 'package:discourse/pages/discussionforum/discussion_forum_page.dart';
import 'package:discourse/pages/home_page.dart';
import 'package:discourse/pages/marketpage/create_market_listing_page.dart';
import 'package:discourse/pages/marketpage/listing_detail_page.dart';
import 'package:discourse/pages/marketpage/market_page.dart';
import 'package:discourse/pages/myaccounts/my_account_page.dart';
import 'package:discourse/pages/myaccounts/my_bookmarks_page.dart';
import 'package:discourse/pages/myaccounts/my_review_detail_page.dart';
import 'package:discourse/pages/myaccounts/my_reviews_page.dart';
import 'package:discourse/pages/reviewdigest/all_review_page.dart';
import 'package:discourse/pages/reviewdigest/comparison_result_page.dart';
import 'package:discourse/pages/reviewdigest/instructor_page.dart';
import 'package:discourse/pages/reviewdigest/review_detail_page.dart';
import 'package:discourse/pages/reviewdigest/review_digest.dart';
import 'package:discourse/pages/reviewdigest/selecting_compare_page.dart';
import 'package:discourse/pages/writereview/write_review_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/pages/firebase_test_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test("Test Initialize Application State", () {
    ApplicationState appState = ApplicationState();
    appState.init();
    // Test that the initialize process is correct: Everything points to the HomePage
    expect(appState.currentShownPage, isInstanceOf<HomePage>());
    expect(appState.navigationStack.length, 1);
    expect(appState.navigationStack[0], isInstanceOf<HomePage>());
    expect(appState.navigationIdxStack.length, 1);
    expect(appState.navigationIdxStack[0], 2);
    expect(appState.navigationNameStack.length, 1);
    expect(appState.navigationNameStack[0], '/homepage');
    expect(appState.currentPageIdxBottomNav, 2);
  });

  test("Test Show in Bottom Nav Function", () {
    ApplicationState appState = ApplicationState();
    appState.init();
    appState.navigateFromBottomNav(0);
    expect(appState.showInBottomNav(), true);

    appState.changePages('/myaccount');
    expect(appState.showInBottomNav(), false);
  });

  test("Test Navigation From Bottom Navigation Bar", () {
    ApplicationState appState = ApplicationState();
    appState.init();
    // Test navigate to Review Digest
    appState.navigateFromBottomNav(0);
    expect(appState.currentShownPage, isInstanceOf<ReviewDigest>());
    expect(appState.navigationNameStack.last, '/reviewdigest');
    expect(appState.navigationIdxStack.last, 0);
    expect(appState.navigationStack.last, isInstanceOf<ReviewDigest>());
    expect(appState.currentPageIdxBottomNav, 0);

    // Test navigate to Write Review Page
    appState.navigateFromBottomNav(1);
    expect(appState.currentShownPage, isInstanceOf<WriteReviewPage>());
    expect(appState.navigationNameStack.last, '/writereview');
    expect(appState.navigationIdxStack.last, 1);
    expect(appState.navigationStack.last, isInstanceOf<WriteReviewPage>());
    expect(appState.currentPageIdxBottomNav, 1);

    // Test navigate to Home Page
    appState.navigateFromBottomNav(2);
    expect(appState.currentShownPage, isInstanceOf<HomePage>());
    expect(appState.navigationNameStack.last, '/homepage');
    expect(appState.navigationIdxStack.last, 2);
    expect(appState.navigationStack.last, isInstanceOf<HomePage>());
    expect(appState.currentPageIdxBottomNav, 2);

    // Test navigate to Discussion Forum
    appState.navigateFromBottomNav(3);
    expect(appState.currentShownPage, isInstanceOf<DiscussionForumPage>());
    expect(appState.navigationNameStack.last, '/discussionforum');
    expect(appState.navigationIdxStack.last, 3);
    expect(appState.navigationStack.last, isInstanceOf<DiscussionForumPage>());
    expect(appState.currentPageIdxBottomNav, 3);

    // Test navigate to Market Place
    appState.navigateFromBottomNav(4);
    expect(appState.currentShownPage, isInstanceOf<MarketPage>());
    expect(appState.navigationNameStack.last, '/marketplace');
    expect(appState.navigationIdxStack.last, 4);
    expect(appState.navigationStack.last, isInstanceOf<MarketPage>());
    expect(appState.currentPageIdxBottomNav, 4);
  });

  test("Test ChangePages", () {
    ApplicationState appState = ApplicationState();
    appState.init();
    // Test change page to My Bookmarks
    appState.changePages('/mybookmarks');
    expect(appState.currentShownPage, isInstanceOf<MyBookmarksPage>());
    expect(appState.navigationNameStack.last, '/mybookmarks');
    expect(appState.navigationStack.last, isInstanceOf<MyBookmarksPage>());

    IndividualCourseReview individualCourseReview = IndividualCourseReview(
        reviewerId: 'a',
        reviewerUsername: 'abc',
        courseId: '1',
        instructorId: '1',
        semester: 'Fall',
        year: '2024',
        tags: [],
        estimatedWorkload: '10-12 hrs',
        grade: 'A',
        difficultyRating: 3.5,
        overallRating: 3.5,
        reviewDetail: 'test');

    // Test change page to My Review Detail
    appState.changePages('/myreviewdetail', param1: individualCourseReview);
    expect(appState.currentShownPage, isInstanceOf<MyReviewDetailPage>());
    expect(appState.navigationNameStack.last, '/myreviewdetail');
    expect(appState.navigationStack.last, isInstanceOf<MyReviewDetailPage>());

    // Test change page to My Reviews
    appState.changePages('/myreviews');
    expect(appState.currentShownPage, isInstanceOf<MyReviewPage>());
    expect(appState.navigationNameStack.last, '/myreviews');
    expect(appState.navigationStack.last, isInstanceOf<MyReviewPage>());

    // Test change page to My Account
    appState.changePages('/myaccount');
    expect(appState.currentShownPage, isInstanceOf<MyAccount>());
    expect(appState.navigationNameStack.last, '/myaccount');
    expect(appState.navigationStack.last, isInstanceOf<MyAccount>());

    // Test change page to Review Digest
    appState.changePages('/reviewdigest');
    expect(appState.currentShownPage, isInstanceOf<ReviewDigest>());
    expect(appState.navigationNameStack.last, '/reviewdigest');
    expect(appState.navigationStack.last, isInstanceOf<ReviewDigest>());

    CourseReview courseReview = CourseReview(
        courseId: "a",
        instructorId: "b",
        course: Course(
            courseName: 'test course',
            courseNumber: '1234',
            courseId: '123',
            courseDescription: "test"),
        instructor:
            Instructor(firstName: 'john', lastName: 'doe', instructorId: 'abc'),
        averageOverallRating: 3.5,
        averageDifficultyRating: 3.5,
        tags: [
          "tag"
        ],
        workloadFrequency: {
          '10-13': 1,
        },
        gradeFrequency: {
          'A': 1,
        });
    // Test change page to My Bookmarks
    appState.changePages('/reviewdetail', param1: courseReview, param2: false);
    expect(appState.currentShownPage, isInstanceOf<ReviewDetailPage>());
    expect(appState.navigationNameStack.last, '/reviewdetail');
    expect(appState.navigationStack.last, isInstanceOf<ReviewDetailPage>());

    // Test change page to Instructor Detail
    appState.changePages('/instructordetail', param1: 'abc');
    expect(appState.currentShownPage, isInstanceOf<InstructorPage>());
    expect(appState.navigationNameStack.last, '/instructordetail');
    expect(appState.navigationStack.last, isInstanceOf<InstructorPage>());

    // Test change page to All Reviews
    appState.changePages('/allreviews', param1: courseReview);
    expect(appState.currentShownPage, isInstanceOf<AllReviewPage>());
    expect(appState.navigationNameStack.last, '/allreviews');
    expect(appState.navigationStack.last, isInstanceOf<AllReviewPage>());

    // Test change page to Select to Compare
    appState.changePages('/selectcompare', param1: courseReview);
    expect(
        appState.currentShownPage, isInstanceOf<SelectCourseToComparePage>());
    expect(appState.navigationNameStack.last, '/selectcompare');
    expect(appState.navigationStack.last,
        isInstanceOf<SelectCourseToComparePage>());

    // Test change page to All Reviews
    appState.changePages('/compareresult',
        param1: courseReview, param2: courseReview);
    expect(appState.currentShownPage, isInstanceOf<ComparisonResultPage>());
    expect(appState.navigationNameStack.last, '/compareresult');
    expect(appState.navigationStack.last, isInstanceOf<ComparisonResultPage>());

    // Test change page to Write Review
    appState.changePages('/writereview');
    expect(appState.currentShownPage, isInstanceOf<WriteReviewPage>());
    expect(appState.navigationNameStack.last, '/writereview');
    expect(appState.navigationStack.last, isInstanceOf<WriteReviewPage>());

    // Test change page to Discussion Forum
    appState.changePages('/discussionforum');
    expect(appState.currentShownPage, isInstanceOf<DiscussionForumPage>());
    expect(appState.navigationNameStack.last, '/discussionforum');
    expect(appState.navigationStack.last, isInstanceOf<DiscussionForumPage>());

    // Test change page to Discussion Forum
    appState.changePages('/discussionforum');
    expect(appState.currentShownPage, isInstanceOf<DiscussionForumPage>());
    expect(appState.navigationNameStack.last, '/discussionforum');
    expect(appState.navigationStack.last, isInstanceOf<DiscussionForumPage>());

    // Test change page to Create Discussion Page
    appState.changePages('/creatediscussionpage');
    expect(
        appState.currentShownPage, isInstanceOf<CreateDiscussionEntryPage>());
    expect(appState.navigationNameStack.last, '/creatediscussionpage');
    expect(appState.navigationStack.last,
        isInstanceOf<CreateDiscussionEntryPage>());

    // Test change page to Discussion Entry
    appState.changePages('/discussionentry', param1: 'a');
    expect(appState.currentShownPage, isInstanceOf<DiscussionEntryPage>());
    expect(appState.navigationNameStack.last, '/discussionentry');
    expect(appState.navigationStack.last, isInstanceOf<DiscussionEntryPage>());

    // Test change page to Market Place
    appState.changePages('/marketplace');
    expect(appState.currentShownPage, isInstanceOf<MarketPage>());
    expect(appState.navigationNameStack.last, '/marketplace');
    expect(appState.navigationStack.last, isInstanceOf<MarketPage>());

    // Test change page to Market Place Detail
    MarketPageItem item = MarketPageItem(
        id: "123",
        listerId: "kevin123",
        listerName: "name",
        imageLink: 'abc',
        itemName: 'Flutter for Beginners 3rd Edition Textbook 2015, 2016, 2017',
        itemCondition: 'used',
        itemDescription:
            'Full PDF download of the textbook. Had a blast learning about mobile app development in this course and I feel that you should also enjoy this textbook.',
        tags: List.generate(2, (idx) {
          return Tag(tagDescription: 'Used');
        }));
    appState.changePages('/marketplacedetail', param1: item);
    expect(appState.currentShownPage, isInstanceOf<ListingDetailPage>());
    expect(appState.navigationNameStack.last, '/marketplacedetail');
    expect(appState.navigationStack.last, isInstanceOf<ListingDetailPage>());

    // Test change page to Create market listing
    appState.changePages('/createmarketlisting');
    expect(appState.currentShownPage, isInstanceOf<CreateMarketListingPage>());
    expect(appState.navigationNameStack.last, '/createmarketlisting');
    expect(
        appState.navigationStack.last, isInstanceOf<CreateMarketListingPage>());
  });

  test("Test Navigation Pop", () {
    ApplicationState appState = ApplicationState();
    appState.init();
    appState.changePages('/reviewdigest');
    appState.navigationPop();

    expect(appState.currentShownPage, isInstanceOf<HomePage>());
    expect(appState.navigationNameStack.last, '/homepage');
    expect(appState.navigationStack.last, isInstanceOf<HomePage>());
  });
}
