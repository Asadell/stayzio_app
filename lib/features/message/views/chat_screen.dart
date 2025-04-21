import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stayzio_app/features/auth/data/model/user.dart';
import 'package:stayzio_app/features/booking/data/model/booking.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/features/message/data/model/message.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  final User user;
  final User currentUser;
  final bool isOnline;

  const ChatScreen({
    super.key,
    required this.user,
    required this.currentUser,
    required this.isOnline,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

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

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Sample hotel data
  final Hotel hotel = Hotel(
    id: 123,
    name: 'The Aston Vill Hotel',
    location: 'Veum Point, Michkatoton',
    rating: 4.7,
    pricePerNight: 120,
    imageUrl: 'assets/images/default_hotel.jpg',
  );

  // Sample booking data related to the conversation
  late Booking booking;

  // Sample messages for chat
  late List<Message> messages;

  @override
  void initState() {
    super.initState();

    // Initialize booking data
    booking = Booking(
      id: 1001,
      userId: widget.currentUser.id!,
      hotelId: hotel.id!,
      checkInDate:
          DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      checkOutDate:
          DateTime.now().add(const Duration(days: 33)).toIso8601String(),
      guests: 2,
      roomType: 'King Sweet',
      totalPrice: 390.0,
      cleaningFee: 30.0,
      serviceFee: 20.0,
      adminFee: 10.0,
      status: 'pending',
      createdAt: DateTime.now().toIso8601String(),
    );

    // Initialize with sample messages
    messages = [
      Message(
        id: 201,
        senderId: widget.currentUser.id!,
        receiverId: widget.user.id!,
        messageText:
            'hi for this hotel with a king sweet room are there still any vacancies?',
        isRead: 1,
        sentAt: DateTime.now()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
      ),
      Message(
        id: 202,
        senderId: widget.user.id!,
        receiverId: widget.currentUser.id!,
        messageText: 'Hi Ahmir',
        isRead: 1,
        sentAt: DateTime.now()
            .subtract(const Duration(minutes: 4))
            .toIso8601String(),
      ),
      Message(
        id: 203,
        senderId: widget.user.id!,
        receiverId: widget.currentUser.id!,
        messageText: 'Yes the room is available, so you can make an order.',
        isRead: 1,
        sentAt: DateTime.now()
            .subtract(const Duration(minutes: 3))
            .toIso8601String(),
      ),
    ];
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      id: messages.length + 204,
      senderId: widget.currentUser.id!,
      receiverId: widget.user.id!,
      messageText: text,
    );

    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Chat App Bar
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // User Profile
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: widget.user.profileImage != null
                        ? AssetImage(widget.user.profileImage!)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: widget.user.profileImage == null
                        ? Text(
                            widget.user.fullName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: widget.isOnline ? Colors.blue : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Hotel Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        hotel.imageUrl ?? 'assets/images/default_hotel.jpg',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                hotel.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      hotel.rating.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                hotel.location,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${hotel.pricePerNight.toInt()} /night',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Chat Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                reverse: false,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message.senderId == widget.currentUser.id!;
                  final time = TimeHelper.formatChatTime(message.sentAt);

                  return Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message.messageText,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          time,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Message Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Write a reply',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
