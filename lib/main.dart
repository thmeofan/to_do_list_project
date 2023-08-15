import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list_project/class_repository/notification_service.dart';
import 'package:to_do_list_project/screens/add_todo_list_screen.dart';
import 'package:to_do_list_project/screens/edit_todo_list_screen.dart';
import 'package:to_do_list_project/screens/todo_list_screen.dart';

import 'bLoc/todo_list_bloc.dart';
import 'bLoc/todo_list_event.dart';
import 'constants/screens.dart';
import 'firebase_options.dart';
import 'models/todo_list_model.dart';

const String notesKeeperKey = 'notes_keeper';
const String notesListKey = 'notes_List_key';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final fcmToken = await _firebaseMessaging.getToken();
  final settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(NotificationService().backgroundMassageHandler);

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  print(
      '=================================================================================');
  print(fcmToken);
  print(
      '=================================================================================');
  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {})
      .onError((err) {});
  await FirebaseMessaging.instance.subscribeToTopic("newTaskNotification");
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // String? token = await messaging.getToken();
  //
  // if (kDebugMode) {
  //   print('Registration Token=$token');
  // }

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(ToDoModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ToDoListBloc())],
      child: FutureBuilder(
          future: Connectivity().checkConnectivity(),
          builder: (context, connectivityStatus) {
            if (connectivityStatus.hasData) {
              if (connectivityStatus.data != ConnectivityResult.none) {
                FirebaseFirestore.instance
                    .collection("todos")
                    .get()
                    .then((event) async {
                  var box = await Hive.openBox(notesKeeperKey);
                  List<ToDoModel> toDosList = [];
                  for (var doc in event.docs) {
                    ToDoModel newToDoNote = ToDoModel.fromJson(doc.data());
                    context
                        .read<ToDoListBloc>()
                        .add(SaveToDoEvent(newToDoNote));
                    toDosList.add(newToDoNote);
                  }
                  await box.put(notesListKey, toDosList);
                  await box.close();
                });
              } else {
                Hive.openBox(notesKeeperKey).then((box) {
                  if (box.isNotEmpty) {
                    List<ToDoModel> notesList =
                        box.get(notesListKey).cast<ToDoModel>();
                    if (notesList.isEmpty) {
                      context.read<ToDoListBloc>().add(EmptyListEvent());
                    } else {
                      for (int index = 0; index < notesList.length; index++) {
                        context
                            .read<ToDoListBloc>()
                            .add(SaveToDoEvent(notesList[index]));
                      }
                    }
                    box.close();
                  } else {
                    context.read<ToDoListBloc>().add(EmptyListEvent());
                  }
                });
              }
            }
            return MaterialApp(
              title: 'Flutter_Demo',
              theme: ThemeData(
                // primaryColor:Color.fromRGBO(137,152,120,1) ,
                backgroundColor: Color.fromRGBO(228, 230, 195, 1),
              ),
              routes: {
                Screens.toDoList: (context) => ToDoListsScreen(),
                Screens.createToDo: (context) => AddNoteScreen(),
                Screens.editToDo: (context) => EditNoteScreen()
              },
            );
          }),
    );
  }
}
