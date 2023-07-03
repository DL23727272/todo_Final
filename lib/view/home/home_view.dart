// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

///
import '../../main.dart';
import '../../models/task.dart';
import '../../utils/colors.dart';
import '../../utils/constanst.dart';
import '../../view/home/widgets/task_widget.dart';
import '../../view/tasks/task_view.dart';
import '../../utils/strings.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// Sort Task List
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

          return Scaffold(
            backgroundColor: Colors.white,

            /// Floating Action Button
            floatingActionButton: const FAB(),

            /// Body
            body: SliderDrawer(
              isDraggable: false,
              key: dKey,
              animationDuration: 1000,

              /// My AppBar
              appBar: MyAppBar(
                drawerKey: dKey,
              ),

              /// My Drawer Slider
              slider: MySlider(),

              /// Main Body
              child: _buildBody(
                tasks,
                base,
                textTheme,
              ),
            ),
          );
        });
  }

  /// Main Body
SizedBox _buildBody(
  List<Task> tasks,
  BaseWidget base,
  TextTheme textTheme,
) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      children: [
        Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
          width: double.infinity,
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MyColors.primaryColor),
                  backgroundColor: Colors.grey,
                  value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(MyString.mainTitle, style: textTheme.displayLarge),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${checkDoneTask(tasks)} of ${tasks.length} task",
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Divider(
            thickness: 2,
            indent: 100,
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 585,
          child: tasks.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    var task = tasks[index];

                    return Dismissible(
                      direction: DismissDirection.horizontal,
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            MyString.deletedTask,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      onDismissed: (direction) {
                        base.dataStore.dalateTask(task: task);
                      },
                      key: Key(task.id),
                      child: TaskWidget(
                        task: tasks[index],
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeIn(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(
                          lottieURL,
                          animate: tasks.isNotEmpty ? false : true,
                        ),
                      ),
                    ),
                    FadeInUp(
                      from: 30,
                      child: Text(MyString.doneAllTask),
                    ),
                  ],
                ),
        ),
      ],
    ),
  );
}
}

/// My Drawer Slider
class MySlider extends StatelessWidget {
  MySlider({
    Key? key,
  }) : super(key: key);

  /// Images
  List<String> images = [
    'assets/img/angela.jpg',
    'assets/img/main.jpg',
    'assets/img/frio.jpg',
    'assets/img/topher.jpg',
    'assets/img/main.jpg'
  ];

  /// Texts
  List<String> texts = [
    "Angela",
    "Benjie",
    "Frio",
    "Christopher",
    "Kim"
  ];

@override
Widget build(BuildContext context) {
  var textTheme = Theme.of(context).textTheme;
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 50),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: MyColors.primaryGradientColor,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/img/main.jpg',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text("DL", style: textTheme.displayMedium),
        Text("BSIT Students", style: textTheme.displaySmall),
        Text("\nMembers", style: textTheme.displaySmall),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 10,
          ),
          width: double.infinity,
          height: 300,
          child: SingleChildScrollView(
            child: ListView.builder(
              itemCount: images.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          images[i],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        texts[i],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}
}

/// My App Bar
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    required this.drawerKey,
  }) : super(key: key);

  final GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}


class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// toggle for drawer and icon animation
  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
        width: double.infinity,
        height: 132,
        child: Container(
          color: Colors.red, // Set the desired background color here
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20), // Add the desired top padding here
            child: AppBar(
              backgroundColor: Colors.red, // Set the desired app bar color here
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: controller,
                  size: 40,
                ),
                onPressed: toggle,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    base.isEmpty
                        ? warningNoTask(context)
                        : deleteAllTask(context);
                  },
                  child: const Icon(
                    CupertinoIcons.trash,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ));
  }
}

/// Floating Action Button
class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 10,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
              child: Icon(
            Icons.add,
            color: Colors.white,
          )),
        ),
      ),
    );
  }
}
