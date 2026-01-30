import 'package:flutter/material.dart';
import 'package:homecarecrm/screens/slide_drawer/chat_detail_page.dart';

class Message {
  final String name;
  final String message;
  final String time;
  final String image;
  final int unreadCount;

  Message({
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    required this.unreadCount,
  });
}

class MessageTile extends StatelessWidget {
  final Message message;

  const MessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatDetailPage(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(message.image),
            ),
            const SizedBox(width: 12),
            
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        message.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Unread Badge
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesPage extends StatefulWidget {
  MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Message> messages = [
    Message(
      name: 'Maddy Lin',
      message: "Hai Rizal, I'm on the way...",
      time: '3:74 Pm',
      image: 'https://picsum.photos/seed/maddy/200/200.jpg',
      unreadCount: 2,
    ),
    Message(
      name: 'Sarah Jen',
      message: 'woohoooo',
      time: '6:32 Pm',
      image: 'https://picsum.photos/seed/sarah/200/200.jpg',
      unreadCount: 2,
    ),
    Message(
      name: 'Ron Edward',
      message: "Haha that's terrifying 😂",
      time: '7:22 Pm',
      image: 'https://picsum.photos/seed/ron/200/200.jpg',
      unreadCount: 2,
    ),
    Message(
      name: 'Alice Adam',
      message: 'Wow, this is really epic',
      time: 'Yesterday',
      image: 'https://picsum.photos/seed/alice/200/200.jpg',
      unreadCount: 2,
    ),
    Message(
      name: 'Will Smith',
      message: 'Just ideas for next time',
      time: 'Yesterday',
      image: 'https://picsum.photos/seed/will/200/200.jpg',
      unreadCount: 2,
    ),
    Message(
      name: 'Jessica Ben',
      message: 'How are you?',
      time: 'Yesterday',
      image: 'https://picsum.photos/seed/jessica/200/200.jpg',
      unreadCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE91E63),
                    Color(0xFFF48FB1),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Messages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'serif',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                onTap: () {
                  setState(() {});
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                  hintText: 'Search Message',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            
            // Messages List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageTile(message: messages[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
