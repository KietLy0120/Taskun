import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> handleBuyItem(BuildContext context, String itemType, String docId, int price, {VoidCallback? onPurchaseSuccess}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final userDoc = await userRef.get();
  final userData = userDoc.data() ?? {};

  final itemSnapshot = await FirebaseFirestore.instance.collection('items').doc(docId).get();
  final name = itemSnapshot.data()?['name'] ?? 'Unknown Item';

  int currentCoins = userData['coins'] ?? 0;
  List<String> inventoryList = List<String>.from(userData['inventory']?[itemType] ?? []);

  if (inventoryList.contains(name)) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Already Owned'),
        content: const Text('You already own this item.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
    return;
  }

  if (currentCoins < price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Not Enough Coins'),
        content: const Text('You do not have enough coins to purchase this item.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
    return;
  }

  inventoryList.add(name);

  await userRef.set({
    'coins': currentCoins - price,
    'inventory': {
      itemType: inventoryList,
    }
  }, SetOptions(merge: true));

  if (onPurchaseSuccess != null) {
    onPurchaseSuccess();
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Purchase Successful'),
      content: Text('You have purchased the $name!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        )
      ],
    ),
  );
}
