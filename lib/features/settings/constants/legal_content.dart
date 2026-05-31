// All legal text lives here. Screens just render it.
// ─────────────────────────────────────────────────────────────────────────────

enum Lang { bn, en }

class LegalSection {
  final String icon;
  final Map<Lang, String> title;
  final Map<Lang, List<LegalPoint>> points;
  const LegalSection({
    required this.icon,
    required this.title,
    required this.points,
  });
}

class LegalPoint {
  final String? heading;
  final String body;
  const LegalPoint({this.heading, required this.body});
}

// ── Shared ───────────────────────────────────────────────────────────────────

const kLegalLastUpdated = {
  Lang.bn: 'সর্বশেষ আপডেট: ১ জানুয়ারি ২০২৫',
  Lang.en: 'Last updated: January 1, 2025',
};

// ── Privacy ──────────────────────────────────────────────────────────────────

const kPrivacyIntro = {
  Lang.bn:
      'আমল ট্র্যাকার আপনার গোপনীয়তাকে সর্বোচ্চ গুরুত্ব দেয়। এই নীতিতে আমরা স্পষ্টভাবে জানাই — কী তথ্য সংগ্রহ করি, কীভাবে ব্যবহার করি এবং কীভাবে সুরক্ষিত রাখি।',
  Lang.en:
      'Amal Tracker values your privacy above all. This policy clearly explains what information we collect, how we use it, and how we keep it safe.',
};

final kPrivacySections = <LegalSection>[
  LegalSection(
    icon: '🗂️',
    title: {Lang.bn: 'আমরা কী তথ্য সংগ্রহ করি', Lang.en: 'What We Collect'},
    points: {
      Lang.bn: [
        LegalPoint(
            heading: 'অ্যাকাউন্ট তথ্য',
            body:
                'নিবন্ধনের সময় আপনি যে নাম, ইমেইল বা ফোন নম্বর দেন সেটি সংরক্ষণ করা হয়।'),
        LegalPoint(
            heading: 'আমলের ডেটা',
            body:
                'আপনার দৈনিক আমল, পয়েন্ট ও স্ট্রিক — এগুলো আপনার অ্যাকাউন্টের সাথে সংযুক্ত থাকে।'),
        LegalPoint(
            heading: 'ডিভাইস তথ্য',
            body:
                'অ্যাপ উন্নত করতে ডিভাইসের ধরন, OS সংস্করণ ও ক্র্যাশ লগ সংগ্রহ করা হতে পারে।'),
        LegalPoint(
            heading: 'লোকেশন',
            body:
                'আমরা কোনো GPS বা সুনির্দিষ্ট অবস্থান তথ্য সংগ্রহ করি না। শুধু নিবন্ধন ফর্মে উল্লিখিত জেলা ব্যবহার করা হয়।'),
      ],
      Lang.en: [
        LegalPoint(
            heading: 'Account Information',
            body:
                'Name, email or phone number you provide during registration.'),
        LegalPoint(
            heading: 'Amal Data',
            body:
                'Your daily deeds, points and streaks — linked to your account.'),
        LegalPoint(
            heading: 'Device Information',
            body:
                'Device type, OS version and crash logs may be collected to improve the app.'),
        LegalPoint(
            heading: 'Location',
            body:
                'We do not collect GPS or precise location. Only the district entered in your profile is used.'),
      ],
    },
  ),
  LegalSection(
    icon: '⚙️',
    title: {Lang.bn: 'তথ্য কীভাবে ব্যবহার করি', Lang.en: 'How We Use It'},
    points: {
      Lang.bn: [
        LegalPoint(body: 'অ্যাকাউন্ট পরিচালনা ও লগইন নিশ্চিত করতে।'),
        LegalPoint(
            body:
                'লিডারবোর্ড ও র‍্যাংকিং প্রদর্শনের জন্য (আপনি গোপনীয়তা সেটিংস থেকে নিয়ন্ত্রণ করতে পারবেন)।'),
        LegalPoint(body: 'নোটিফিকেশন পাঠাতে — শুধু আপনার অনুমতি নিয়ে।'),
        LegalPoint(
            body: 'অ্যাপের বাগ খুঁজে বের করতে ও পারফরম্যান্স উন্নত করতে।'),
        LegalPoint(
            body: 'আমরা আপনার তথ্য কোনো বিজ্ঞাপন কোম্পানিকে বিক্রি করি না।'),
      ],
      Lang.en: [
        LegalPoint(body: 'To manage your account and verify login.'),
        LegalPoint(
            body:
                'To display leaderboard and rankings (you control this in privacy settings).'),
        LegalPoint(body: 'To send notifications — only with your permission.'),
        LegalPoint(body: 'To identify bugs and improve app performance.'),
        LegalPoint(body: 'We never sell your data to advertisers.'),
      ],
    },
  ),
  LegalSection(
    icon: '🔒',
    title: {Lang.bn: 'তথ্য সুরক্ষা', Lang.en: 'Data Security'},
    points: {
      Lang.bn: [
        LegalPoint(body: 'সকল তথ্য HTTPS এনক্রিপশনের মাধ্যমে আদান-প্রদান হয়।'),
        LegalPoint(
            body:
                'পাসওয়ার্ড কখনো সরাসরি সংরক্ষণ করা হয় না — সবসময় হ্যাশ করা হয়।'),
        LegalPoint(body: 'ডেটাবেজ অ্যাক্সেস সীমিত ও লগ করা হয়।'),
        LegalPoint(
            body:
                'কোনো নিরাপত্তা ত্রুটি জানা গেলে আমরা ৭২ ঘণ্টার মধ্যে ব্যবহারকারীদের জানাই।'),
      ],
      Lang.en: [
        LegalPoint(body: 'All data is transmitted via HTTPS encryption.'),
        LegalPoint(
            body: 'Passwords are never stored in plain text — always hashed.'),
        LegalPoint(body: 'Database access is restricted and audited.'),
        LegalPoint(
            body:
                'If a security breach occurs, we notify users within 72 hours.'),
      ],
    },
  ),
  LegalSection(
    icon: '🤝',
    title: {Lang.bn: 'তৃতীয় পক্ষ', Lang.en: 'Third Parties'},
    points: {
      Lang.bn: [
        LegalPoint(
            heading: 'Firebase (Google)',
            body:
                'অথেন্টিকেশন ও পুশ নোটিফিকেশনের জন্য ব্যবহৃত হয়। Google-এর নিজস্ব গোপনীয়তা নীতি প্রযোজ্য।'),
        LegalPoint(
            heading: 'ক্লাউড সার্ভার',
            body:
                'আপনার ডেটা নিরাপদ ক্লাউড সার্ভারে সংরক্ষণ করা হয়। কোনো তৃতীয় পক্ষ বিশ্লেষণ সরঞ্জামে আপনার ব্যক্তিগত তথ্য পাঠানো হয় না।'),
      ],
      Lang.en: [
        LegalPoint(
            heading: 'Firebase (Google)',
            body:
                'Used for authentication and push notifications. Google\'s own privacy policy applies.'),
        LegalPoint(
            heading: 'Cloud Servers',
            body:
                'Your data is stored on secure cloud servers. No personal data is sent to third-party analytics tools.'),
      ],
    },
  ),
  LegalSection(
    icon: '✅',
    title: {Lang.bn: 'আপনার অধিকার', Lang.en: 'Your Rights'},
    points: {
      Lang.bn: [
        LegalPoint(body: 'আপনার সকল সংরক্ষিত তথ্য দেখার অধিকার আপনার আছে।'),
        LegalPoint(
            body:
                'সেটিংস থেকে যেকোনো সময় অ্যাকাউন্ট মুছে সব তথ্য স্থায়ীভাবে ডিলিট করতে পারবেন।'),
        LegalPoint(
            body:
                'গোপনীয়তা সেটিংস থেকে লিডারবোর্ড ও প্রোফাইল দৃশ্যমানতা নিয়ন্ত্রণ করতে পারবেন।'),
        LegalPoint(
            body: 'যেকোনো প্রশ্ন বা অভিযোগের জন্য আমাদের সাথে যোগাযোগ করুন।'),
      ],
      Lang.en: [
        LegalPoint(
            body: 'You have the right to view all stored data about you.'),
        LegalPoint(
            body:
                'You can delete your account and all data permanently from Settings at any time.'),
        LegalPoint(
            body:
                'You control leaderboard and profile visibility from privacy settings.'),
        LegalPoint(body: 'Contact us for any questions or complaints.'),
      ],
    },
  ),
  LegalSection(
    icon: '📬',
    title: {Lang.bn: 'যোগাযোগ', Lang.en: 'Contact Us'},
    points: {
      Lang.bn: [
        LegalPoint(
            body:
                'গোপনীয়তা সম্পর্কিত যেকোনো প্রশ্নের জন্য: support@amaltracker.app'),
        LegalPoint(
            body:
                'এই নীতি পরিবর্তন হলে অ্যাপের মাধ্যমে জানানো হবে এবং নতুন শর্তে সম্মতি চাওয়া হবে।'),
      ],
      Lang.en: [
        LegalPoint(
            body: 'For any privacy-related questions: support@amaltracker.app'),
        LegalPoint(
            body:
                'If this policy changes, you will be notified through the app and asked to consent to the new terms.'),
      ],
    },
  ),
];

// ── Terms ─────────────────────────────────────────────────────────────────────

const kTermsIntro = {
  Lang.bn:
      'আমল ট্র্যাকার ব্যবহার করার আগে এই শর্তাবলী মনোযোগ দিয়ে পড়ুন। অ্যাপ ব্যবহার করলে আপনি এই শর্তাবলীতে সম্মত বলে গণ্য হবেন।',
  Lang.en:
      'Please read these terms carefully before using Amal Tracker. By using the app you agree to be bound by these terms.',
};

final kTermsSections = <LegalSection>[
  LegalSection(
    icon: '📱',
    title: {Lang.bn: 'সেবার বিবরণ', Lang.en: 'Service Description'},
    points: {
      Lang.bn: [
        LegalPoint(
            body:
                'আমল ট্র্যাকার একটি ব্যক্তিগত ইবাদত ট্র্যাকিং অ্যাপ। এটি ব্যবহারকারীদের দৈনিক আমল রেকর্ড করতে, পয়েন্ট অর্জন করতে এবং লিডারবোর্ডে অংশ নিতে সাহায্য করে।'),
        LegalPoint(
            body:
                'অ্যাপটি বিনামূল্যে ব্যবহারযোগ্য। ভবিষ্যতে প্রিমিয়াম ফিচার যোগ হতে পারে, যার জন্য আলাদাভাবে জানানো হবে।'),
      ],
      Lang.en: [
        LegalPoint(
            body:
                'Amal Tracker is a personal worship tracking app. It helps users record daily deeds, earn points and participate in leaderboards.'),
        LegalPoint(
            body:
                'The app is free to use. Premium features may be added in future and communicated separately.'),
      ],
    },
  ),
  LegalSection(
    icon: '👤',
    title: {
      Lang.bn: 'অ্যাকাউন্ট ও দায়িত্ব',
      Lang.en: 'Account & Responsibility'
    },
    points: {
      Lang.bn: [
        LegalPoint(
            body:
                'অ্যাকাউন্ট নিবন্ধনের জন্য আপনার বয়স কমপক্ষে ১৩ বছর হতে হবে।'),
        LegalPoint(
            body:
                'আপনার অ্যাকাউন্টের নিরাপত্তা আপনার দায়িত্ব। পাসওয়ার্ড কারো সাথে শেয়ার করবেন না।'),
        LegalPoint(
            body: 'একজন ব্যক্তি একটিমাত্র অ্যাকাউন্ট ব্যবহার করতে পারবেন।'),
        LegalPoint(
            body: 'আপনার দেওয়া তথ্য সঠিক ও সর্বশেষ রাখা আপনার দায়িত্ব।'),
      ],
      Lang.en: [
        LegalPoint(
            body: 'You must be at least 13 years old to register an account.'),
        LegalPoint(
            body:
                'You are responsible for your account\'s security. Do not share your password.'),
        LegalPoint(body: 'One person may use only one account.'),
        LegalPoint(
            body:
                'It is your responsibility to keep your provided information accurate and up to date.'),
      ],
    },
  ),
  LegalSection(
    icon: '🚫',
    title: {Lang.bn: 'নিষিদ্ধ কার্যক্রম', Lang.en: 'Prohibited Activities'},
    points: {
      Lang.bn: [
        LegalPoint(body: 'মিথ্যা বা বানোয়াট আমল তথ্য প্রবেশ করানো নিষিদ্ধ।'),
        LegalPoint(
            body:
                'অ্যাপের সিস্টেম ম্যানিপুলেট করে অন্যায়ভাবে পয়েন্ট অর্জনের চেষ্টা করা নিষিদ্ধ।'),
        LegalPoint(
            body:
                'অন্য ব্যবহারকারীকে হয়রানি বা তাদের তথ্য অনুমতি ছাড়া ব্যবহার নিষিদ্ধ।'),
        LegalPoint(
            body:
                'অ্যাপের কোড, API বা ডেটাবেজে অননুমোদিত প্রবেশের চেষ্টা নিষিদ্ধ।'),
        LegalPoint(
            body:
                'উপরোক্ত নিয়ম ভঙ্গ করলে অ্যাকাউন্ট স্থগিত বা বাতিল করা হতে পারে।'),
      ],
      Lang.en: [
        LegalPoint(
            body: 'Entering false or fabricated deed data is prohibited.'),
        LegalPoint(
            body:
                'Attempting to manipulate the app system to unfairly gain points is prohibited.'),
        LegalPoint(
            body:
                'Harassing other users or using their data without permission is prohibited.'),
        LegalPoint(
            body:
                'Unauthorized access to the app\'s code, API or database is prohibited.'),
        LegalPoint(
            body:
                'Violating the above rules may result in account suspension or termination.'),
      ],
    },
  ),
  LegalSection(
    icon: '©️',
    title: {Lang.bn: 'মেধাস্বত্ব', Lang.en: 'Intellectual Property'},
    points: {
      Lang.bn: [
        LegalPoint(
            body:
                'আমল ট্র্যাকারের লোগো, ডিজাইন, কোড ও কনটেন্টের সকল মেধাস্বত্ব আমাদের।'),
        LegalPoint(
            body:
                'আপনার নিজের আমল ডেটার মালিকানা আপনার। আমরা সেটি তৃতীয় পক্ষকে দিই না।'),
        LegalPoint(
            body: 'অ্যাপের কোনো অংশ অনুমতি ছাড়া কপি বা বিতরণ করা যাবে না।'),
      ],
      Lang.en: [
        LegalPoint(
            body:
                'All intellectual property of Amal Tracker\'s logo, design, code and content belongs to us.'),
        LegalPoint(
            body:
                'You own your personal amal data. We do not give it to third parties.'),
        LegalPoint(
            body:
                'No part of the app may be copied or distributed without permission.'),
      ],
    },
  ),
  LegalSection(
    icon: '⚖️',
    title: {Lang.bn: 'দায় সীমাবদ্ধতা', Lang.en: 'Limitation of Liability'},
    points: {
      Lang.bn: [
        LegalPoint(
            body:
                'অ্যাপ ব্যবহারের ফলে কোনো ধর্মীয় বা আধ্যাত্মিক লক্ষ্য অর্জন না হলে আমরা দায়ী নই — এটি শুধু একটি সহায়ক টুল।'),
        LegalPoint(
            body:
                'ইন্টারনেট সংযোগ সমস্যা বা সার্ভার ডাউনটাইমের কারণে ডেটা সাময়িকভাবে অনুপলব্ধ হতে পারে।'),
        LegalPoint(
            body:
                'আমরা ডেটা ব্যাকআপের সর্বোচ্চ চেষ্টা করি, তবে কোনো প্রযুক্তিগত দুর্ঘটনায় ডেটা হারানোর জন্য সম্পূর্ণ দায়বদ্ধ নই।'),
      ],
      Lang.en: [
        LegalPoint(
            body:
                'We are not liable if religious or spiritual goals are not achieved — this is only a helper tool.'),
        LegalPoint(
            body:
                'Data may be temporarily unavailable due to internet issues or server downtime.'),
        LegalPoint(
            body:
                'We make every effort to back up data, but are not fully liable for data loss due to technical incidents.'),
      ],
    },
  ),
  LegalSection(
    icon: '🔄',
    title: {Lang.bn: 'শর্ত পরিবর্তন', Lang.en: 'Changes to Terms'},
    points: {
      Lang.bn: [
        LegalPoint(body: 'আমরা যেকোনো সময় এই শর্তাবলী আপডেট করতে পারি।'),
        LegalPoint(
            body:
                'উল্লেখযোগ্য পরিবর্তন হলে অ্যাপের ভেতর নোটিফিকেশনের মাধ্যমে ৭ দিন আগে জানানো হবে।'),
        LegalPoint(
            body:
                'পরিবর্তনের পর অ্যাপ ব্যবহার অব্যাহত রাখলে নতুন শর্তে সম্মতি দেওয়া হয়েছে বলে গণ্য হবে।'),
      ],
      Lang.en: [
        LegalPoint(body: 'We may update these terms at any time.'),
        LegalPoint(
            body:
                'For significant changes, you will be notified via in-app notification 7 days in advance.'),
        LegalPoint(
            body:
                'Continued use of the app after changes constitutes agreement to the new terms.'),
      ],
    },
  ),
];
