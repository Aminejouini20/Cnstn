import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController searchCtrl = TextEditingController();

  List<UserModel> allUsers = [];
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        /// 🔍 SEARCH BAR – Samsung style
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchCtrl,
            onChanged: (v) => setState(() => search = v.trim()),
            decoration: InputDecoration(
              hintText: "Search by name or email",
              hintStyle: const TextStyle(color: Colors.blueAccent),
              prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 1.2),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// 👥 USERS LIST
        Expanded(
          child: StreamBuilder<List<UserModel>>(
            stream: _firestore.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading users"));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              /// ✅ stock once
              allUsers = snapshot.data!;

              /// 🔍 local filtering (NO stream reload)
              final filteredUsers = allUsers.where((u) {
                final s = search.toLowerCase();
                return u.name.toLowerCase().contains(s) ||
                    u.email.toLowerCase().contains(s);
              }).toList();

              if (filteredUsers.isEmpty) {
                return const Center(child: Text("No users found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                      /// 👤 Avatar
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade50,
                        backgroundImage: user.profileImage.isNotEmpty
                            ? NetworkImage(user.profileImage)
                            : null,
                        child: user.profileImage.isEmpty
                            ? const Icon(Icons.person, color: Colors.blueAccent)
                            : null,
                      ),

                      /// 📛 Name + Email
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      /// ⚙️ Actions
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              // TODO: edit user
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              await _firestore.deleteUser(user.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
