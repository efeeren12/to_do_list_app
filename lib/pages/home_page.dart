import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_list_app/data/local_storage.dart';
import 'package:to_do_list_app/helper/translation_helper.dart';
import 'package:to_do_list_app/main.dart';
import 'package:to_do_list_app/models/task_model.dart';
import 'package:to_do_list_app/widgets/custom_search_delegate.dart';
import 'package:to_do_list_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks = [];
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTasksFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              _showAddTaskBottomSheet();
            },
            child: const Text('title').tr()),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var currentListItem = _allTasks[index];
                return Dismissible(
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        const Text('remove_task').tr()
                      ],
                    ),
                    key: Key(currentListItem.id),
                    onDismissed: (direction) {
                      if (index < _allTasks.length) {
                        var removedTask = _allTasks.removeAt(index);
                        _localStorage.deleteTask(task: removedTask);
                        setState(() {});
                      }
                    },
                    child: TaskItem(task: currentListItem));
              },
              itemCount: _allTasks.length,
            )
          : Center(
              child: const Text('empty_task_list').tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'add_task'.tr(),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context, showSecondsColumn: false,
                  locale: TranslationHelper.getDeviceLanguage(context),
                      onConfirm: (time) async {
                    var newTask = Task.create(name: value, createdAt: time);

                    _allTasks.insert(0, newTask);
                    await _localStorage.addTask(task: newTask);
                    setState(() {});
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _getAllTasksFromDb() async {
    _allTasks = await _localStorage.getAllTasks();
    setState(() {});
  }
  
  Future<void> _showSearchPage() async {
    await showSearch(context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTasksFromDb();

  }
}
