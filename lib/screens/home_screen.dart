import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // Pour groupBy

import '../models/time_entry.dart';
import '../provider/time_entry_provider.dart';
import '../provider/project_task_provider.dart';
import '../screens/add_time_entry_screen.dart';
import 'project_task_management_screen.dart';
import '../widgets/time_entry_list_item.dart';
import '../widgets/empty_state_widget.dart'; // Importer le widget d'état vide

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Text('Time Tracking'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'Grouped by Projects'),
            ],
          ),
          // Ajout du menu burger implicite par le Drawer
        ),
        drawer: Drawer( // Ajout du Drawer pour la navigation
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Utilise la couleur primaire du thème
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.folder_rounded),
                title: Text('Manage Projects & Tasks'),
                onTap: () {
                  Navigator.pop(context); // Ferme le Drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectTaskManagementScreen()),
                  );
                },
              ),
              // Ajoutez d'autres éléments de menu ici si nécessaire
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllEntriesList(context),
            _buildGroupedEntriesList(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Time Entry',
          backgroundColor: Colors.amber, // Couleur jaune comme dans la capture
        ),
      ),
    );
  }

  // Widget pour l'onglet "All Entries"
  Widget _buildAllEntriesList(BuildContext context) {
    // Utilise Consumer pour réagir aux changements du provider
    return Consumer<TimeEntryProvider>(
      builder: (context, timeProvider, child) {
        if (timeProvider.entries.isEmpty) {
          return EmptyStateWidget(
             icon: Icons.hourglass_empty, // Icône comme dans la capture
             message: 'No time entries yet!',
             suggestion: 'Tap the + button to add your first entry.',
          );
        }
        // ListView pour afficher toutes les entrées
        return ListView.builder(
          itemCount: timeProvider.entries.length,
          itemBuilder: (context, index) {
            final entry = timeProvider.entries[index];
            return TimeEntryListItem(entry: entry); // Utilise le widget dédié
          },
        );
      },
    );
  }

  // Widget pour l'onglet "Grouped by Projects"
  Widget _buildGroupedEntriesList(BuildContext context) {
    // Utilise Consumer pour réagir aux changements des deux providers
    return Consumer2<TimeEntryProvider, ProjectTaskProvider>(
      builder: (context, timeProvider, projectProvider, child) {
        final groupedEntries = timeProvider.entriesByProject;

        if (groupedEntries.isEmpty) {
          return EmptyStateWidget(
             icon: Icons.hourglass_empty,
             message: 'No time entries yet!',
             suggestion: 'Add entries to see them grouped by project.',
          );
        }

        // Récupère la liste des IDs de projet triés par nom de projet
        final sortedProjectIds = groupedEntries.keys.toList()
          ..sort((idA, idB) {
             final nameA = projectProvider.getProjectNameById(idA);
             final nameB = projectProvider.getProjectNameById(idB);
             return nameA.compareTo(nameB);
          });

        // ListView pour afficher les groupes
        return ListView.builder(
          itemCount: sortedProjectIds.length,
          itemBuilder: (context, index) {
            final projectId = sortedProjectIds[index];
            final entriesForProject = groupedEntries[projectId]!;
            final projectName = projectProvider.getProjectNameById(projectId);

            // Trie les entrées dans chaque projet par date (la plus récente en premier)
            // Bien que déjà trié globalement, on s'assure ici si nécessaire
            entriesForProject.sort((a,b) => b.date.compareTo(a.date));

            // ExpansionTile pour chaque projet
            return ExpansionTile(
              title: Text(projectName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              initiallyExpanded: true, // Garde les tuiles ouvertes par défaut
              children: entriesForProject.map((entry) {
                final taskName = projectProvider.getTaskNameById(entry.taskId);
                final formattedDate = DateFormat('MMM d, yyyy').format(entry.date);
                // ListTile simple pour chaque entrée dans le groupe
                return ListTile(
                  title: Text('- $taskName: ${entry.totalTime} hours'),
                  subtitle: Text('  ($formattedDate)'), // Indentation pour la date
                  dense: true, // Rend l'élément un peu plus compact
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}