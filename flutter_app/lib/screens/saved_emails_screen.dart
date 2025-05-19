import 'package:flutter/material.dart';
import '/local_database.dart';

class SavedEmailsScreen extends StatefulWidget {
  const SavedEmailsScreen({super.key});

  @override
  State<SavedEmailsScreen> createState() => _SavedEmailsScreenState();
}

class _SavedEmailsScreenState extends State<SavedEmailsScreen> {
  late Future<List<String>> _emailsFuture;

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  void _loadEmails() {
    setState(() {
      _emailsFuture = LocalDatabase.getAllEmails();
    });
  }

  void _deleteEmail(String email) async {
    await LocalDatabase.deleteEmail(email);
    _loadEmails(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Emails"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<String>>(
        future: _emailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No emails saved yet."));
          }

          final emails = snapshot.data!;
          return ListView.builder(
            itemCount: emails.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.email, color: Colors.black),
              title: Text(emails[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteEmail(emails[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
