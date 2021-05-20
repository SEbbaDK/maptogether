import 'package:client/login_handler.dart';
import 'package:client/quests/simple_tag_quest.dart';
import 'package:flutter/material.dart';
import 'package:osm_api/osm_api.dart' as osm;
import 'package:provider/provider.dart';

class SimpleTagQuestPopUp extends StatelessWidget {
  SimpleTagQuestPopUp(this._quest, this._api);

  final osm.Api _api;
  final SimpleTagQuest _quest;

  List<Widget> createButtons(BuildContext context) {
    List<Widget> buttons = [];

    _quest.possibilitiesToTags().forEach((possibility, tag) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            _quest.solve(context.read<LoginHandler>().osmApi(), tag);
          },
          child: Text(possibility),
        ),
      );
    });
    return buttons;
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: Colors.lightGreen,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    height: 200,
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _quest.getQuestion(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ] +
          createButtons(context),
    ),
  );
}
