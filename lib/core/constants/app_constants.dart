class AppConstants {
  AppConstants._();

  static const List<String> genders = [
    'Male', 'Female', 'Other', 'Prefer not to say',
  ];

  static const List<String> maritalStatuses = [
    'Never Married', 'Awaiting Divorce', 'Divorced', 'Widowed', 'Annulled',
  ];

  static const List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  static const List<String> religions = [
    'Hindu', 'Muslim', 'Sikh', 'Christian', 'Jain', 'Buddhist',
    'Parsi', 'Jewish', 'Other', 'Prefer not to say',
  ];

  /// Indian-friendly height options, every inch from 4'0" to 7'0".
  static const List<String> heights = [
    'Below 4\'0"',
    '4\'0"', '4\'1"', '4\'2"', '4\'3"', '4\'4"', '4\'5"', '4\'6"', '4\'7"',
    '4\'8"', '4\'9"', '4\'10"', '4\'11"', '5\'0"', '5\'1"', '5\'2"', '5\'3"',
    '5\'4"', '5\'5"', '5\'6"', '5\'7"', '5\'8"', '5\'9"', '5\'10"', '5\'11"',
    '6\'0"', '6\'1"', '6\'2"', '6\'3"', '6\'4"', '6\'5"', '6\'6"', '6\'7"',
    '6\'8"', '6\'9"', '6\'10"', '6\'11"', '7\'0"',
    'Above 7\'0"',
  ];

  static const List<String> complexions = [
    'Very Fair', 'Fair', 'Wheatish', 'Medium', 'Dusky', 'Dark', 'Very Dark',
    'Prefer not to say',
  ];

  static const List<String> familyTypes = [
    'Nuclear Family', 'Joint Family', 'Extended Family',
  ];

  static const List<String> familyValues = [
    'Traditional', 'Moderate', 'Liberal', 'Orthodox',
  ];

  static const List<String> familyStatuses = [
    'Middle Class', 'Upper Middle Class', 'Affluent', 'Prefer not to say',
  ];

  static const List<String> diets = [
    'Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Jain Vegetarian', 'Vegan',
    'Occasionally Non-Vegetarian', 'Other',
  ];

  static const List<String> smokingOptions = [
    'No', 'Occasionally', 'Yes', 'Prefer not to say',
  ];

  static const List<String> drinkingOptions = [
    'No', 'Occasionally', 'Yes', 'Prefer not to say',
  ];

  static const List<String> manglikStatuses = [
    'Yes', 'No', 'Partial / Anshik Manglik', 'Don\'t Know',
  ];

  /// Traditional 12 Rashis.
  static const List<String> rashis = [
    'Mesha (Aries)', 'Vrishabha (Taurus)', 'Mithuna (Gemini)',
    'Karka (Cancer)', 'Simha (Leo)', 'Kanya (Virgo)',
    'Tula (Libra)', 'Vrishchika (Scorpio)', 'Dhanu (Sagittarius)',
    'Makara (Capricorn)', 'Kumbha (Aquarius)', 'Meena (Pisces)',
  ];

  /// All 27 Nakshatras.
  static const List<String> nakshatras = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashirsha', 'Ardra',
    'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Purva Phalguni',
    'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha',
    'Jyeshtha', 'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana',
    'Dhanishta', 'Shatabhisha', 'Purva Bhadrapada', 'Uttara Bhadrapada',
    'Revati',
  ];

  static const List<String> gotraSuggestions = [
    'Kashyap', 'Bharadwaj', 'Vashishtha', 'Gautam', 'Atri', 'Vishwamitra',
    'Jamadagni', 'Agastya', 'Kaushik', 'Shandilya', 'Parashara', 'Garga',
    'Angirasa', 'Kutsa', 'Harita', 'Mudgal', 'Upamanyu', 'Kanva', 'Kapila',
    'Dhananjaya',
  ];

  static const List<String> educationLevels = [
    'High School', 'Higher Secondary / 12th', 'Diploma', 'ITI',
    'Bachelor\'s Degree', 'Master\'s Degree', 'Doctorate / Ph.D.',
    'Professional Degree', 'Other',
  ];

  static const List<String> occupationSuggestions = [
    'Private Job', 'Government / Public Sector', 'Business / Entrepreneur',
    'Self-Employed', 'Doctor', 'Engineer', 'Teacher / Professor', 'Lawyer',
    'Chartered Accountant', 'Banking / Finance', 'IT / Software',
    'Defence / Police', 'Civil Services', 'Student', 'Homemaker', 'Retired',
    'Other',
  ];

  static const List<String> relationships = [
    'Self', 'Father', 'Mother', 'Brother', 'Sister', 'Guardian', 'Other',
  ];

  static const List<String> siblingRelationships = [
    'Brother', 'Sister', 'Other',
  ];

  static const List<String> siblingMaritalStatuses = [
    'Unmarried', 'Married', 'Divorced', 'Widowed', 'Awaiting Divorce',
  ];

  static const List<String> languages = [
    'Hindi', 'English', 'Bengali', 'Telugu', 'Marathi', 'Tamil', 'Urdu',
    'Gujarati', 'Kannada', 'Malayalam', 'Odia', 'Punjabi', 'Assamese',
    'Maithili', 'Sindhi', 'Nepali', 'Konkani', 'Sanskrit', 'Bhojpuri',
    'Rajasthani', 'Haryanvi', 'Other',
  ];

  static const List<String> indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan',
    'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh',
    'Uttarakhand', 'West Bengal', 'Andaman and Nicobar Islands',
    'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu', 'Delhi',
    'Jammu and Kashmir', 'Ladakh', 'Lakshadweep', 'Puducherry',
  ];

  static const List<String> templateCategories = [
    'Traditional', 'Modern', 'Luxury', 'Royal',
    'Minimal', 'Professional', 'Regional', 'Festival',
  ];
}
