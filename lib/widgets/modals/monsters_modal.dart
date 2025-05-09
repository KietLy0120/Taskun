import 'package:flutter/material.dart';
import '../../models/monster.dart';

void showMonstersPopup(BuildContext context, Monster selectedMonster, void Function(Monster) onSelect) {
  PageController pageController = PageController(
    initialPage: monsters.indexOf(selectedMonster),
  );
  int selectedIndex = 0;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.blueGrey.shade800.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Select a Monster',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: monsters.length,
                      onPageChanged: (index) {
                        setState(() => selectedIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final monster = monsters[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(monster.imagePath, width: 150, height: 150),
                              const SizedBox(height: 10),
                              Text(
                                monster.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                monster.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade800.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.favorite, color: Colors.red),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.shade200,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: FractionallySizedBox(
                                                      alignment: Alignment.centerLeft,
                                                      widthFactor: monster.health / 600, // scale based on expected max health
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Health: ${monster.health}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.bolt, color: Colors.blue),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Container(
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.shade200,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: FractionallySizedBox(
                                                      alignment: Alignment.centerLeft,
                                                      widthFactor: monster.attack / 100, // scale based on expected max attack
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Attack: ${monster.attack}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onSelect(monsters[selectedIndex]);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Select"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}