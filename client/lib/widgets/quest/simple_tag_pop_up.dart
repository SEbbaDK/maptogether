import 'package:client/login_handler.dart';
import 'package:client/quests/quest_handler.dart';
import 'package:client/quests/simple_tag_quest.dart';
import 'package:flutter/material.dart';
import 'package:osm_api/osm_api.dart' as osm;
import 'package:provider/provider.dart';

class SimpleTagQuestPopUp extends StatelessWidget {
  SimpleTagQuestPopUp(this._quest, this._api);

  final osm.Api _api;
  final SimpleTagQuest _quest;

  int userId;
  int changeset;

  List<Widget> createButtons(BuildContext context) {
    List<Widget> buttons = [];

    _quest.possibilitiesToTags().forEach((possibility, tag) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            LoginHandler loginHandler = context.read<LoginHandler>();
            if (loginHandler.loggedIntoSocial()) {
              _quest
                  .solve(loginHandler.osmApi(), possibility,
                      mtapi: loginHandler.mtApi())
                  .then((value) {
                context
                    .read<QuestHandler>()
                    .removeQuest(_quest);
                Navigator.pop(context); //pop the info window for the quest// Remove the solved quest
              });
            } else {
              _quest
                  .solve(loginHandler.osmApi(), possibility)
                  .then((value) {
                context
                    .read<QuestHandler>()
                    .removeQuest(_quest);
                Navigator.pop(context); //pop the info window for the quest// Remove the solved quest
              });
            }
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
            color: Color.fromARGB(1000, 225, 229, 234),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _quest.question(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ] +
                    createButtons(context),
              ),
            ],
          ),
        ),
      );
}
