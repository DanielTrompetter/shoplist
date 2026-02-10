import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoplist/core/theme/themes.dart';
import 'package:shoplist/data/repositories/dbinterface.dart';

// Screens
import 'package:shoplist/features/home/view/homescreen.dart';
import 'package:shoplist/features/info/view/infoscreen.dart';
import 'package:shoplist/features/shoplist/view/listscreen.dart';
import 'package:shoplist/features/shoplist/view/newlistscreen.dart';
import 'package:shoplist/features/shoplist/view/favlistscreen.dart';

// ✔ dbProvider initialisiert NUR DbInterface
final dbProvider = FutureProvider<DbInterface>((ref) async {
  return await DbInterface.create();
});

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbAsync = ref.watch(dbProvider);

    return dbAsync.when(
      data: (db) {
        return MaterialApp(
          title: 'ShopList',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,
          home: const HomeScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/listscreen': (context) => const ListScreen(),
            '/favscreen': (context) => const FavScreen(),
            '/newlist': (context) =>
                const NewListScreen(listName: '', iconName: ''),
            '/infos': (context) => const InfoScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Fehler beim Initialisieren: $err')),
        ),
      ),
    );
  }
}
