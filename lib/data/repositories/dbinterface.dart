import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoplist/data/models/shopping_item.dart';
import 'package:shoplist/data/models/shopping_list.dart';

class ListTypeManager {
  static final Map<String, IconData> iconMap = {
    'users': LucideIcons.users,
    'tent': LucideIcons.tent,
    'Drogerie': LucideIcons.flaskConical,
    'beer': LucideIcons.beer,
  };

  static IconData getIcon(String name) =>
      iconMap[name] ?? LucideIcons.helpCircle;
}

class CategoryManager {
  static final Map<String, IconData> categoryIcons = {
    'Lebensmittel': LucideIcons.utensils,
    'Drogerie': LucideIcons.flaskConical,
    'Getränke': LucideIcons.beer,
    'Snacks': LucideIcons.cookie,
    'Gemüse': LucideIcons.salad,
    'Fleisch': LucideIcons.drumstick,
  };

  static IconData getIcon(String category) =>
      categoryIcons[category] ?? LucideIcons.helpCircle;
}

/// DbInterface mit Hive + Firestore Sync
class DbInterface {
  final Box<ShoppingList> hiveBox;
  final FirebaseFirestore? firestore;
  final Box prefsBox;
  final Box<ShoppingItem> favoritesBox;

  DbInterface._({
    required this.hiveBox,
    required this.firestore,
    required this.prefsBox,
    required this.favoritesBox,
  }) {
    // Firestore → Sync mit Hive
    if (firestore != null) {
      firestore!
          .collection('shoppingLists')
          .where('env', isEqualTo: kReleaseMode ? 'prod' : 'dev')
          .snapshots()
          .listen((snapshot) {
        for (var doc in snapshot.docs) {
          var list = ShoppingList.fromMap(doc.data());
          hiveBox.put(list.name, list);
        }
      });
    }
  }

  /// Factory für FutureProvider
  static Future<DbInterface> create({
    required Box<ShoppingList> ShopListBox,
    required FirebaseFirestore firestore,
  }) async {
    final prefsBox = await Hive.openBox('prefs');
    final favoritesBox = await Hive.openBox<ShoppingItem>('favorites');
    return DbInterface._(
      hiveBox: ShopListBox,
      firestore: firestore,
      prefsBox: prefsBox,
      favoritesBox: favoritesBox,
    );
  }

  // --- Favoriten-Handling ---
  Future<List<ShoppingItem>> getFavorites() async =>
      favoritesBox.values.toList();

  Future<void> saveToFavorites(ShoppingItem item) async =>
      favoritesBox.put(item.name, item);

  Future<void> removeFromFavorites(String name) async =>
      favoritesBox.delete(name);

  // --- User-Handling ---
  Future<void> registerUser(String email, String password) async {
    final auth = FirebaseAuth.instance;
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;
    final collection = kReleaseMode ? 'users_prod' : 'users_dev';

    await firestore?.collection(collection).doc(uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    await prefsBox.put('userEmail', email);
    await prefsBox.put('isLoggedIn', true);
  }

  Future<void> loginUser(String email, String password) async {
    final auth = FirebaseAuth.instance;
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;
    final collection = kReleaseMode ? 'users_prod' : 'users_dev';

    await firestore?.collection(collection).doc(uid).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });

    await prefsBox.put('userEmail', email);
    await prefsBox.put('isLoggedIn', true);
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await prefsBox.clear();
  }

  // --- ShoppingLists ---
  Future<List<ShoppingList>> loadLists() async => hiveBox.values.toList();

  Future<void> saveList(ShoppingList list) async {
    await hiveBox.put(list.name, list);
    if (firestore != null) {
      final data = list.toMap();
      data['env'] = kReleaseMode ? 'prod' : 'dev';
      await firestore!.collection('shoppingLists').doc(list.name).set(data);
    }
  }

  Future<void> deleteList(String name) async {
    await hiveBox.delete(name);
    if (firestore != null) {
      await firestore!.collection('shoppingLists').doc(name).delete();
    }
  }
}
