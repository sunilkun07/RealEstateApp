import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final List<Map<String, String>> _homes = [
    {
      "name": "Family House",
      "location": "Yangon, Shwe Taung kyar",
      "image": "https://www.gharsansarnepal.com/image/16568548311.png",
    },
    {
      "name": "Modern Villa",
      "location": "Yangon, Inya Road",
      "image":
          "https://www.fiscalnepal.com/wp-content/uploads/2020/10/Housing-Nepal.jpg",
    },
  ];

  final List<Map<String, String>> _bookmarks = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  void _addHomeDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Add Your Home"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Home Name"),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: "Location"),
                  ),
                  TextField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: "Image URL"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearControllers();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _homes.add({
                      "name": _nameController.text,
                      "location": _locationController.text,
                      "image": _imageUrlController.text,
                    });
                  });
                  Navigator.of(context).pop();
                  _clearControllers();
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _clearControllers() {
    _nameController.clear();
    _locationController.clear();
    _imageUrlController.clear();
  }

  void _toggleBookmark(Map<String, String> home) {
    setState(() {
      if (_bookmarks.contains(home)) {
        _bookmarks.remove(home);
      } else {
        _bookmarks.add(home);
      }
    });
  }

  Widget _homeCard(Map<String, String> home) {
    final isBookmarked = _bookmarks.contains(home);
    return Container(
      width: 230.0,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(home["image"]!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: () => _toggleBookmark(home),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    home["name"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        home["location"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const Text(
          "Discover Suitable Home",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 400,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _homes.map(_homeCard).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkScreen() {
    return _bookmarks.isEmpty
        ? const Center(child: Text("No bookmarks yet."))
        : ListView.builder(
          itemCount: _bookmarks.length,
          padding: const EdgeInsets.all(20),
          itemBuilder: (_, i) {
            final home = _bookmarks[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Image.network(home["image"]!, width: 60),
                title: Text(home["name"]!),
                subtitle: Text(home["location"]!),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _toggleBookmark(home),
                ),
              ),
            );
          },
        );
  }

  Widget _buildChatScreen() {
    return const Center(child: Text("Chat feature coming soon."));
  }

  Widget _buildProfileScreen() {
    return const Center(child: Text("Profile section coming soon."));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeScreen(),
      _buildBookmarkScreen(),
      _buildChatScreen(),
      _buildProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Real Estate App"),
        backgroundColor: Colors.blue,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      body: screens[currentIndex],
      floatingActionButton:
          currentIndex == 0
              ? FloatingActionButton(
                onPressed: _addHomeDialog,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: "Bookmarks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  
}

