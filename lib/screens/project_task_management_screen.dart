import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../provider/project_task_provider.dart';
import '../dialogs/add_edit_dialog.dart'; // Utilise le dialogue générique
import '../dialogs/confirm_delete_dialog.dart'; // Utilise le dialogue de confirmation
import '../widgets/empty_state_widget.dart'; // Widget pour état vide

class ProjectTaskManagementScreen extends StatelessWidget {
  const ProjectTaskManagementScreen({Key? key}) : super(key: key);

   // Fonction pour afficher le dialogue d'ajout de projet
  void _addProject(BuildContext context, ProjectTaskProvider provider) async {
    final name = await showAddEditDialog(
      context,
      title: 'Add New Project',
      label: 'Project Name',
    );
    if (name != null && name.isNotEmpty) {
      final newProject = Project(
        id: 'proj_${DateTime.now().millisecondsSinceEpoch}', // ID unique
        name: name,
      );
      provider.addProject(newProject);
    }
  }

  // Fonction pour afficher le dialogue d'ajout de tâche
  void _addTask(BuildContext context, ProjectTaskProvider provider) async {
    final name = await showAddEditDialog(
      context,
      title: 'Add New Task',
      label: 'Task Name',
    );
    if (name != null && name.isNotEmpty) {
       final newTask = Task(
         id: 'task_${DateTime.now().millisecondsSinceEpoch}', // ID unique
         name: name,
       );
       provider.addTask(newTask);
     }
  }

   // Fonction pour supprimer un projet (avec confirmation)
   void _deleteProject(BuildContext context, ProjectTaskProvider provider, Project project) async {
      final confirm = await showConfirmDeleteDialog(context, itemName: project.name) ?? false;
      if (confirm) {
         provider.deleteProject(project.id);
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Project "${project.name}" deleted')),
          );
          // TODO: Informer l'utilisateur si des TimeEntries associées existent ?
      }
   }

   // Fonction pour supprimer une tâche (avec confirmation)
   void _deleteTask(BuildContext context, ProjectTaskProvider provider, Task task) async {
      final confirm = await showConfirmDeleteDialog(context, itemName: task.name) ?? false;
      if (confirm) {
         provider.deleteTask(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Task "${task.name}" deleted')),
          );
         // TODO: Informer l'utilisateur si des TimeEntries associées existent ?
      }
   }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects & Tasks'),
         actions: [ // Bouton pour ajouter un projet dans l'AppBar
            IconButton(
               icon: Icon(Icons.playlist_add),
               tooltip: 'Add Project',
               onPressed: () => _addProject(context, provider),
            ),
         ],
      ),
      body: ListView( // Utilise ListView pour pouvoir scroller si les listes sont longues
         padding: const EdgeInsets.all(8.0),
         children: [
           // Section Projets
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 8.0),
             child: Text('Projects', style: Theme.of(context).textTheme.titleLarge),
           ),
           if (provider.projects.isEmpty)
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: EmptyStateWidget(icon: Icons.folder_off_outlined, message: 'No projects yet.', suggestion: 'Add projects using the + icon above.'),
             )
           else
             ListView.builder(
               shrinkWrap: true, // Important dans un ListView parent
               physics: NeverScrollableScrollPhysics(), // Désactive le scroll interne
               itemCount: provider.projects.length,
               itemBuilder: (context, index) {
                 final project = provider.projects[index];
                 return Card(
                   child: ListTile(
                     title: Text(project.name),
                     trailing: IconButton(
                       icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                       tooltip: 'Delete Project',
                       onPressed: () => _deleteProject(context, provider, project),
                     ),
                     // onTap: () { /* Peut-être pour éditer ? */ },
                   ),
                 );
               },
             ),

           SizedBox(height: 24), // Espace entre les sections

           // Section Tâches
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 8.0),
             child: Text('Tasks', style: Theme.of(context).textTheme.headlineLarge),
           ),
           if (provider.tasks.isEmpty)
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: EmptyStateWidget(icon: Icons.task_alt_outlined, message: 'No tasks yet.', suggestion: 'Add tasks using the + button below.'),
             )
           else
             ListView.builder(
               shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
               itemCount: provider.tasks.length,
               itemBuilder: (context, index) {
                 final task = provider.tasks[index];
                 return Card(
                   child: ListTile(
                     title: Text(task.name),
                     trailing: IconButton(
                       icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                       tooltip: 'Delete Task',
                        onPressed: () => _deleteTask(context, provider, task),
                     ),
                     // onTap: () { /* Peut-être pour éditer ? */ },
                   ),
                 );
               },
             ),
         ],
      ),
       floatingActionButton: FloatingActionButton( // FAB pour ajouter une tâche (comme screenshot task-add)
         onPressed: () => _addTask(context, provider),
         child: Icon(Icons.add_task),
         tooltip: 'Add Task',
         backgroundColor: Colors.amber, // Cohérence avec l'autre FAB
       ),
    );
  }
}