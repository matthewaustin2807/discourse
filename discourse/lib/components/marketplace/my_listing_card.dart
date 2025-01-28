import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Card that shows listing that are made by the user.
class MyListingCard extends StatelessWidget {
  const MyListingCard({super.key, required this.item, required this.onUnlist});
  final MarketPageItem item;
  final VoidCallback onUnlist; 

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final marketService = MarketPageItemService();
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return GestureDetector(
        onTap: () {
          appState.changePages('/marketplacedetail', param1: item);
        },
        child: Container(
            margin: const EdgeInsets.only(top: 30),
            constraints: BoxConstraints(
              maxWidth: screenSize.width,
              minHeight: 170,
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: AppColor().separator, width: 1.5))),
            child: LayoutBuilder(builder: (context, topLevelConstraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: topLevelConstraints.maxWidth * 0.07,
                        right: topLevelConstraints.maxWidth * 0.07,
                        bottom: topLevelConstraints.maxWidth * 0.05),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.imageLink.isNotEmpty
                          ? Image.network(
                              item.imageLink,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image,
                              size: 120,
                              color: Color.fromARGB(160, 176, 176, 176),
                            ),
                    ),
                  ),
                  Container(
                    width: topLevelConstraints.maxWidth * 0.55,
                    child: LayoutBuilder(builder: (context, boxConstraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Wrap(
                              children: [
                                Semantics(
                                  label: item.itemName,
                                  child: Text(item.itemName,
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'RegularText',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                            width: boxConstraints.maxWidth,
                            child: Semantics(
                              label: 'Tags associated with this listing',
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 35,
                                ),
                                child: Wrap(
                                  children: List.generate(item.tags.length, (idx) {
                                    return IndexedSemantics(
                                      index: idx,
                                      child: TagWidget(
                                        tagName: item.tags[idx].tagDescription,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 20),
                          // Unlist Button Section
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await marketService.deleteItem(item.id);
                                  onUnlist();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to unlist item: $e'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor().primary, // Button color
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text(
                                "Unlist",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RegularText'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  )
                ],
              );
            })));
  }
}
