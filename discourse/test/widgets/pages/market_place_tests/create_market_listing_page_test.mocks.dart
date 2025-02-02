// Mocks generated by Mockito 5.4.4 from annotations
// in discourse/test/widgets/pages/market_place_tests/create_market_listing_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:io' as _i9;

import 'package:discourse/model/firebase_model/market_page_item_firebase.dart'
    as _i4;
import 'package:discourse/model/market_page_item.dart' as _i5;
import 'package:discourse/service/market_item_service.dart' as _i2;
import 'package:discourse/service/upload_service.dart' as _i6;
import 'package:image_picker/image_picker.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;

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

/// A class which mocks [FileUploadService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFileUploadService extends _i1.Mock implements _i6.FileUploadService {
  MockFileUploadService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<String> uploadImage(_i7.XFile? image) => (super.noSuchMethod(
        Invocation.method(
          #uploadImage,
          [image],
        ),
        returnValue: _i3.Future<String>.value(_i8.dummyValue<String>(
          this,
          Invocation.method(
            #uploadImage,
            [image],
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<String> uploadFile(_i9.File? file) => (super.noSuchMethod(
        Invocation.method(
          #uploadFile,
          [file],
        ),
        returnValue: _i3.Future<String>.value(_i8.dummyValue<String>(
          this,
          Invocation.method(
            #uploadFile,
            [file],
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<String> uploadProfilePicture(_i7.XFile? file) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadProfilePicture,
          [file],
        ),
        returnValue: _i3.Future<String>.value(_i8.dummyValue<String>(
          this,
          Invocation.method(
            #uploadProfilePicture,
            [file],
          ),
        )),
      ) as _i3.Future<String>);
}
