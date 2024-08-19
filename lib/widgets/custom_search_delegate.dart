import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/data/local_storage.dart';
import 'package:to_do_list_app/main.dart';
import 'package:to_do_list_app/models/task_model.dart';
import 'package:to_do_list_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks.where((currentTask) => currentTask.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.isNotEmpty ? ListView.builder(
              itemBuilder: (context, index) {
                var currentListItem = filteredList[index];
                return Dismissible(
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        const Text('remove_task').tr(),
                      ],
                    ),
                    key: Key(currentListItem.id),
                    onDismissed: (direction) async {
                      if (index < filteredList.length) {
                        filteredList.removeAt(index);
                        await locator<LocalStorage>().deleteTask(task: currentListItem);
                      }
                    },
                    child: TaskItem(task: currentListItem));
              },
              itemCount: filteredList.length,
            ) : Center(child: const Text('search_not_found').tr());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
