import 'package:flutter/material.dart';
import 'package:qboard/data/fouls.dart';
import 'package:qboard/pages/matches.dart';
import 'package:qboard/widgets/fade_background.dart';

import 'clipped_dialog.dart';
import 'foul_card.dart';

class CardCollection extends StatelessWidget {
  CardCollection({
    Key key,
    @required this.fadeBackground,
    @required this.matchState,
  }) : super(key: key);

  final GlobalKey fadeBackground;
  final MatchState matchState;
  ClippedDialogState selectedCard;

  tapCallback(ClippedDialogState tappedCard) {
    
    if (selectedCard != null) {
      selectedCard.setState(() {
        selectedCard.widget.isShown = false;
        (selectedCard.widget.child as FoulCard).clearCard();
      });
    }
    selectedCard = tappedCard;
    selectedCard.setState(() {selectedCard.widget.isShown = true;});

    fadeBackground.currentState.setState(() {
      (fadeBackground.currentState as FadeBackgroundState).isFaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Stack(
          children: [
            ClippedDialog(
              onTapped: tapCallback,
              edgeAlignment: 0.8,
              color: cardTypeColor[CardType.Red],
              child: FoulCard(
                parent: matchState,
                cardType: CardType.Red,
                teams: [matchState.team1, matchState.team2],
              )
            ),
            ClippedDialog(
              onTapped: tapCallback,
              edgeAlignment: 0.0,
              color: cardTypeColor[CardType.Yellow],
              child: FoulCard(
                parent: matchState,
                cardType: CardType.Yellow,
                teams: [matchState.team1, matchState.team2],
              )
            ),
            ClippedDialog(
              onTapped: tapCallback,
              edgeAlignment: -0.8,
              color: cardTypeColor[CardType.Blue],
              child: FoulCard(
                parent: matchState,
                cardType: CardType.Blue,
                teams: [matchState.team1, matchState.team2],
              )
            ),
          ]
        ),
      ),
    );
  }
}