import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stayzio_app/features/auth/data/model/user.dart';
import 'package:stayzio_app/features/message/data/model/message.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

// Helper to format timestamps
class TimeHelper {
  static String formatChatTime(String isoString) {
    final datetime = DateTime.parse(isoString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(datetime.year, datetime.month, datetime.day);

    if (dateToCheck == today) {
      return "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else {
      return "${datetime.day}/${datetime.month}/${datetime.year}";
    }
  }
}

class _MessageScreenState extends State<MessageScreen> {
  // Current user
  final User currentUser = User(
    id: 999,
    fullName: 'Ahmir Thompson',
    email: 'ahmir@example.com',
    password: 'securePassword',
    username: 'ahmir',
    profileImage: 'assets/profile.png',
  );

  // Sample users for the conversation list
  final List<User> chatUsers = [
    User(
      id: 1,
      fullName: 'Miss Dolores Schowalter',
      email: 'dolores@example.com',
      password: 'password123',
      profileImage: 'assets/images/john.png',
      username: 'dolores',
    ),
    User(
      id: 2,
      fullName: 'Lorena Farrell',
      email: 'lorena@example.com',
      password: 'password123',
      profileImage: 'assets/images/john.png',
      username: 'lorena',
    ),
    User(
      id: 3,
      fullName: 'Amos Hessel',
      email: 'amos@example.com',
      password: 'password123',
      profileImage: 'assets/images/john.png',
      username: 'amos',
    ),
    User(
      id: 4,
      fullName: 'Ollie Haley',
      email: 'ollie@example.com',
      password: 'password123',
      profileImage: 'assets/images/john.png',
      username: 'ollie',
    ),
    User(
      id: 5,
      fullName: 'Traci Maggio',
      email: 'traci@example.com',
      password: 'password123',
      profileImage: 'assets/images/john.png',
      username: 'traci',
    ),
    User(
      id: 6,
      fullName: 'Mathew Konopelski',
      email: 'mathew@example.com',
      password: 'password123',
      profileImage: 'assets/images/john.png',
      username: 'mathew',
    ),
  ];

  // Keep track of which users are online
  final Set<int> onlineUserIds = {1, 3, 5};

  // Sample last messages
  final Map<int, Message> lastMessages = {
    1: Message(
      id: 101,
      senderId: 1,
      receiverId: 999, // Current user's ID
      messageText: 'Thank you!',
      isRead: 0,
      sentAt: DateTime.now()
          .subtract(const Duration(hours: 2, minutes: 12))
          .toIso8601String(),
    ),
    2: Message(
      id: 102,
      senderId: 2,
      receiverId: 999,
      messageText: 'Yes! please take a order',
      isRead: 1,
      sentAt: DateTime.now()
          .subtract(const Duration(hours: 9, minutes: 28))
          .toIso8601String(),
    ),
    3: Message(
      id: 103,
      senderId: 3,
      receiverId: 999,
      messageText: 'I think this one is good',
      isRead: 1,
      sentAt: DateTime.now()
          .subtract(const Duration(hours: 4, minutes: 35))
          .toIso8601String(),
    ),
    4: Message(
      id: 104,
      senderId: 4,
      receiverId: 999,
      messageText: 'Wow, this is really epic',
      isRead: 1,
      sentAt: DateTime.now()
          .subtract(const Duration(hours: 8, minutes: 12))
          .toIso8601String(),
    ),
    5: Message(
      id: 105,
      senderId: 5,
      receiverId: 999,
      messageText: 'omg, this is amazing',
      isRead: 1,
      sentAt: DateTime.now()
          .subtract(const Duration(hours: 10, minutes: 22))
          .toIso8601String(),
    ),
    6: Message(
      id: 106,
      senderId: 6,
      receiverId: 999,
      messageText: 'woohoooo',
      isRead: 1,
      sentAt:
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    ),
  };

  // Unread message counts
  final Map<int, int> unreadCounts = {
    1: 3,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Message',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Message List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: chatUsers.length,
                itemBuilder: (context, index) {
                  final user = chatUsers[index];
                  final lastMessage = lastMessages[user.id!]!;
                  final unreadCount = unreadCounts[user.id!] ?? 0;
                  final formattedTime =
                      TimeHelper.formatChatTime(lastMessage.sentAt);
                  final isOnline = onlineUserIds.contains(user.id);

                  return MessageListItem(
                    user: user,
                    lastMessage: lastMessage,
                    formattedTime: formattedTime,
                    unreadCount: unreadCount,
                    isOnline: isOnline,
                    onTap: () {
                      context.router.push(
                        ChatRoute(
                          user: user,
                          currentUser: currentUser,
                          isOnline: isOnline,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Message List Item
class MessageListItem extends StatelessWidget {
  final User user;
  final Message lastMessage;
  final String formattedTime;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback onTap;

  const MessageListItem({
    super.key,
    required this.user,
    required this.lastMessage,
    required this.formattedTime,
    required this.unreadCount,
    required this.isOnline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // johnwith online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: user.profileImage != null
                      ? AssetImage(user.profileImage!)
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: user.profileImage == null
                      ? Text(
                          user.fullName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Message info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage.messageText,
                    style: TextStyle(
                      color:
                          lastMessage.isRead == 0 ? Colors.black : Colors.grey,
                      fontWeight: lastMessage.isRead == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Time and unread count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedTime,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
