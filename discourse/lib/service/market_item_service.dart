import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/firebase_model/market_page_item_firebase.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/model/tag.dart';

/// MarketPage Service class to handle Market API calls
class MarketPageItemService {
  final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection('marketPageItems');

  /// Add a new MarketPageItem to Firestore
  Future<void> addItem(MarketPageItemFirebase item) async {
    final docRef = await _itemsCollection.add(item.toMap());
    await docRef.update({'id' : docRef.id});
  }

  /// Get all MarketPageItems in the collection
  Future<List<MarketPageItem>> getAllItems() async {
    QuerySnapshot querySnapshot = await _itemsCollection.get();

    final itemsFb =  querySnapshot.docs
        .map((doc) => MarketPageItemFirebase.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();
      
    final items = itemsFb.map((itemFb) => MarketPageItem(
      id: itemFb.id, 
      listerId: itemFb.listerId, 
      listerName: itemFb.listerName,
      imageLink: itemFb.imageLink, 
      itemName: itemFb.itemName, 
      itemCondition: itemFb.itemCondition, 
      itemDescription: itemFb.itemDescription, 
      tags: itemFb.tags.map((tag) => Tag(tagDescription: tag)).toList(), 
      fileUrls: itemFb.fileUrls)).toList();
    return items;
  }

    /// Get all MarketPageItems in the collection
  Future<List<MarketPageItem>> getItemsByListerId(String listerId) async {
    QuerySnapshot querySnapshot = await _itemsCollection .where('listerId', isEqualTo: listerId).get();

    final itemsFb =  querySnapshot.docs
        .map((doc) => MarketPageItemFirebase.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();
      
    final items = itemsFb.map((itemFb) => MarketPageItem(
      id: itemFb.id, 
      listerId: itemFb.listerId, 
      listerName: itemFb.listerName,
      imageLink: itemFb.imageLink, 
      itemName: itemFb.itemName, 
      itemCondition: itemFb.itemCondition, 
      itemDescription: itemFb.itemDescription, 
      tags: itemFb.tags.map((tag) => Tag(tagDescription: tag)).toList(), 
      fileUrls: itemFb.fileUrls)).toList();
    return items;
  }

  /// Delete a MarketPageItem by its document ID
  Future<void> deleteItem(String id) async {
    await _itemsCollection.doc(id).delete();
  }
}
