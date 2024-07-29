import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../models/player_data.dart';
import '../models/spaceship_details.dart';

import 'game_play.dart';
import 'main_menu.dart';


class SelectSpaceship extends StatelessWidget {
  const SelectSpaceship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                'Select',
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),

            Consumer<PlayerData>(
              builder: (context, playerData, child) {
                final spaceship =
                    Spaceship.getSpaceshipByType(playerData.spaceshipType);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Ship: ${spaceship.name}'),
                    Text('Money: ${playerData.money}'),
                  ],
                );
              },
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: CarouselSlider.builder(
                itemCount: Spaceship.spaceships.length,
                slideBuilder: (index) {
                  final spaceship =
                      Spaceship.spaceships.entries.elementAt(index).value;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(spaceship.assetPath),
                      Text(spaceship.name),
                      Text('Speed: ${spaceship.speed}'),
                      Text('Level: ${spaceship.level}'),
                      Text('Cost: ${spaceship.cost}'),
                      Consumer<PlayerData>(
                        builder: (context, playerData, child) {
                          final type =
                              Spaceship.spaceships.entries.elementAt(index).key;
                          final isEquipped = playerData.isEquipped(type);
                          final isOwned = playerData.isOwned(type);
                          final canBuy = playerData.canBuy(type);

                          return ElevatedButton(
                            onPressed: isEquipped
                                ? null
                                : () {
                                    if (isOwned) {
                                      playerData.equip(type);
                                    } else {
                                      if (canBuy) {
                                        playerData.buy(type);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.red,
                                              title: const Text(
                                                'Insufficient Balance',
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                'Need ${spaceship.cost - playerData.money} more',
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                            child: Text(
                              isEquipped
                                  ? 'Equipped'
                                  : isOwned
                                      ? 'Select'
                                      : 'Buy',
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GamePlay(),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainMenu(),
                    ),
                  );
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
