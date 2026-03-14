import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Subscription",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: 20,
          ),
          child: Column(
            children: [

              const SizedBox(height: 10),

              /// ICON
              const Icon(
                Icons.workspace_premium,
                size: 70,
                color: Colors.amber,
              ),

              const SizedBox(height: 20),

              /// TITLE
              Text(
                "To continue, please select a subscription",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),

              const SizedBox(height: 25),

              /// FEATURE 1
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "There are hundreds of lessons from beginner to advanced",
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 12),

              /// FEATURE 2
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "The study of culture, travel, and business through special courses",
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),

              /// MONTHLY PLAN
              _planCard(
                context: context,
                title: "Monthly",
                price: "\$12.12 / Month",
                desc: "then \$12.12 per month cancel anytime",
                color: const Color(0xFF5BA78C),
                textColor: Colors.white,
              ),

              const SizedBox(height: 20),

              /// ANNUAL PLAN
              _planCard(
                context: context,
                title: "Annually",
                price: "\$124.12 / Month",
                desc: "then \$124.12 per month cancel anytime",
                color: theme.cardColor,
                textColor: theme.textTheme.bodyLarge?.color ?? Colors.black,
              ),

              const SizedBox(height: 40),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C7CFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Update Plan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// CARD PLAN
  Widget _planCard({
    required BuildContext context,
    required String title,
    required String price,
    required String desc,
    required Color color,
    required Color textColor,
  }) {

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  price,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  desc,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Text(
              "1 week free trial",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}