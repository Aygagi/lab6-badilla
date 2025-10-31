import 'package:flutter/material.dart';

void main() {
  runApp(const TeamCollabApp());
}

class TeamCollabApp extends StatelessWidget {
  const TeamCollabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team Task Collaboration',
      home: TaskHome(),
    );
  }
}

// ==========================================================
// SECTION 1 — UI Layout & Navigation (Handled by Member #1)
// ==========================================================
class TaskHome extends StatefulWidget {
  const TaskHome({super.key});

  @override
  State<TaskHome> createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  final List<Map<String, dynamic>> _tasks = []; // shared team data

  void _addTask(String title, String desc) {
    setState(() {
      _tasks.add({'title': title, 'desc': desc, 'done': false});
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 Team Task Board'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Add one below!'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return TaskCard(
            title: task['title'],
            desc: task['desc'],
            done: task['done'],
            onToggle: () => _toggleTask(index),
            onDelete: () => _deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => TaskDialog(onAdd: _addTask),
        ),
      ),
    );
  }
}

// ==========================================================
// SECTION 2 — Task Card Widget (Handled by Member #2)
// ==========================================================
class TaskCard extends StatelessWidget {
  final String title;
  final String desc;
  final bool done;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.desc,
    required this.done,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(
          done ? Icons.check_circle : Icons.circle_outlined,
          color: done ? Colors.green : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: done ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(desc),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
        ),
        onTap: onToggle,
      ),
    );
  }
}

// ==========================================================
// SECTION 3 — Add Task Dialog (Handled by Member #3)
// ==========================================================
class TaskDialog extends StatefulWidget {
  final Function(String, String) onAdd;

  const TaskDialog({super.key, required this.onAdd});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text.trim();
            final desc = _descController.text.trim();
            if (title.isNotEmpty) {
              widget.onAdd(title, desc);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// ==========================================================
// SECTION 4 — Future Features Placeholder (Handled by Member #4)
// ==========================================================
// 💡 HINT: Add features like:
// - Sorting tasks by name or status
// - Filtering completed / incomplete tasks
// - Search bar for task lookup
// - Due dates and deadlines
// ==========================================================


// ==========================================================
// SECTION 5 — Backend / Sync Layer (Handled by Member #5)
// ==========================================================
// 💡 HINT: Implement data persistence or real-time collaboration:
// - Use Firebase Firestore for shared team tasks
// - Save locally using SharedPreferences or Hive
// - Enable live update when a member adds or edits a task
// ==========================================================
