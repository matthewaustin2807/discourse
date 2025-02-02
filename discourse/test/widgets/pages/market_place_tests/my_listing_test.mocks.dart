// Mocks generated by Mockito 5.4.4 from annotations
// in discourse/test/widgets/pages/market_place_tests/my_listing_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:discourse/model/firebase_model/market_page_item_firebase.dart'
    as _i4;
import 'package:discourse/model/market_page_item.dart' as _i5;
import 'package:discourse/service/market_item_service.dart' as _i2;
import 'package:discourse/service/user_service.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [MarketPageItemService].
///
/// See the documentation for Mockito's code generation for more information.
class MockMarketPageItemService extends _i1.Mock
    implements _i2.MarketPageItemService {
  MockMarketPageItemService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> addItem(_i4.MarketPageItemFirebase? item) =>
      (super.noSuchMethod(
        Invocation.method(
          #addItem,
          [item],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<_i5.MarketPageItem>> getAllItems() => (super.noSuchMethod(
        Invocation.method(
          #getAllItems,
          [],
        ),
        returnValue:
            _i3.Future<List<_i5.MarketPageItem>>.value(<_i5.MarketPageItem>[]),
      ) as _i3.Future<List<_i5.MarketPageItem>>);

  @override
  _i3.Future<List<_i5.MarketPageItem>> getItemsByListerId(String? listerId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getItemsByListerId,
          [listerId],
        ),
        returnValue:
            _i3.Future<List<_i5.MarketPageItem>>.value(<_i5.MarketPageItem>[]),
      ) as _i3.Future<List<_i5.MarketPageItem>>);

  @override
  _i3.Future<void> deleteItem(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteItem,
          [id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [UserService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserService extends _i1.Mock implements _i6.UserService {
  MockUserService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<String> getCurrentUserUid() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentUserUid,
          [],
        ),
        returnValue: _i3.Future<String>.value(_i7.dummyValue<String>(
          this,
          Invocation.method(
            #getCurrentUserUid,
            [],
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<String> getUserDisplayName() => (super.noSuchMethod(
        Invocation.method(
          #getUserDisplayName,
          [],
        ),
        returnValue: _i3.Future<String>.value(_i7.dummyValue<String>(
          this,
          Invocation.method(
            #getUserDisplayName,
            [],
          ),
        )),
      ) as _i3.Future<String>);
}
