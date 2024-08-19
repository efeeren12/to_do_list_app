import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/data/local_storage.dart';
import 'package:to_do_list_app/models/task_model.dart';
import 'package:to_do_list_app/pages/home_page.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  for (var task in taskBox.values) {
    if (task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task.id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await setupHive(); // Hive'i sadece burada başlatıyoruz
  setup();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations', 
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const HomePage(),
    );
  }
}