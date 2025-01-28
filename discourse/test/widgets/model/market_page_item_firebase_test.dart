import 'package:flutter_test/flutter_test.dart';
import 'package:discourse/model/firebase_model/market_page_item_firebase.dart';

void main() {
  group('MarketPageItemFirebase', () {
    test('toMap should convert the MarketPageItemFirebase instance to a map', () {
      final item = MarketPageItemFirebase(
        id: 'item123',
        listerId: 'user456',
        imageLink: 'https://example.com/image.jpg',
        itemName: 'Test Item',
        listerName: "test name",
        itemCondition: 'New',
        itemDescription: 'This is a test item',
        tags: ['tag1', 'tag2'],
        fileUrls: ['https://example.com/file1', 'https://example.com/file2'],
      );

      final map = item.toMap();

      expect(map['id'], 'item123');
      expect(map['listerId'], 'user456');
      expect(map['imageLink'], 'https://example.com/image.jpg');
      expect(map['listerName'], 'test name');
      expect(map['itemName'], 'Test Item');
      expect(map['itemCondition'], 'New');
      expect(map['itemDescription'], 'This is a test item');
      expect(map['tags'], ['tag1', 'tag2']);
      expect(map['fileUrls'], ['https://example.com/file1', 'https://example.com/file2']);
    });

    test('fromDocument should convert a Firestore document map to a MarketPageItemFirebase instance', () {
      final document = {
        'id': 'item123',
        'listerId': 'user456',
        'imageLink': 'https://example.com/image.jpg',
        'itemName': 'Test Item',
        'listerName': 'test name',
        'itemCondition': 'New',
        'itemDescription': 'This is a test item',
        'tags': ['tag1', 'tag2'],
        'fileUrls': ['https://example.com/file1', 'https://example.com/file2'],
      };

      final item = MarketPageItemFirebase.fromDocument(document);

      expect(item.id, 'item123');
      expect(item.listerId, 'user456');
      expect(item.listerName, 'test name');
      expect(item.imageLink, 'https://example.com/image.jpg');
      expect(item.itemName, 'Test Item');
      expect(item.itemCondition, 'New');
      expect(item.itemDescription, 'This is a test item');
      expect(item.tags, ['tag1', 'tag2']);
      expect(item.fileUrls, ['https://example.com/file1', 'https://example.com/file2']);
    });
  });
}
