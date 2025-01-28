import 'package:discourse/constants/appColor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

/// Card that will be shown in the home page 
class HomePageCard extends StatefulWidget {
  const HomePageCard(this.idx, {super.key});
  final int idx;

  @override
  State<HomePageCard> createState() => _HomePageCardState(idx);
}

class _HomePageCardState extends State<HomePageCard> {
  _HomePageCardState(this.idx);

  final int idx;
  final List<String> _nameOfShortcuts = [
    'Review Digest',
    'Write a Review!',
    'Discussion Forum',
    'Market Place'
  ];

  final List<String> _descriptions = [
    'Check out some of the top reviewed courses!',
    'Write reviews for courses you’ve taken!',
    'Get more answers from the community!',
    'Find new and used course materials!'
  ];

  final Map<int, String> _mapNameToNavigationIdx = {
    0: '/reviewdigest',
    1: '/writereview',
    2: '/discussionforum',
    3: '/marketplace'
  };

  final List<IconData> _shortcutIcons = [
    Icons.list,
    Icons.edit_square,
    Icons.people,
    Icons.shopping_bag
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);
    return Semantics(
        button: true,
        label: 'Go to ${_nameOfShortcuts} page',
        child: GestureDetector(
            onTap: () {
              appState.changePages(_mapNameToNavigationIdx[idx]!);
            },
            child: Center(
                child: Container(
                    constraints: BoxConstraints(
                        maxHeight: screenSize.width * 0.48,
                        maxWidth: screenSize.width * 0.48),
                    decoration: BoxDecoration(
                        color: idx == 0 || idx == 3
                            ? AppColor().secondary
                            : AppColor().tertiary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            blurStyle: BlurStyle.normal,
                            color: AppColor().secondary,
                            offset: const Offset(5, 5),
                            spreadRadius: 0,
                          )
                        ]),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return MergeSemantics(
                          child: Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 18, left: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 2),
                                    child: ExcludeSemantics(
                                      child: Icon(
                                        _shortcutIcons[idx],
                                        size: 48,
                                        color: idx == 0 || idx == 3
                                            ? AppColor().textActiveSecondary
                                            : AppColor().textActivePrimary,
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                constraints.maxWidth * 0.6),
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Semantics(
                                          child: Wrap(
                                            children: [
                                              Text(
                                                _nameOfShortcuts[idx],
                                                style: TextStyle(
                                                  fontFamily: 'RegularText',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: idx == 0 || idx == 3
                                                      ? AppColor()
                                                          .textActiveSecondary
                                                      : AppColor()
                                                          .textActivePrimary,
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 42, left: 32, right: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Wrap(
                                    children: <Widget>[
                                      Text(
                                        _descriptions[idx],
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'RegularText',
                                          fontSize: 14,
                                          color: idx == 0 || idx == 3
                                              ? AppColor().textActiveSecondary
                                              : AppColor().textActivePrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                    })))));
  }
}
