import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'styles/text.dart';

import 'match.dart';
import 'joinMatch.dart';

// Main menu widget, responsible for rendering New Game options.
// If player chooses to join a new match, will create it and render Match.
// Else will redirect user to JoinMatch widget

class MainMenu extends StatefulWidget {
  MainMenu({Key? key, required this.playerReference}) : super(key: key);

  final DocumentReference playerReference;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final database = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final CollectionReference _matchesCollection =
        database.collection('matches');

    return Scaffold(
      appBar: AppBar(
        title: Text('Main menu'),
      ),
      body: Center(
        child: StreamBuilder(
            stream: widget.playerReference.snapshots(),
            builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Loading...', style: secondaryTextStyle),
                );
              } else {
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}',
                      style: secondaryTextStyle);
                else
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.close_outlined,
                        color: Colors.blueGrey,
                        size: 120.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 36),
                        child: Text(
                          'Times Table Game',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            final matchReference =
                                await _matchesCollection.add({
                              "player_1": widget.playerReference.id,
                              "player_2": null,
                              "winner": null,
                              "round": null,
                              "player_1_deck": null,
                              "player_1_card": null,
                              "player_2_deck": null,
                              "player_2_card": null,
                              "player_1_answered_at": null,
                              "player_2_answered_at": null,
                              "answer": null,
                            });

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Match(
                                        matchReference: matchReference,
                                        playerReference: widget.playerReference,
                                      )),
                            );
                          },
                          child: const Text('New match'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: OutlinedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JoinMatch(
                                      playerReference: widget.playerReference)),
                            );
                          },
                          child: const Text('Join match'),
                        ),
                      )
                    ],
                  );
              }
            }),
      ),
    );
  }
}
