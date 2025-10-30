import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

enum FilterType { all, done, undone }

class _TodoHomePageState extends State<TodoHomePage> {
  static const String _storageKey = 'todo_items';
  List<TodoTask> _tasks = [];
  SharedPreferences? _prefs;
  bool _isLoading = true;
  FilterType _filter = FilterType.all;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    final data = _prefs!.getString(_storageKey);
    if (data != null) {
      final List decoded = jsonDecode(data);
      _tasks = decoded.map((e) => TodoTask.fromMap(e)).toList();
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveTasks() async {
    final encoded = jsonEncode(_tasks.map((e) => e.toMap()).toList());
    await _prefs!.setString(_storageKey, encoded);
  }

  void _addTask(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final task = TodoTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: trimmed,
      isDone: false,
      createdAt: DateTime.now(),
    );
    setState(() => _tasks.insert(0, task));
    await _saveTasks();
  }

  void _toggleDone(TodoTask task) async {
    setState(() {
      task.isDone = !task.isDone;
    });
    await _saveTasks();
  }

  void _deleteTask(TodoTask task) async {
    setState(() => _tasks.remove(task));
    await _saveTasks();
  }

  void _editTask(TodoTask task, String newTitle) async {
    setState(() => task.title = newTitle.trim());
    await _saveTasks();
  }

  List<TodoTask> get _filteredTasks {
    switch (_filter) {
      case FilterType.done:
        return _tasks.where((t) => t.isDone).toList();
      case FilterType.undone:
        return _tasks.where((t) => !t.isDone).toList();
      default:
        return _tasks;
    }
  }

  void _showTaskSheet({TodoTask? editTask}) {
    _controller.text = editTask?.title ?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                editTask == null ? 'Add Task' : 'Edit Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter task...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (val) {
                  if (editTask == null) {
                    _addTask(val);
                  } else {
                    _editTask(editTask, val);
                  }
                  _controller.clear();
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  final val = _controller.text;
                  if (editTask == null) {
                    _addTask(val);
                  } else {
                    _editTask(editTask, val);
                  }
                  _controller.clear();
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.check),
                label: Text(editTask == null ? 'Add' : 'Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _tasks.where((t) => t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Tasks ✨', style: TextStyle(fontSize: 22)),
            Text(
              '${_tasks.length} total • $doneCount done',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          PopupMenuButton<FilterType>(
            icon: const Icon(Icons.filter_alt_rounded),
            initialValue: _filter,
            onSelected: (val) => setState(() => _filter = val),
            itemBuilder:
                (_) => const [
                  PopupMenuItem(value: FilterType.all, child: Text('Tất cả')),
                  PopupMenuItem(
                    value: FilterType.undone,
                    child: Text('Chưa xong'),
                  ),
                  PopupMenuItem(value: FilterType.done, child: Text('Đã xong')),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskSheet(),
        child: const Icon(Icons.add),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredTasks.isEmpty
              ? const Center(child: Text('Không có task nào 😌'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredTasks.length,
                itemBuilder: (context, i) {
                  final task = _filteredTasks[i];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors:
                            task.isDone
                                ? [Colors.teal.shade200, Colors.teal.shade100]
                                : [
                                  Colors.indigo.shade200,
                                  Colors.indigo.shade100,
                                ],
                      ),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => _toggleDone(task),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration:
                              task.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(task.createdAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () => _showTaskSheet(editTask: task),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteTask(task),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays < 1) return '${diff.inHours} giờ trước';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class TodoTask {
  String id;
  String title;
  bool isDone;
  DateTime createdAt;

  TodoTask({
    required this.id,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TodoTask.fromMap(Map<String, dynamic> map) => TodoTask(
    id: map['id'],
    title: map['title'],
    isDone: map['isDone'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
