class AppConstants {
  AppConstants._();

  // Genders
  static const List<String> genders = ['Male', 'Female', 'Other'];

  // Marital Status
  static const List<String> maritalStatuses = [
    'Never Married',
    'Divorced',
    'Widowed',
    'Awaiting Divorce',
    'Annulled',
  ];

  // Blood Groups
  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // Religions
  static const List<String> religions = [
    'Hindu',
    'Muslim',
    'Sikh',
    'Christian',
    'Jain',
    'Buddhist',
    'Parsi',
    'Jewish',
    'Other',
  ];

  // Family Types
  static const List<String> familyTypes = [
    'Joint Family',
    'Nuclear Family',
  ];

  // Family Values
  static const List<String> familyValues = [
    'Traditional',
    'Moderate',
    'Liberal',
    'Orthodox',
  ];

  // Diet
  static const List<String> diets = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Egetarian',
    'Jain Vegetarian',
    'Occasionally Non-Vegetarian',
  ];

  // Manglik Status
  static const List<String> manglikStatuses = [
    'Yes',
    'No',
    'Don\'t Know',
  ];

  // Complexion
  static const List<String> complexions = [
    'Very Fair',
    'Fair',
    'Wheatish',
    'Dark',
    'Very Dark',
  ];

  // Template Categories
  static const List<String> templateCategories = [
    'Traditional',
    'Modern',
    'Luxury',
    'Royal',
    'Minimal',
    'Professional',
    'Regional',
    'Festival',
  ];

  // Religion-specific template tags
  static const Map<String, List<String>> religionTemplates = {
    'Hindu': ['Royal Rajput', 'Mandala', 'Temple', 'Lotus', 'Traditional', 'Gold', 'Red', 'Cream'],
    'Muslim': ['Premium Nikah', 'Emerald', 'Luxury Green', 'Minimal', 'White Gold'],
    'Sikh': ['Royal Blue', 'Gold', 'Punjabi', 'Traditional'],
    'Christian': ['White Floral', 'Elegant', 'Blue Gold'],
    'Jain': ['Minimal White', 'Luxury Gold'],
  };

  // Regional templates
  static const List<String> regionalTemplates = [
    'Gujarati',
    'Marathi',
    'Punjabi',
    'Rajasthani',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Bengali',
    'Odia',
    'UP',
    'Bihari',
    'Modern Urban',
  ];
}
