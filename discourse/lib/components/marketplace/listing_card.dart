import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Listing card that shows details of a marketpage item listing
class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.item});
  final MarketPageItem item;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return GestureDetector(
        onTap: () {
          appState.changePages('/marketplacedetail', param1: item);
        },
        child: Container(
            margin: const EdgeInsets.only(top: 10),
            constraints: BoxConstraints(
              maxWidth: screenSize.width,
              maxHeight: screenSize.height * 0.15,
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
                    margin: EdgeInsets.only(left: topLevelConstraints.maxWidth * 0.07, right: topLevelConstraints.maxWidth * 0.07, bottom: topLevelConstraints.maxWidth * 0.05),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.imageLink.isNotEmpty
                          ? Image.network(
                              item.imageLink,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image,
                              size: 90,
                              color: Color.fromARGB(160, 176, 176, 176),
                            ),
                    ),
                  ),
                  Container(
                    width: topLevelConstraints.maxWidth * 0.55,
                    child: LayoutBuilder(builder: (context, boxConstraints) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left:5, right: 5),
                              child: Wrap(
                                children: [
                                  Semantics(
                                    label: item.itemName,
                                    child: Text(item.itemName,
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontFamily: 'RegularText',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric( horizontal: 2),
                              width: boxConstraints.maxWidth,
                              child: Semantics(
                                label: 'Tags associated with this listing',
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
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
                            Container(
                              padding: const EdgeInsets.only(left: 8, bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Listed by:",
                                      style:
                                          TextStyle(fontFamily: 'RegularText')),
                                  Text(item.listerName,
                                      style: const TextStyle(
                                          fontFamily: 'RegularText'))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  )
                ],
              );
            })));
  }
}
