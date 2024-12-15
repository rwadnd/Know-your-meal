import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching email client

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  // Function to handle "Contact Us" button
  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '0rwad.nadam0@gmail.com', // Replace with your team's email address
      query: 'subject=Feedback on the Application&body=Hello Team,', // Pre-filled email
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Space for the status bar
            const Text(
              'ABOUT US',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This application was developed as part of the FE401 course in the academic year 2024 - 2025 Spring semester under the provision of Prof. Dr. Atilla ELÇi',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'DEVELOPMENT TEAM:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ravad Nadam - SE Student\n'
              'İpek Zorpineci - SE Student\n'
              'Zekeriya Alabus - SE Student\n\n'
              'Judy Sarmini - Nutrition and Dietetics\n'
              'Layan Halis - Nutrition and Dietetics',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Text(
              'If you have any suggestions or questions, please don’t hesitate to',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: _launchEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Contact Us',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40), // Space for bottom navigation bar
          ],
        ),
      );
      
    
  }
}
