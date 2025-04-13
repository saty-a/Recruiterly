import 'package:cloud_firestore/cloud_firestore.dart';

class DummyData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDummyData() async {
    // Create dummy recruiters
    await _createDummyRecruiters();
    
    // Create dummy candidates
    await _createDummyCandidates();
    
    // Create dummy job postings
    await _createDummyJobPostings();
  }

  Future<void> _createDummyRecruiters() async {
    final List<Map<String, dynamic>> recruiters = [
      {
        'uid': 'recruiter1',
        'email': 'john.doe@techcompany.com',
        'name': 'John Doe',
        'role': 'recruiter',
        'profileImage': 'https://randomuser.me/api/portraits/men/1.jpg',
        'company': 'Tech Solutions Inc.',
        'position': 'Senior Recruiter',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'uid': 'recruiter2',
        'email': 'sarah.smith@innovatecorp.com',
        'name': 'Sarah Smith',
        'role': 'recruiter',
        'profileImage': 'https://randomuser.me/api/portraits/women/2.jpg',
        'company': 'Innovate Corp',
        'position': 'Talent Acquisition Manager',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'uid': 'recruiter3',
        'email': 'michael.brown@startupco.com',
        'name': 'Michael Brown',
        'role': 'recruiter',
        'profileImage': 'https://randomuser.me/api/portraits/men/3.jpg',
        'company': 'Startup Co',
        'position': 'Tech Recruiter',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var recruiter in recruiters) {
      await _firestore.collection('users').doc(recruiter['uid']).set(recruiter);
    }
  }

  Future<void> _createDummyCandidates() async {
    final List<Map<String, dynamic>> candidates = [
      {
        'uid': 'candidate1',
        'email': 'alex.johnson@gmail.com',
        'name': 'Alex Johnson',
        'role': 'candidate',
        'profileImage': 'https://randomuser.me/api/portraits/men/4.jpg',
        'currentRole': 'Senior Software Engineer',
        'totalExperience': 5,
        'noticePeriod': 30,
        'currentCtc': 120000,
        'expectedCtc': 150000,
        'skills': ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'uid': 'candidate2',
        'email': 'emma.wilson@gmail.com',
        'name': 'Emma Wilson',
        'role': 'candidate',
        'profileImage': 'https://randomuser.me/api/portraits/women/5.jpg',
        'currentRole': 'UI/UX Designer',
        'totalExperience': 3,
        'noticePeriod': 15,
        'currentCtc': 90000,
        'expectedCtc': 110000,
        'skills': ['Figma', 'Adobe XD', 'UI Design', 'Prototyping', 'User Research'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'uid': 'candidate3',
        'email': 'david.chen@gmail.com',
        'name': 'David Chen',
        'role': 'candidate',
        'profileImage': 'https://randomuser.me/api/portraits/men/6.jpg',
        'currentRole': 'Product Manager',
        'totalExperience': 4,
        'noticePeriod': 60,
        'currentCtc': 130000,
        'expectedCtc': 160000,
        'skills': ['Product Strategy', 'Agile', 'User Stories', 'Data Analysis', 'Stakeholder Management'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'uid': 'candidate4',
        'email': 'sophia.martinez@gmail.com',
        'name': 'Sophia Martinez',
        'role': 'candidate',
        'profileImage': 'https://randomuser.me/api/portraits/women/7.jpg',
        'currentRole': 'Full Stack Developer',
        'totalExperience': 6,
        'noticePeriod': 30,
        'currentCtc': 140000,
        'expectedCtc': 180000,
        'skills': ['React', 'Node.js', 'MongoDB', 'AWS', 'Docker'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'uid': 'candidate5',
        'email': 'james.taylor@gmail.com',
        'name': 'James Taylor',
        'role': 'candidate',
        'profileImage': 'https://randomuser.me/api/portraits/men/8.jpg',
        'currentRole': 'Mobile Developer',
        'totalExperience': 3,
        'noticePeriod': 15,
        'currentCtc': 95000,
        'expectedCtc': 120000,
        'skills': ['iOS', 'Swift', 'Android', 'Kotlin', 'Flutter'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var candidate in candidates) {
      await _firestore.collection('users').doc(candidate['uid']).set(candidate);
    }
  }

  Future<void> _createDummyJobPostings() async {
    final List<Map<String, dynamic>> jobPostings = [
      {
        'id': 'job1',
        'title': 'Senior Flutter Developer',
        'company': 'Tech Solutions Inc.',
        'location': 'San Francisco, CA',
        'type': 'Full-time',
        'description': 'We are looking for an experienced Flutter developer to join our team. The ideal candidate will have strong experience with Flutter, Dart, and Firebase.',
        'requirements': [
          '5+ years of experience in mobile development',
          'Strong experience with Flutter and Dart',
          'Experience with Firebase and REST APIs',
          'Good understanding of software design patterns',
          'Experience with Git and version control',
        ],
        'salary': {
          'min': 120000,
          'max': 180000,
          'currency': 'USD',
        },
        'postedBy': 'recruiter1',
        'postedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'applications': [],
      },
      {
        'id': 'job2',
        'title': 'UI/UX Designer',
        'company': 'Innovate Corp',
        'location': 'New York, NY',
        'type': 'Full-time',
        'description': 'We are seeking a talented UI/UX Designer to create amazing user experiences. The ideal candidate should have an eye for clean and artful design, possess superior UI skills and be able to translate high-level requirements into interaction flows and artifacts.',
        'requirements': [
          '3+ years of experience in UI/UX design',
          'Proficiency in Figma and Adobe XD',
          'Strong portfolio demonstrating UI/UX work',
          'Experience with user research and usability testing',
          'Knowledge of design systems and component libraries',
        ],
        'salary': {
          'min': 90000,
          'max': 130000,
          'currency': 'USD',
        },
        'postedBy': 'recruiter2',
        'postedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'applications': [],
      },
      {
        'id': 'job3',
        'title': 'Product Manager',
        'company': 'Startup Co',
        'location': 'Remote',
        'type': 'Full-time',
        'description': 'We are looking for a Product Manager to join our team. The ideal candidate will be responsible for the product planning and execution throughout the product lifecycle, including gathering and prioritizing product and customer requirements.',
        'requirements': [
          '4+ years of experience in product management',
          'Strong analytical and problem-solving skills',
          'Experience with Agile methodologies',
          'Excellent communication and stakeholder management skills',
          'Experience with data-driven decision making',
        ],
        'salary': {
          'min': 130000,
          'max': 170000,
          'currency': 'USD',
        },
        'postedBy': 'recruiter3',
        'postedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'applications': [],
      },
      {
        'id': 'job4',
        'title': 'Full Stack Developer',
        'company': 'Tech Solutions Inc.',
        'location': 'Austin, TX',
        'type': 'Full-time',
        'description': 'We are seeking a Full Stack Developer to join our team. The ideal candidate will be responsible for developing and maintaining web applications using React, Node.js, and MongoDB.',
        'requirements': [
          '5+ years of experience in full stack development',
          'Strong experience with React and Node.js',
          'Experience with MongoDB and REST APIs',
          'Knowledge of AWS and Docker',
          'Experience with Git and version control',
        ],
        'salary': {
          'min': 130000,
          'max': 190000,
          'currency': 'USD',
        },
        'postedBy': 'recruiter1',
        'postedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'applications': [],
      },
      {
        'id': 'job5',
        'title': 'Mobile Developer',
        'company': 'Innovate Corp',
        'location': 'Boston, MA',
        'type': 'Full-time',
        'description': 'We are looking for a Mobile Developer to join our team. The ideal candidate will be responsible for developing and maintaining mobile applications for iOS and Android platforms.',
        'requirements': [
          '3+ years of experience in mobile development',
          'Strong experience with iOS (Swift) and Android (Kotlin)',
          'Experience with Flutter is a plus',
          'Knowledge of mobile UI/UX best practices',
          'Experience with Git and version control',
        ],
        'salary': {
          'min': 100000,
          'max': 150000,
          'currency': 'USD',
        },
        'postedBy': 'recruiter2',
        'postedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'applications': [],
      },
    ];

    for (var job in jobPostings) {
      await _firestore.collection('job_postings').doc(job['id']).set(job);
    }
  }
} 