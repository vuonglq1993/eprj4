import 'package:flutter/material.dart';
import '../../models/topic_model.dart';
import '../../services/topic_service.dart';
import 'topic_courses_page.dart';

class TopicsPage extends StatefulWidget {
  final VoidCallback? onBack;

  const TopicsPage({super.key, this.onBack});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  bool isLoading = true;
  String? error;
  List<TopicModel> topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await TopicService.getTopics();
      if (!mounted) return;
      setState(() {
        topics = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _openTopic(TopicModel topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopicCoursesPage(
          topicId: topic.id,
          topicName: topic.name,
        ),
      ),
    );
  }

  Widget _buildTopicIcon(TopicModel topic) {
    final icon = topic.iconUrl?.trim();

    if (icon != null && icon.isNotEmpty) {
      final isNetworkImage = icon.startsWith("http://") || icon.startsWith("https://");

      if (isNetworkImage) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            icon,
            width: 46,
            height: 46,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallbackTopicIcon(topic),
          ),
        );
      }

      if (icon.runes.length <= 4) {
        return Text(
          icon,
          style: const TextStyle(fontSize: 30),
        );
      }
    }

    return _fallbackTopicIcon(topic);
  }

  Widget _fallbackTopicIcon(TopicModel topic) {
    IconData iconData = Icons.topic;

    final lower = topic.name.toLowerCase();
    if (lower.contains("grammar")) iconData = Icons.spellcheck;
    if (lower.contains("vocabulary")) iconData = Icons.menu_book;
    if (lower.contains("listening")) iconData = Icons.headphones;
    if (lower.contains("travel")) iconData = Icons.flight;
    if (lower.contains("food")) iconData = Icons.restaurant;
    if (lower.contains("business")) iconData = Icons.business_center;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF5F2EFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: const Color(0xFF5F2EFF),
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: widget.onBack ?? () => Navigator.pop(context),
        ),
        title: const Text(
          "All Topics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(error!, textAlign: TextAlign.center),
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadTopics,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final topic = topics[index];

            return GestureDetector(
              onTap: () => _openTopic(topic),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopicIcon(topic),
                    const Spacer(),
                    Text(
                      topic.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      topic.description ?? "Khám phá chủ đề này",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${topic.totalCourses} courses",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5F2EFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}