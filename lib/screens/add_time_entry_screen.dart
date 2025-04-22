import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../provider/time_entry_provider.dart';
import '../provider/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedProjectId; // Utilise nullable pour la valeur initiale
  String? _selectedTaskId;   // Utilise nullable pour la valeur initiale
  double _totalTime = 0.0;
  DateTime _selectedDate = DateTime.now();
  String _notes = '';

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(); // Pour l'affichage

   @override
   void initState() {
     super.initState();
     _updateDateText(); // Met à jour le texte initial de la date
      // Pré-sélectionner le premier projet/tâche si disponible
      final projectProvider = Provider.of<ProjectTaskProvider>(context, listen: false);
      if (projectProvider.projects.isNotEmpty) {
        _selectedProjectId = projectProvider.projects.first.id;
      }
      if (projectProvider.tasks.isNotEmpty) {
        _selectedTaskId = projectProvider.tasks.first.id;
      }
   }

   @override
    void dispose() {
      _dateController.dispose();
      _timeController.dispose();
      super.dispose();
    }

  void _updateDateText() {
     _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

   Future<void> _selectDate(BuildContext context) async {
     final DateTime? picked = await showDatePicker(
       context: context,
       initialDate: _selectedDate,
       firstDate: DateTime(2000),
       lastDate: DateTime(2101),
     );
     if (picked != null && picked != _selectedDate) {
       setState(() {
         _selectedDate = picked;
         _updateDateText();
       });
     }
   }


  @override
  Widget build(BuildContext context) {
    // Accès aux providers
    final projectProvider = Provider.of<ProjectTaskProvider>(context);
    final timeProvider = Provider.of<TimeEntryProvider>(context, listen: false); // Pas besoin d'écouter ici

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: SingleChildScrollView( // Permet le défilement si le contenu dépasse
         padding: const EdgeInsets.all(16.0),
         child: Form(
           key: _formKey,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les boutons
             children: <Widget>[
               // Dropdown pour les Projets
               DropdownButtonFormField<String>(
                 value: _selectedProjectId, // Peut être null initialement
                 onChanged: (String? newValue) {
                   setState(() {
                     _selectedProjectId = newValue;
                   });
                 },
                 decoration: InputDecoration(labelText: 'Project'),
                  items: projectProvider.projects
                      .map<DropdownMenuItem<String>>((Project project) {
                    return DropdownMenuItem<String>(
                      value: project.id,
                      child: Text(project.name),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Please select a project' : null,
                ),

                SizedBox(height: 16), // Espace

                // Dropdown pour les Tâches
                DropdownButtonFormField<String>(
                  value: _selectedTaskId, // Peut être null initialement
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTaskId = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Task'),
                  items: projectProvider.tasks
                      .map<DropdownMenuItem<String>>((Task task) {
                    return DropdownMenuItem<String>(
                      value: task.id,
                      child: Text(task.name),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Please select a task' : null,
                ),

                 SizedBox(height: 16),

                // Champ pour la Date avec sélecteur
                TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                    ),
                    ),
                    readOnly: true, // Empêche la saisie manuelle
                    onTap: () => _selectDate(context), // Ouvre aussi au tap
                ),


                SizedBox(height: 16),

                // Champ pour le Temps Total
                TextFormField(
                  //controller: _timeController, // On ne l'utilise pas pour la sauvegarde
                  decoration: InputDecoration(labelText: 'Total Time (in hours)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total time';
                    }
                    final number = double.tryParse(value);
                    if (number == null) {
                      return 'Please enter a valid number';
                    }
                    if (number <= 0) {
                       return 'Time must be positive';
                    }
                    return null; // Valide
                  },
                  onSaved: (value) => _totalTime = double.parse(value!),
                ),

                SizedBox(height: 16),

                // Champ pour les Notes
                TextFormField(
                  decoration: InputDecoration(labelText: 'Notes (optional)'),
                   maxLines: 3, // Permet plusieurs lignes
                  onSaved: (value) => _notes = value ?? '', // Gère la valeur nulle
                  // Pas de validateur car optionnel
                ),

                SizedBox(height: 24), // Plus d'espace avant le bouton

                // Bouton Sauvegarder
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Appelle onSaved pour chaque champ

                       // Vérification finale (au cas où les listes seraient vides après chargement)
                       if (_selectedProjectId == null || _selectedTaskId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please ensure Project and Task are selected.')),
                          );
                          return;
                       }

                      // Création de la nouvelle entrée
                      final newEntry = TimeEntry(
                        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unique simple
                        projectId: _selectedProjectId!, // On sait qu'ils ne sont pas nuls ici
                        taskId: _selectedTaskId!,
                        totalTime: _totalTime,
                        date: _selectedDate,
                        notes: _notes,
                      );

                      // Ajout via le provider
                      timeProvider.addTimeEntry(newEntry);

                      // Retour à l'écran précédent
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Entry'),
                ),
              ],
           ),
         ),
       ),
    );
  }
}