import 'package:flutter/material.dart';
import 'package:qboard/data/fouls.dart';
import 'package:qboard/pages/matches.dart';
import 'package:qboard/widgets/fade_background.dart';

import 'clipped_dialog.dart';
import 'foul_card.dart';

class CardCollection extends StatefulWidget {
  
  const CardCollection({
    Key key,
    @required this.fadeBackground,
    @required this.matchState,
  }) : super(key: key);

  final GlobalKey fadeBackground;
  final MatchState matchState;

  @override
  CardCollectionState createState() => CardCollectionState();
}

class CardCollectionState extends State<CardCollection> {

  ClippedDialogState selectedCard;
  GlobalKey blueCardKey = GlobalKey();
  GlobalKey yellowCardKey = GlobalKey();
  GlobalKey redCardKey = GlobalKey();

  tapCallback(ClippedDialogState tappedCard) {
    
    if (selectedCard != null) {
      selectedCard.setState(() {
        selectedCard.isShown = false;
        (selectedCard.widget.child as FoulCard).clearCard();
      });
    }
    selectedCard = tappedCard;
    selectedCard.setState(() {selectedCard.isShown = true;});

    widget.fadeBackground.currentState.setState(() {
      (widget.fadeBackground.currentState as FadeBackgroundState).isFaded = true;
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
              key: blueCardKey,
              onTapped: tapCallback,
              edgeAlignment: 0.8,
              color: cardTypeColor[CardType.Red],
              child: FoulCard(
                parent: widget.matchState,
                cardType: CardType.Red,
                teams: [widget.matchState.team1, widget.matchState.team2],
              )
            ),
            ClippedDialog(
              key: yellowCardKey,
              onTapped: tapCallback,
              edgeAlignment: 0.0,
              color: cardTypeColor[CardType.Yellow],
              child: FoulCard(
                parent: widget.matchState,
                cardType: CardType.Yellow,
                teams: [widget.matchState.team1, widget.matchState.team2],
              )
            ),
            ClippedDialog(
              key: redCardKey,
              onTapped: tapCallback,
              edgeAlignment: -0.8,
              color: cardTypeColor[CardType.Blue],
              child: FoulCard(
                parent: widget.matchState,
                cardType: CardType.Blue,
                teams: [widget.matchState.team1, widget.matchState.team2],
              )
            ),
          ]
        ),
      ),
    );
  }
}