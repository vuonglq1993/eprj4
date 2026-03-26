import 'package:flutter/material.dart';
import '../homepage/homepagesetting/theme_notifier.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
    NotificationService.markAllRead();
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {

        final theme = Theme.of(context);
        final notifications = NotificationService.notifications;

        return Scaffold(

          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Notifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          body: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {

              final n = notifications[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          mode == ThemeMode.dark ? 0.3 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),

                child: Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5F2EFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFF5F2EFF),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            n.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            n.message,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      "${n.time.hour}:${n.time.minute}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}