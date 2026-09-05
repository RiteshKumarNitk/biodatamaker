import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

/// A hardcoded, representative [Biodata] used only to preview how a template
/// will look before the user has entered any real information (template
/// store cards, bottom-sheet preview). Never persisted and never used when
/// generating a user's actual PDF.
final sampleBiodataForPreview = Biodata(
  id: 'sample',
  name: 'Aarav Sharma',
  createdAt: DateTime(2024, 1, 1),
  updatedAt: DateTime(2024, 1, 1),
  fullName: 'Aarav Sharma',
  gender: 'Male',
  dateOfBirth: '01/01/1998',
  age: '26 yrs',
  height: '5\'10"',
  religion: 'Hindu',
  maritalStatus: 'Never Married',
  qualification: 'B.Tech, Computer Science',
  occupation: 'Software Engineer',
  company: 'Tech Solutions Pvt. Ltd.',
  annualIncome: '12,00,000',
  fatherName: 'Rajesh Sharma',
  fatherOccupation: 'Business',
  motherName: 'Sunita Sharma',
  motherOccupation: 'Homemaker',
  familyType: 'Nuclear Family',
  city: 'Delhi',
  state: 'Delhi',
  country: 'India',
  mobile: '+91 98765 43210',
);
