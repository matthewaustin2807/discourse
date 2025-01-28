import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/model/market_page_item.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

/// Page to show details about a particular listing
class ListingDetailPage extends StatefulWidget {
  const ListingDetailPage({super.key, required this.item});
  final MarketPageItem item;

  @override
  _ListingDetailPageState createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  bool _isDownloading = false;
  String _downloadStatus = "";

  /// Downloads the file into the user's device
  Future<void> downloadFile(String url, String fileName) async {
    setState(() {
      _isDownloading = true;
      _downloadStatus = "Downloading...";
    });

    try {
      var dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/$fileName";

      Dio dio = Dio();

      await dio.download(url, savePath);

      setState(() {
        _downloadStatus = "Download completed: $savePath";
        _isDownloading = false;
      });
      print("File saved to $savePath");

    } catch (e) {
      setState(() {
        _downloadStatus = "Download failed: $e";
        _isDownloading = false;
      });
      print("Error during download: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              DiscourseAppBar(
                parentContext: context,
                pageName: 'Listing Detail',
                isForm: false,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: screenSize.width * 0.9,
                    maxHeight: screenSize.height * 0.85),
                child: LayoutBuilder(
                  builder: (context, topLevelConstraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              width: topLevelConstraints.maxWidth,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ExcludeSemantics(
                                  child: widget.item.imageLink.isNotEmpty
                                      ? Image.network(
                                          widget.item.imageLink,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : const Icon(
                                          key: Key("pic"),
                                          Icons.image,
                                          size: 120,
                                          color: Color.fromARGB(160, 176, 176, 176),
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 14),
                              margin: const EdgeInsets.only(right: 48),
                              alignment: Alignment.centerLeft,
                              child: Semantics(
                                label: widget.item.itemName,
                                child: Wrap(
                                  children: [
                                    Text(
                                      widget.item.itemName,
                                      style: const TextStyle(
                                          fontFamily: 'RegularText',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Semantics(
                                  label: 'Tags associated with this listing',
                                  child: Wrap(
                                    children: List.generate(
                                        widget.item.tags.length, (idx) {
                                    return IndexedSemantics(
                                        index: idx,
                                        child: TagWidget(
                                            tagName: widget.item.tags[idx]
                                                .tagDescription));
                                  }))),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.topLeft,
                              child: Semantics(
                                label: widget.item.itemDescription,
                                child: Wrap(
                                  children: [
                                    Text(widget.item.itemDescription,
                                        style: const TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 24),
                                margin: const EdgeInsets.only(right: 16),
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Listed by:",
                                        style: TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 16)),
                                    Text(widget.item.listerName,
                                        style: const TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 16))
                                  ],
                                )),
                            if (_downloadStatus.isNotEmpty)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(_downloadStatus),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (widget.item.fileUrls != null)
          Positioned(
            bottom: 16,
            right: 16,
            child: Semantics(
              label: 'Download file',
              button: true,
              child: FloatingActionButton(
                onPressed: _isDownloading
                  ? null
                  : () {
                      for (String url in widget.item.fileUrls!) {
                        String fileName = url.split('/').last;
                        downloadFile(url, fileName); 
                      }
                    },
                child: const Icon(Icons.download, size: 36),
              ),
            ),
          ),
        ],
    );
  }

}
