import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../provider/project_task_provider.dart';
import '../provider/time_entry_provider.dart';
import '../dialogs/confirm_delete_dialog.dart'; // Importer le dialogue de confirmation

class TimeEntryListItem extends StatelessWidget {
  final TimeEntry entry;

  const TimeEntryListItem({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Utilise listen: false car on n'a besoin des noms qu'une fois
    final projectProvider = Provider.of<ProjectTaskProvider>(context, listen: false);
    final projectName = projectProvider.getProjectNameById(entry.projectId);
    final taskName = projectProvider.getTaskNameById(entry.taskId);
    final formattedDate = DateFormat('MMM d, yyyy').format(entry.date);

    return Dismissible(
      key: Key(entry.id), // Clé unique pour Dismissible
      direction: DismissDirection.endToStart, // Glisser de droite à gauche
      onDismissed: (direction) async {
         // Afficher la confirmation AVANT de supprimer
         final confirm = await showConfirmDeleteDialog(
            context,
            itemName: '$projectName - $taskName'
         ) ?? false; // Retourne false si null (dialogue fermé sans choix)

         if (confirm) {
             Provider.of<TimeEntryProvider>(context, listen: false)
                 .deleteTimeEntry(entry.id);
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Entry deleted')),
             );
         } else {
            // Important : Si l'utilisateur annule, il faut redessiner pour
            // remettre l'élément à sa place. On notifie les listeners.
            // Cela force une reconstruction de la liste parente.
            Provider.of<TimeEntryProvider>(context, listen: false).notifyListeners();
         }
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete_sweep,
          color: Colors.white,
        ),
      ),
      child: Card( // Utilisation de Card pour un meilleur visuel
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text('$projectName - $taskName', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Time: ${entry.totalTime} hours'),
              Text('Date: $formattedDate'),
              if (entry.notes.isNotEmpty) Text('Note: ${entry.notes}'),
            ],
          ),
          // L'icône rouge est maintenant gérée par Dismissible
          // trailing: IconButton( // Alternative si on ne veut pas Dismissible
          //   icon: Icon(Icons.delete, color: Colors.red),
          //   onPressed: () async { /* Logique de suppression avec confirmation ici */ },
          // ),
          // onTap: () {
          //   // Potentiellement naviguer vers un écran de détails/modification
          // },
        ),
      ),
    );
  }
}