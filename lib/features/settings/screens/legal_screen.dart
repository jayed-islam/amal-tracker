// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS  (matches app design system)
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CONTENT MODEL
// // ─────────────────────────────────────────────────────────────────────────────

// enum _Lang { bn, en }

// enum _Tab { privacy, terms }

// class _Section {
//   final String icon; // emoji icon
//   final Map<_Lang, String> title;
//   final Map<_Lang, List<_Point>> points;

//   const _Section({
//     required this.icon,
//     required this.title,
//     required this.points,
//   });
// }

// class _Point {
//   final String? heading; // optional bold sub-heading
//   final String body;

//   const _Point({this.heading, required this.body});
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CONTENT DATA
// // ─────────────────────────────────────────────────────────────────────────────

// const _kLastUpdated = {
//   _Lang.bn: 'সর্বশেষ আপডেট: ১ জানুয়ারি ২০২৫',
//   _Lang.en: 'Last updated: January 1, 2025',
// };

// const _kPrivacyIntro = {
//   _Lang.bn:
//       'আমল ট্র্যাকার আপনার গোপনীয়তাকে সর্বোচ্চ গুরুত্ব দেয়। এই নীতিতে আমরা স্পষ্টভাবে জানাই — কী তথ্য সংগ্রহ করি, কীভাবে ব্যবহার করি এবং কীভাবে সুরক্ষিত রাখি।',
//   _Lang.en:
//       'Amal Tracker values your privacy above all. This policy clearly explains what information we collect, how we use it, and how we keep it safe.',
// };

// const _kTermsIntro = {
//   _Lang.bn:
//       'আমল ট্র্যাকার ব্যবহার করার আগে এই শর্তাবলী মনোযোগ দিয়ে পড়ুন। অ্যাপ ব্যবহার করলে আপনি এই শর্তাবলীতে সম্মত বলে গণ্য হবেন।',
//   _Lang.en:
//       'Please read these terms carefully before using Amal Tracker. By using the app you agree to be bound by these terms.',
// };

// final _kPrivacySections = <_Section>[
//   _Section(
//     icon: '🗂️',
//     title: {_Lang.bn: 'আমরা কী তথ্য সংগ্রহ করি', _Lang.en: 'What We Collect'},
//     points: {
//       _Lang.bn: [
//         _Point(
//           heading: 'অ্যাকাউন্ট তথ্য',
//           body:
//               'নিবন্ধনের সময় আপনি যে নাম, ইমেইল বা ফোন নম্বর দেন সেটি সংরক্ষণ করা হয়।',
//         ),
//         _Point(
//           heading: 'আমলের ডেটা',
//           body:
//               'আপনার দৈনিক আমল, পয়েন্ট ও স্ট্রিক — এগুলো আপনার অ্যাকাউন্টের সাথে সংযুক্ত থাকে।',
//         ),
//         _Point(
//           heading: 'ডিভাইস তথ্য',
//           body:
//               'অ্যাপ উন্নত করতে ডিভাইসের ধরন, OS সংস্করণ ও ক্র্যাশ লগ সংগ্রহ করা হতে পারে।',
//         ),
//         _Point(
//           heading: 'লোকেশন',
//           body:
//               'আমরা কোনো GPS বা সুনির্দিষ্ট অবস্থান তথ্য সংগ্রহ করি না। শুধু নিবন্ধন ফর্মে উল্লিখিত জেলা ব্যবহার করা হয়।',
//         ),
//       ],
//       _Lang.en: [
//         _Point(
//           heading: 'Account Information',
//           body: 'Name, email or phone number you provide during registration.',
//         ),
//         _Point(
//           heading: 'Amal Data',
//           body:
//               'Your daily deeds, points and streaks — linked to your account.',
//         ),
//         _Point(
//           heading: 'Device Information',
//           body:
//               'Device type, OS version and crash logs may be collected to improve the app.',
//         ),
//         _Point(
//           heading: 'Location',
//           body:
//               'We do not collect GPS or precise location. Only the district entered in your profile is used.',
//         ),
//       ],
//     },
//   ),
//   _Section(
//     icon: '⚙️',
//     title: {_Lang.bn: 'তথ্য কীভাবে ব্যবহার করি', _Lang.en: 'How We Use It'},
//     points: {
//       _Lang.bn: [
//         _Point(body: 'অ্যাকাউন্ট পরিচালনা ও লগইন নিশ্চিত করতে।'),
//         _Point(
//             body:
//                 'লিডারবোর্ড ও র‍্যাংকিং প্রদর্শনের জন্য (আপনি গোপনীয়তা সেটিংস থেকে নিয়ন্ত্রণ করতে পারবেন)।'),
//         _Point(body: 'নোটিফিকেশন পাঠাতে — শুধু আপনার অনুমতি নিয়ে।'),
//         _Point(body: 'অ্যাপের বাগ খুঁজে বের করতে ও পারফরম্যান্স উন্নত করতে।'),
//         _Point(body: 'আমরা আপনার তথ্য কোনো বিজ্ঞাপন কোম্পানিকে বিক্রি করি না।'),
//       ],
//       _Lang.en: [
//         _Point(body: 'To manage your account and verify login.'),
//         _Point(
//             body:
//                 'To display leaderboard and rankings (you control this in privacy settings).'),
//         _Point(body: 'To send notifications — only with your permission.'),
//         _Point(body: 'To identify bugs and improve app performance.'),
//         _Point(body: 'We never sell your data to advertisers.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '🔒',
//     title: {_Lang.bn: 'তথ্য সুরক্ষা', _Lang.en: 'Data Security'},
//     points: {
//       _Lang.bn: [
//         _Point(body: 'সকল তথ্য HTTPS এনক্রিপশনের মাধ্যমে আদান-প্রদান হয়।'),
//         _Point(
//             body:
//                 'পাসওয়ার্ড কখনো সরাসরি সংরক্ষণ করা হয় না — সবসময় হ্যাশ করা হয়।'),
//         _Point(body: 'ডেটাবেজ অ্যাক্সেস সীমিত ও লগ করা হয়।'),
//         _Point(
//             body:
//                 'কোনো নিরাপত্তা ত্রুটি জানা গেলে আমরা ৭২ ঘণ্টার মধ্যে ব্যবহারকারীদের জানাই।'),
//       ],
//       _Lang.en: [
//         _Point(body: 'All data is transmitted via HTTPS encryption.'),
//         _Point(
//             body: 'Passwords are never stored in plain text — always hashed.'),
//         _Point(body: 'Database access is restricted and audited.'),
//         _Point(
//             body:
//                 'If a security breach occurs, we notify users within 72 hours.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '🤝',
//     title: {_Lang.bn: 'তৃতীয় পক্ষ', _Lang.en: 'Third Parties'},
//     points: {
//       _Lang.bn: [
//         _Point(
//           heading: 'Firebase (Google)',
//           body:
//               'অথেন্টিকেশন ও পুশ নোটিফিকেশনের জন্য ব্যবহৃত হয়। Google-এর নিজস্ব গোপনীয়তা নীতি প্রযোজ্য।',
//         ),
//         _Point(
//           heading: 'ক্লাউড সার্ভার',
//           body:
//               'আপনার ডেটা নিরাপদ ক্লাউড সার্ভারে সংরক্ষণ করা হয়। কোনো তৃতীয় পক্ষ বিশ্লেষণ সরঞ্জামে আপনার ব্যক্তিগত তথ্য পাঠানো হয় না।',
//         ),
//       ],
//       _Lang.en: [
//         _Point(
//           heading: 'Firebase (Google)',
//           body:
//               'Used for authentication and push notifications. Google\'s own privacy policy applies.',
//         ),
//         _Point(
//           heading: 'Cloud Servers',
//           body:
//               'Your data is stored on secure cloud servers. No personal data is sent to third-party analytics tools.',
//         ),
//       ],
//     },
//   ),
//   _Section(
//     icon: '✅',
//     title: {_Lang.bn: 'আপনার অধিকার', _Lang.en: 'Your Rights'},
//     points: {
//       _Lang.bn: [
//         _Point(body: 'আপনার সকল সংরক্ষিত তথ্য দেখার অধিকার আপনার আছে।'),
//         _Point(
//             body:
//                 'সেটিংস থেকে যেকোনো সময় অ্যাকাউন্ট মুছে সব তথ্য স্থায়ীভাবে ডিলিট করতে পারবেন।'),
//         _Point(
//             body:
//                 'গোপনীয়তা সেটিংস থেকে লিডারবোর্ড ও প্রোফাইল দৃশ্যমানতা নিয়ন্ত্রণ করতে পারবেন।'),
//         _Point(
//             body: 'যেকোনো প্রশ্ন বা অভিযোগের জন্য আমাদের সাথে যোগাযোগ করুন।'),
//       ],
//       _Lang.en: [
//         _Point(body: 'You have the right to view all stored data about you.'),
//         _Point(
//             body:
//                 'You can delete your account and all data permanently from Settings at any time.'),
//         _Point(
//             body:
//                 'You control leaderboard and profile visibility from privacy settings.'),
//         _Point(body: 'Contact us for any questions or complaints.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '📬',
//     title: {_Lang.bn: 'যোগাযোগ', _Lang.en: 'Contact Us'},
//     points: {
//       _Lang.bn: [
//         _Point(
//             body:
//                 'গোপনীয়তা সম্পর্কিত যেকোনো প্রশ্নের জন্য:\nsupport@amaltracker.app'),
//         _Point(
//             body:
//                 'এই নীতি পরিবর্তন হলে অ্যাপের মাধ্যমে জানানো হবে এবং নতুন শর্তে সম্মতি চাওয়া হবে।'),
//       ],
//       _Lang.en: [
//         _Point(
//             body:
//                 'For any privacy-related questions:\nsupport@amaltracker.app'),
//         _Point(
//             body:
//                 'If this policy changes, you will be notified through the app and asked to consent to the new terms.'),
//       ],
//     },
//   ),
// ];

// final _kTermsSections = <_Section>[
//   _Section(
//     icon: '📱',
//     title: {_Lang.bn: 'সেবার বিবরণ', _Lang.en: 'Service Description'},
//     points: {
//       _Lang.bn: [
//         _Point(
//             body:
//                 'আমল ট্র্যাকার একটি ব্যক্তিগত ইবাদত ট্র্যাকিং অ্যাপ। এটি ব্যবহারকারীদের দৈনিক আমল রেকর্ড করতে, পয়েন্ট অর্জন করতে এবং লিডারবোর্ডে অংশ নিতে সাহায্য করে।'),
//         _Point(
//             body:
//                 'অ্যাপটি বিনামূল্যে ব্যবহারযোগ্য। ভবিষ্যতে প্রিমিয়াম ফিচার যোগ হতে পারে, যার জন্য আলাদাভাবে জানানো হবে।'),
//       ],
//       _Lang.en: [
//         _Point(
//             body:
//                 'Amal Tracker is a personal worship tracking app. It helps users record daily deeds, earn points and participate in leaderboards.'),
//         _Point(
//             body:
//                 'The app is free to use. Premium features may be added in future and communicated separately.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '👤',
//     title: {
//       _Lang.bn: 'অ্যাকাউন্ট ও দায়িত্ব',
//       _Lang.en: 'Account & Responsibility'
//     },
//     points: {
//       _Lang.bn: [
//         _Point(
//             body:
//                 'অ্যাকাউন্ট নিবন্ধনের জন্য আপনার বয়স কমপক্ষে ১৩ বছর হতে হবে।'),
//         _Point(
//             body:
//                 'আপনার অ্যাকাউন্টের নিরাপত্তা আপনার দায়িত্ব। পাসওয়ার্ড কারো সাথে শেয়ার করবেন না।'),
//         _Point(body: 'একজন ব্যক্তি একটিমাত্র অ্যাকাউন্ট ব্যবহার করতে পারবেন।'),
//         _Point(body: 'আপনার দেওয়া তথ্য সঠিক ও সর্বশেষ রাখা আপনার দায়িত্ব।'),
//       ],
//       _Lang.en: [
//         _Point(
//             body: 'You must be at least 13 years old to register an account.'),
//         _Point(
//             body:
//                 'You are responsible for your account\'s security. Do not share your password.'),
//         _Point(body: 'One person may use only one account.'),
//         _Point(
//             body:
//                 'It is your responsibility to keep your provided information accurate and up to date.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '🚫',
//     title: {_Lang.bn: 'নিষিদ্ধ কার্যক্রম', _Lang.en: 'Prohibited Activities'},
//     points: {
//       _Lang.bn: [
//         _Point(body: 'মিথ্যা বা বানোয়াট আমল তথ্য প্রবেশ করানো নিষিদ্ধ।'),
//         _Point(
//             body:
//                 'অ্যাপের সিস্টেম ম্যানিপুলেট করে অন্যায়ভাবে পয়েন্ট অর্জনের চেষ্টা করা নিষিদ্ধ।'),
//         _Point(
//             body:
//                 'অন্য ব্যবহারকারীকে হয়রানি বা তাদের তথ্য অনুমতি ছাড়া ব্যবহার নিষিদ্ধ।'),
//         _Point(
//             body:
//                 'অ্যাপের কোড, API বা ডেটাবেজে অননুমোদিত প্রবেশের চেষ্টা নিষিদ্ধ।'),
//         _Point(
//             body:
//                 'উপরোক্ত নিয়ম ভঙ্গ করলে অ্যাকাউন্ট স্থগিত বা বাতিল করা হতে পারে।'),
//       ],
//       _Lang.en: [
//         _Point(body: 'Entering false or fabricated deed data is prohibited.'),
//         _Point(
//             body:
//                 'Attempting to manipulate the app system to unfairly gain points is prohibited.'),
//         _Point(
//             body:
//                 'Harassing other users or using their data without permission is prohibited.'),
//         _Point(
//             body:
//                 'Unauthorized access to the app\'s code, API or database is prohibited.'),
//         _Point(
//             body:
//                 'Violating the above rules may result in account suspension or termination.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '©️',
//     title: {_Lang.bn: 'মেধাস্বত্ব', _Lang.en: 'Intellectual Property'},
//     points: {
//       _Lang.bn: [
//         _Point(
//             body:
//                 'আমল ট্র্যাকারের লোগো, ডিজাইন, কোড ও কনটেন্টের সকল মেধাস্বত্ব আমাদের।'),
//         _Point(
//             body:
//                 'আপনার নিজের আমল ডেটার মালিকানা আপনার। আমরা সেটি তৃতীয় পক্ষকে দিই না।'),
//         _Point(body: 'অ্যাপের কোনো অংশ অনুমতি ছাড়া কপি বা বিতরণ করা যাবে না।'),
//       ],
//       _Lang.en: [
//         _Point(
//             body:
//                 'All intellectual property of Amal Tracker\'s logo, design, code and content belongs to us.'),
//         _Point(
//             body:
//                 'You own your personal amal data. We do not give it to third parties.'),
//         _Point(
//             body:
//                 'No part of the app may be copied or distributed without permission.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '⚖️',
//     title: {_Lang.bn: 'দায় সীমাবদ্ধতা', _Lang.en: 'Limitation of Liability'},
//     points: {
//       _Lang.bn: [
//         _Point(
//             body:
//                 'অ্যাপ ব্যবহারের ফলে কোনো ধর্মীয় বা আধ্যাত্মিক লক্ষ্য অর্জন না হলে আমরা দায়ী নই — এটি শুধু একটি সহায়ক টুল।'),
//         _Point(
//             body:
//                 'ইন্টারনেট সংযোগ সমস্যা বা সার্ভার ডাউনটাইমের কারণে ডেটা সাময়িকভাবে অনুপলব্ধ হতে পারে।'),
//         _Point(
//             body:
//                 'আমরা ডেটা ব্যাকআপের সর্বোচ্চ চেষ্টা করি, তবে কোনো প্রযুক্তিগত দুর্ঘটনায় ডেটা হারানোর জন্য সম্পূর্ণ দায়বদ্ধ নই।'),
//       ],
//       _Lang.en: [
//         _Point(
//             body:
//                 'We are not liable if religious or spiritual goals are not achieved — this is only a helper tool.'),
//         _Point(
//             body:
//                 'Data may be temporarily unavailable due to internet issues or server downtime.'),
//         _Point(
//             body:
//                 'We make every effort to back up data, but are not fully liable for data loss due to technical incidents.'),
//       ],
//     },
//   ),
//   _Section(
//     icon: '🔄',
//     title: {_Lang.bn: 'শর্ত পরিবর্তন', _Lang.en: 'Changes to Terms'},
//     points: {
//       _Lang.bn: [
//         _Point(body: 'আমরা যেকোনো সময় এই শর্তাবলী আপডেট করতে পারি।'),
//         _Point(
//             body:
//                 'উল্লেখযোগ্য পরিবর্তন হলে অ্যাপের ভেতর নোটিফিকেশনের মাধ্যমে ৭ দিন আগে জানানো হবে।'),
//         _Point(
//             body:
//                 'পরিবর্তনের পর অ্যাপ ব্যবহার অব্যাহত রাখলে নতুন শর্তে সম্মতি দেওয়া হয়েছে বলে গণ্য হবে।'),
//       ],
//       _Lang.en: [
//         _Point(body: 'We may update these terms at any time.'),
//         _Point(
//             body:
//                 'For significant changes, you will be notified via in-app notification 7 days in advance.'),
//         _Point(
//             body:
//                 'Continued use of the app after changes constitutes agreement to the new terms.'),
//       ],
//     },
//   ),
// ];

// // ─────────────────────────────────────────────────────────────────────────────
// // LEGAL PAGE
// // ─────────────────────────────────────────────────────────────────────────────

// class LegalScreen extends StatefulWidget {
//   /// Pass [initialTab] to open directly on Privacy or Terms.
//   final _Tab initialTab;

//   const LegalScreen({super.key, this.initialTab = _Tab.privacy});

//   @override
//   State<LegalScreen> createState() => _LegalScreenState();
// }

// class _LegalScreenState extends State<LegalScreen> {
//   late _Tab _tab;
//   late _Lang _lang;

//   // Track which sections are expanded
//   final Set<int> _expanded = {};

//   @override
//   void initState() {
//     super.initState();
//     _tab = widget.initialTab;
//     _lang = _Lang.bn;
//   }

//   List<_Section> get _sections =>
//       _tab == _Tab.privacy ? _kPrivacySections : _kTermsSections;

//   String get _pageTitle => _tab == _Tab.privacy
//       ? (_lang == _Lang.bn ? 'গোপনীয়তা নীতি' : 'Privacy Policy')
//       : (_lang == _Lang.bn ? 'ব্যবহারের শর্তাবলী' : 'Terms of Use');

//   String get _intro =>
//       _tab == _Tab.privacy ? _kPrivacyIntro[_lang]! : _kTermsIntro[_lang]!;

//   void _switchTab(_Tab t) {
//     if (_tab == t) return;
//     HapticFeedback.selectionClick();
//     setState(() {
//       _tab = t;
//       _expanded.clear();
//     });
//   }

//   void _switchLang(_Lang l) {
//     if (_lang == l) return;
//     HapticFeedback.selectionClick();
//     setState(() => _lang = l);
//   }

//   void _toggleSection(int i) {
//     HapticFeedback.selectionClick();
//     setState(() {
//       if (_expanded.contains(i)) {
//         _expanded.remove(i);
//       } else {
//         _expanded.add(i);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;

//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── App Bar ────────────────────────────────────────────
//           _buildAppBar(),

//           // ── Tab switcher ───────────────────────────────────────
//           SliverToBoxAdapter(
//             child: _buildTabBar(hPad)
//                 .animate()
//                 .fadeIn(delay: 60.ms)
//                 .slideY(begin: 0.05),
//           ),

//           // ── Body ───────────────────────────────────────────────
//           SliverPadding(
//             padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 // Intro card
//                 _IntroCard(text: _intro, tab: _tab)
//                     .animate()
//                     .fadeIn(delay: 100.ms)
//                     .slideY(begin: 0.05),
//                 const SizedBox(height: 16),

//                 // Last updated
//                 Padding(
//                   padding: const EdgeInsets.only(left: 4, bottom: 14),
//                   child: Text(_kLastUpdated[_lang]!,
//                       style: const TextStyle(
//                           color: _C.textHint,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500)),
//                 ).animate().fadeIn(delay: 120.ms),

//                 // Sections
//                 ..._sections.asMap().entries.map((e) {
//                   final i = e.key;
//                   final section = e.value;
//                   final open = _expanded.contains(i);

//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: _SectionCard(
//                       section: section,
//                       lang: _lang,
//                       isOpen: open,
//                       onTap: () => _toggleSection(i),
//                     )
//                         .animate()
//                         .fadeIn(delay: (140 + i * 40).ms)
//                         .slideY(begin: 0.04),
//                   );
//                 }),

//                 // Footer
//                 _Footer(lang: _lang).animate().fadeIn(delay: 400.ms),

//                 SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── App bar with language toggle ──────────────────────────────────────────

//   Widget _buildAppBar() {
//     return SliverAppBar(
//       pinned: true,
//       backgroundColor: _C.darkGreen,
//       surfaceTintColor: Colors.transparent,
//       systemOverlayStyle: SystemUiOverlayStyle.light,
//       leading: GestureDetector(
//         onTap: () => Navigator.pop(context),
//         child: Container(
//           margin: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Icon(Icons.arrow_back_ios_rounded,
//               color: Colors.white, size: 16),
//         ),
//       ),
//       title: Text(
//         _pageTitle,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.w800,
//         ),
//       ),
//       actions: [
//         // Language toggle pill
//         GestureDetector(
//           onTap: () => _switchLang(_lang == _Lang.bn ? _Lang.en : _Lang.bn),
//           child: Container(
//             margin: const EdgeInsets.only(right: 16),
//             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(22),
//               border:
//                   Border.all(color: Colors.white.withOpacity(0.18), width: 0.5),
//             ),
//             child: Row(mainAxisSize: MainAxisSize.min, children: [
//               _LangChip(label: 'বাং', active: _lang == _Lang.bn),
//               const SizedBox(width: 2),
//               _LangChip(label: 'EN', active: _lang == _Lang.en),
//             ]),
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Tab bar ───────────────────────────────────────────────────────────────

//   Widget _buildTabBar(double hPad) {
//     return Container(
//       color: _C.darkGreen,
//       padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 16),
//       child: Container(
//         height: 44,
//         padding: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(children: [
//           _TabChip(
//             label: _lang == _Lang.bn ? 'গোপনীয়তা নীতি' : 'Privacy Policy',
//             icon: Icons.shield_outlined,
//             active: _tab == _Tab.privacy,
//             onTap: () => _switchTab(_Tab.privacy),
//           ),
//           const SizedBox(width: 4),
//           _TabChip(
//             label: _lang == _Lang.bn ? 'ব্যবহারের শর্তাবলী' : 'Terms of Use',
//             icon: Icons.description_outlined,
//             active: _tab == _Tab.terms,
//             onTap: () => _switchTab(_Tab.terms),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LANGUAGE CHIP  (in app bar)
// // ─────────────────────────────────────────────────────────────────────────────

// class _LangChip extends StatelessWidget {
//   final String label;
//   final bool active;
//   const _LangChip({required this.label, required this.active});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOut,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//       decoration: BoxDecoration(
//         color: active ? Colors.white : Colors.transparent,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: active ? _C.darkGreen : Colors.white.withOpacity(0.7),
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TAB CHIP  (Privacy / Terms)
// // ─────────────────────────────────────────────────────────────────────────────

// class _TabChip extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool active;
//   final VoidCallback onTap;

//   const _TabChip({
//     required this.label,
//     required this.icon,
//     required this.active,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOut,
//           decoration: BoxDecoration(
//             color: active ? Colors.white : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon,
//                   color: active ? _C.darkGreen : Colors.white.withOpacity(0.6),
//                   size: 14),
//               const SizedBox(width: 6),
//               Flexible(
//                 child: Text(
//                   label,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color:
//                         active ? _C.darkGreen : Colors.white.withOpacity(0.7),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INTRO CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _IntroCard extends StatelessWidget {
//   final String text;
//   final _Tab tab;
//   const _IntroCard({required this.text, required this.tab});

//   @override
//   Widget build(BuildContext context) {
//     final color = tab == _Tab.privacy ? _C.green : _C.blue;
//     final bgCol = tab == _Tab.privacy ? _C.greenLight : _C.blueLight;
//     final icon =
//         tab == _Tab.privacy ? Icons.shield_rounded : Icons.description_rounded;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: bgCol,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.2), width: 0.8),
//       ),
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: color, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: _C.textPrimary,
//               fontSize: 13,
//               height: 1.65,
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION CARD  — expandable accordion
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionCard extends StatelessWidget {
//   final _Section section;
//   final _Lang lang;
//   final bool isOpen;
//   final VoidCallback onTap;

//   const _SectionCard({
//     required this.section,
//     required this.lang,
//     required this.isOpen,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final points = section.points[lang]!;

//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 260),
//         curve: Curves.easeOut,
//         decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isOpen ? _C.green.withOpacity(0.3) : _C.border,
//             width: isOpen ? 0.8 : 0.5,
//           ),
//           boxShadow: isOpen
//               ? [
//                   BoxShadow(
//                     color: _C.darkGreen.withOpacity(0.06),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   )
//                 ]
//               : null,
//         ),
//         child: Column(
//           children: [
//             // ── Header row ──────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Row(children: [
//                 // Emoji icon
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     color: isOpen ? _C.greenLight : _C.bg,
//                     borderRadius: BorderRadius.circular(11),
//                   ),
//                   child: Center(
//                     child: Text(section.icon,
//                         style: const TextStyle(fontSize: 18)),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     section.title[lang]!,
//                     style: TextStyle(
//                       color: isOpen ? _C.darkGreen : _C.textPrimary,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 // Bullet count badge (collapsed only)
//                 if (!isOpen) ...[
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: _C.bg,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: _C.border, width: 0.5),
//                     ),
//                     child: Text('${points.length}',
//                         style: const TextStyle(
//                             color: _C.textHint,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600)),
//                   ),
//                   const SizedBox(width: 8),
//                 ],
//                 AnimatedRotation(
//                   turns: isOpen ? 0.5 : 0,
//                   duration: const Duration(milliseconds: 240),
//                   child: const Icon(Icons.expand_more_rounded,
//                       color: _C.textHint, size: 20),
//                 ),
//               ]),
//             ),

//             // ── Expanded content ─────────────────────────────────
//             AnimatedCrossFade(
//               duration: const Duration(milliseconds: 260),
//               sizeCurve: Curves.easeOut,
//               crossFadeState:
//                   isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//               firstChild: Column(children: [
//                 const Padding(
//                   padding: EdgeInsets.only(left: 16, right: 16),
//                   child: Divider(height: 0.5, thickness: 0.5, color: _C.border),
//                 ),
//                 const SizedBox(height: 4),
//                 ...points.asMap().entries.map((e) => _PointTile(
//                       point: e.value,
//                       isLast: e.key == points.length - 1,
//                     )),
//                 const SizedBox(height: 4),
//               ]),
//               secondChild: const SizedBox.shrink(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // POINT TILE  — single bullet point inside a section
// // ─────────────────────────────────────────────────────────────────────────────

// class _PointTile extends StatelessWidget {
//   final _Point point;
//   final bool isLast;
//   const _PointTile({required this.point, required this.isLast});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 6),
//             child: Container(
//               width: 6,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: _C.green,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 6),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (point.heading != null) ...[
//                     Text(
//                       point.heading!,
//                       style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                   ],
//                   Text(
//                     point.body,
//                     style: const TextStyle(
//                       color: _C.textSecondary,
//                       fontSize: 12.5,
//                       height: 1.6,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FOOTER
// // ─────────────────────────────────────────────────────────────────────────────

// class _Footer extends StatelessWidget {
//   final _Lang lang;
//   const _Footer({required this.lang});

//   @override
//   Widget build(BuildContext context) {
//     final text = lang == _Lang.bn
//         ? 'আমল ট্র্যাকার ব্যবহার করার জন্য ধন্যবাদ।\nআল্লাহ আমাদের সবার আমল কবুল করুন।'
//         : 'Thank you for using Amal Tracker.\nMay Allah accept all our deeds.';

//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: _C.darkGreen.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.darkGreen.withOpacity(0.1), width: 0.5),
//       ),
//       child: Column(children: [
//         const Text('🌿', style: TextStyle(fontSize: 28)),
//         const SizedBox(height: 10),
//         Text(
//           text,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: _C.textSecondary,
//             fontSize: 13,
//             height: 1.65,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           lang == _Lang.bn
//               ? 'support@amaltracker.app'
//               : 'support@amaltracker.app',
//           style: const TextStyle(
//             color: _C.darkGreen,
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ]),
//     );
//   }
// }
// lib/features/legal/legal_screen.dart
//
// One screen, two uses:
//   LegalScreen.privacy()  →  Privacy Policy
//   LegalScreen.terms()    →  Terms of Use
//
// Design principle: content is everything. No accordions, no animations,
// no decoration beyond what aids readability. Language toggle only.
// ─────────────────────────────────────────────────────────────────────────────

// import 'package:amal_tracker/features/settings/constants/legal_content.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// // ── Design tokens (matches app ColorT) ───────────────────────────────────────
// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const green = Color(0xFF16A34A);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textBody = Color(0xFF2D3F31);
//   static const textMuted = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const divider = Color(0xFFE8EEE8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// enum LegalType { privacy, terms }

// class LegalScreen extends StatefulWidget {
//   final LegalType type;

//   const LegalScreen({super.key, this.type = LegalType.privacy});

//   const LegalScreen.privacy({super.key}) : type = LegalType.privacy;
//   const LegalScreen.terms({super.key}) : type = LegalType.terms;

//   @override
//   State<LegalScreen> createState() => _LegalScreenState();
// }

// class _LegalScreenState extends State<LegalScreen> {
//   Lang _lang = Lang.bn;

//   bool get _isBn => _lang == Lang.bn;

//   String get _title => widget.type == LegalType.privacy
//       ? (_isBn ? 'গোপনীয়তা নীতি' : 'Privacy Policy')
//       : (_isBn ? 'ব্যবহারের শর্তাবলী' : 'Terms of Use');

//   String get _intro => widget.type == LegalType.privacy
//       ? kPrivacyIntro[_lang]!
//       : kTermsIntro[_lang]!;

//   List<LegalSection> get _sections =>
//       widget.type == LegalType.privacy ? kPrivacySections : kTermsSections;

//   void _toggleLang() {
//     HapticFeedback.selectionClick();
//     setState(() => _lang = _isBn ? Lang.en : Lang.bn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _C.bg,
//       appBar: AppBar(
//         backgroundColor: _C.darkGreen,
//         surfaceTintColor: Colors.transparent,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Container(
//             margin: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.arrow_back_ios_rounded,
//               color: Colors.white,
//               size: 16,
//             ),
//           ),
//         ),
//         title: Text(
//           _title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         // ── Language toggle — only functional UI element ──────────────
//         actions: [
//           GestureDetector(
//             onTap: _toggleLang,
//             child: Container(
//               margin: const EdgeInsets.only(right: 16),
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(22),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.18),
//                   width: 0.5,
//                 ),
//               ),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 _LangPill(label: 'বাং', active: _isBn),
//                 const SizedBox(width: 2),
//                 _LangPill(label: 'EN', active: !_isBn),
//               ]),
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//         children: [
//           // ── Intro paragraph ─────────────────────────────────────────
//           Text(
//             _intro,
//             style: const TextStyle(
//               color: _C.textBody,
//               fontSize: 14,
//               height: 1.75,
//             ),
//           ),
//           const SizedBox(height: 6),

//           // ── Last updated ─────────────────────────────────────────────
//           Text(
//             kLegalLastUpdated[_lang]!,
//             style: const TextStyle(
//               color: _C.textHint,
//               fontSize: 11.5,
//             ),
//           ),
//           const SizedBox(height: 28),

//           // ── Sections — flat list, no accordion ──────────────────────
//           ..._sections.map((section) => _SectionBlock(
//                 section: section,
//                 lang: _lang,
//               )),

//           // ── Footer ───────────────────────────────────────────────────
//           const SizedBox(height: 16),
//           const Divider(color: _C.divider, height: 1),
//           const SizedBox(height: 24),
//           Text(
//             _isBn
//                 ? 'প্রশ্ন বা মতামতের জন্য যোগাযোগ করুন:'
//                 : 'For questions or feedback, contact us:',
//             style: const TextStyle(
//               color: _C.textMuted,
//               fontSize: 13,
//             ),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             'support@amaltracker.app',
//             style: TextStyle(
//               color: _C.darkGreen,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION BLOCK — heading + bullet points, always visible
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionBlock extends StatelessWidget {
//   final LegalSection section;
//   final Lang lang;

//   const _SectionBlock({required this.section, required this.lang});

//   @override
//   Widget build(BuildContext context) {
//     final points = section.points[lang]!;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 28),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Section heading ──────────────────────────────────────────
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(section.icon, style: const TextStyle(fontSize: 16)),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   section.title[lang]!,
//                   style: const TextStyle(
//                     color: _C.textPrimary,
//                     fontSize: 14.5,
//                     fontWeight: FontWeight.w700,
//                     height: 1.3,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),

//           // ── Points ───────────────────────────────────────────────────
//           ...points.map((p) => _PointRow(point: p)),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // POINT ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _PointRow extends StatelessWidget {
//   final LegalPoint point;
//   const _PointRow({required this.point});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Bullet dot
//           Padding(
//             padding: const EdgeInsets.only(top: 7),
//             child: Container(
//               width: 4,
//               height: 4,
//               decoration: const BoxDecoration(
//                 color: _C.green,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 style: const TextStyle(
//                   color: _C.textBody,
//                   fontSize: 13.5,
//                   height: 1.65,
//                 ),
//                 children: [
//                   if (point.heading != null) ...[
//                     TextSpan(
//                       text: '${point.heading}  ',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: _C.textPrimary,
//                       ),
//                     ),
//                   ],
//                   TextSpan(text: point.body),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LANGUAGE PILL  (inside app bar toggle)
// // ─────────────────────────────────────────────────────────────────────────────

// class _LangPill extends StatelessWidget {
//   final String label;
//   final bool active;
//   const _LangPill({required this.label, required this.active});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 180),
//       padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
//       decoration: BoxDecoration(
//         color: active ? Colors.white : Colors.transparent,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: active ? _C.darkGreen : Colors.white.withOpacity(0.65),
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }
// Here is the completely refactored, production-ready single-page Flutter solution.

// ### Key Improvements:

// * **Unified Single Page:** Removed the constructor variants and the `enum LegalType`. Both Privacy Policy and Terms of Use content are now cleanly rendered sequentially down a single, scrollable document view.
// * **Professional Typography & Layout:** Cleaned up the structural spacings, removed all inline emojis (`section.icon` references), and replaced them with refined typographic hierarchies.
// * **Visual Anchors:** Sections are now clearly separated using stylized horizontal rules, and modern card-based semantic spacing replaces arbitrary flat margins.

// ```dart

import 'package:amal_tracker/features/settings/constants/legal_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Design Tokens ────────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFF4F6F1);
  static const darkGreen = Color(0xFF0E3D22);
  static const green = Color(0xFF16A34A);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textBody = Color(0xFF2D3F31);
  static const textMuted = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const divider = Color(0xFFE8EEE8);
}

// ─────────────────────────────────────────────────────────────────────────────
// UNIFIED LEGAL SCREEN (Privacy Policy & Terms of Use on One Page)
// ─────────────────────────────────────────────────────────────────────────────

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  Lang _lang = Lang.bn;

  bool get _isBn => _lang == Lang.bn;

  String get _screenTitle => _isBn ? 'আইনি তথ্যাবলী' : 'Legal Information';

  String get _privacyTitle => _isBn ? '১. গোপনীয়তা নীতি' : '1. Privacy Policy';
  String get _termsTitle => _isBn ? '২. ব্যবহারের শর্তাবলী' : '2. Terms of Use';

  void _toggleLang() {
    HapticFeedback.selectionClick();
    setState(() => _lang = _isBn ? Lang.en : Lang.bn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.darkGreen,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        title: Text(
          _screenTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _toggleLang,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LangPill(label: 'বাং', active: _isBn),
                  const SizedBox(width: 2),
                  _LangPill(label: 'EN', active: !_isBn),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // ── Metadata Header ────────────────────────────────────────────────
          Text(
            kLegalLastUpdated[_lang]!,
            style: const TextStyle(
              color: _C.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // ── Segment 1: Privacy Policy ──────────────────────────────────────
          Text(
            _privacyTitle,
            style: const TextStyle(
              color: _C.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            kPrivacyIntro[_lang]!,
            style: const TextStyle(
              color: _C.textBody,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          ...kPrivacySections.map((section) => _SectionBlock(
                section: section,
                lang: _lang,
              )),

          const SizedBox(height: 16),
          const Divider(color: _C.divider, thickness: 1.5, height: 1),
          const SizedBox(height: 32),

          // ── Segment 2: Terms of Use ────────────────────────────────────────
          Text(
            _termsTitle,
            style: const TextStyle(
              color: _C.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            kTermsIntro[_lang]!,
            style: const TextStyle(
              color: _C.textBody,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          ...kTermsSections.map((section) => _SectionBlock(
                section: section,
                lang: _lang,
              )),

          // ── Footer ─────────────────────────────────────────────────────────
          const SizedBox(height: 16),
          const Divider(color: _C.divider, height: 1),
          const SizedBox(height: 24),
          Text(
            _isBn
                ? 'প্রশ্ন বা মতামতের জন্য যোগাযোগ করুন:'
                : 'For questions or feedback, contact us:',
            style: const TextStyle(
              color: _C.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'support@amaltracker.app',
            style: TextStyle(
              color: _C.darkGreen,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION BLOCK
// ─────────────────────────────────────────────────────────────────────────────

class _SectionBlock extends StatelessWidget {
  final LegalSection section;
  final Lang lang;

  const _SectionBlock({required this.section, required this.lang});

  @override
  Widget build(BuildContext context) {
    final points = section.points[lang]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title[lang]!,
            style: const TextStyle(
              color: _C.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map((p) => _PointRow(point: p)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POINT ROW
// ─────────────────────────────────────────────────────────────────────────────

class _PointRow extends StatelessWidget {
  final LegalPoint point;
  const _PointRow({required this.point});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: _C.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: _C.textBody,
                  fontSize: 13.5,
                  height: 1.65,
                ),
                children: [
                  if (point.heading != null) ...[
                    TextSpan(
                      text: '${point.heading} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _C.textPrimary,
                      ),
                    ),
                  ],
                  TextSpan(text: point.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE PILL
// ─────────────────────────────────────────────────────────────────────────────

class _LangPill extends StatelessWidget {
  final String label;
  final bool active;
  const _LangPill({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? _C.darkGreen : Colors.white.withOpacity(0.65),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
