/// Hindi translations for UI copy. Keyed by the exact English string that is
/// displayed, with English as the automatic fallback for anything missing.
const Map<String, String> kHiStrings = {
  // ---- App shell / navigation ----
  'Home': 'होम',
  'My Biodatas': 'मेरे बायोडाटा',
  'Templates': 'टेम्पलेट',
  'Profile': 'प्रोफ़ाइल',
  'Settings': 'सेटिंग्स',

  // ---- Common actions ----
  'Back': 'पीछे',
  'Next': 'आगे',
  'Save': 'सेव करें',
  'Saving...': 'सेव हो रहा है...',
  'Edit': 'संपादित करें',
  'Add': 'जोड़ें',
  'Add More Fields': 'और फ़ील्ड जोड़ें',
  'Add Sibling': 'भाई-बहन जोड़ें',
  'Field Label': 'फ़ील्ड का नाम',
  'Field Value': 'फ़ील्ड की जानकारी',
  'Delete': 'हटाएँ',
  'Cancel': 'रद्द करें',
  'Remove': 'हटाएँ',
  'Preview': 'प्रीव्यू',
  'Download': 'डाउनलोड',
  'Share': 'शेयर करें',
  'Retry': 'फिर कोशिश करें',
  'Try Again': 'फिर कोशिश करें',
  'Create Biodata': 'बायोडाटा बनाएँ',
  'Please enter your full name to continue': 'आगे बढ़ने के लिए कृपया अपना पूरा नाम दर्ज करें',

  // ---- Wizard stepper ----
  'Photo': 'फ़ोटो',
  'Personal': 'व्यक्तिगत',
  'Education': 'शिक्षा',
  'Family': 'परिवार',
  'Lifestyle': 'जीवनशैली',
  'Contact': 'संपर्क',
  'Template': 'टेम्पलेट',
  'Review': 'समीक्षा',

  // ---- Wizard step headings (still shown per-step in the form; the
  // rendered biodata document itself now only ever shows 3 section
  // headings, translated just below) ----
  'Personal Details': 'व्यक्तिगत विवरण',
  'Education & Career': 'शिक्षा और करियर',
  'Lifestyle & Interests': 'जीवनशैली और रुचियाँ',
  'About Me': 'मेरे बारे में',

  // ---- Rendered document section headings (exactly 3: Education/
  // Lifestyle/Partner Preference/About Me all fold into Personal
  // Information — see biodata_renderer.dart). 'Contact Details' is already
  // defined below under the Contact/Partner step. ----
  'Personal Information': 'व्यक्तिगत जानकारी',
  'Family Details': 'पारिवारिक विवरण',

  // ---- Settings ----
  'Appearance': 'रूप-रंग',
  'Theme': 'थीम',
  'System': 'सिस्टम',
  'Light': 'लाइट',
  'Dark': 'डार्क',
  'Language': 'भाषा',
  'English': 'अंग्रेज़ी',
  'PDF Export': 'पीडीएफ़ एक्सपोर्ट',
  'Quality': 'गुणवत्ता',
  'High': 'उच्च',
  'Medium': 'मध्यम',
  'Low': 'निम्न',
  'Page Size': 'पेज का आकार',
  'Data': 'डेटा',
  'Auto Save': 'ऑटो सेव',
  'Automatically save biodata changes': 'बायोडाटा में बदलाव अपने आप सेव करें',
  'Backup': 'बैकअप',
  'Export all biodata as JSON': 'सभी बायोडाटा को JSON में निर्यात करें',
  'Restore': 'रिस्टोर',
  'Import biodata from JSON file': 'JSON फ़ाइल से बायोडाटा आयात करें',
  'About': 'ऐप के बारे में',
  'Rate App': 'ऐप को रेट करें',
  'Share App': 'ऐप शेयर करें',
  'Check out Biodata Maker app!': 'बायोडाटा मेकर ऐप ज़रूर देखें!',
  'Privacy Policy': 'गोपनीयता नीति',
  'App Version': 'ऐप वर्ज़न',
  'Backup saved to': 'बैकअप सेव हो गया',
  'Backup failed': 'बैकअप विफल',
  'Data restored successfully': 'डेटा सफलतापूर्वक रिस्टोर हो गया',
  'Restore failed': 'रिस्टोर विफल',

  // ---- Personal step ----
  'Full Name *': 'पूरा नाम *',
  'Gender': 'लिंग',
  'Marital Status': 'वैवाहिक स्थिति',
  'Date of Birth': 'जन्म तिथि',
  'Place of Birth': 'जन्म स्थान',
  'Age': 'आयु',
  'Height': 'कद',
  'Complexion': 'रंग-रूप',
  'Weight': 'वज़न',
  'Blood Group': 'ब्लड ग्रुप',
  'Mother Tongue': 'मातृभाषा',
  'Languages Known': 'जानी जाने वाली भाषाएँ',
  'Religion': 'धर्म',
  'Caste / Community': 'जाति / समुदाय',
  'Sub-caste': 'उपजाति',
  'Gotra': 'गोत्र',
  'Rashi': 'राशि',
  'Nakshatra': 'नक्षत्र',
  'Manglik Status': 'मांगलिक स्थिति',
  'Birth Time': 'जन्म समय',

  // ---- Education & Career step ----
  'Highest Qualification': 'उच्चतम योग्यता',
  'College / Institute': 'कॉलेज / संस्थान',
  'University / Board': 'विश्वविद्यालय / बोर्ड',
  'Occupation / Field': 'व्यवसाय / क्षेत्र',
  'Company / Organization': 'कंपनी / संगठन',
  'Designation / Job Role': 'पद / नौकरी की भूमिका',
  'Business / Firm Details (Optional)': 'व्यवसाय / फर्म का विवरण (वैकल्पिक)',
  'Annual Income': 'वार्षिक आय',
  'Professional Career': 'पेशेवर करियर',
  'Add your educational qualifications and professional career details':
      'अपनी शैक्षिक योग्यताएँ और पेशेवर करियर की जानकारी जोड़ें',

  // ---- Family step ----
  'Enter family background information': 'पारिवारिक पृष्ठभूमि की जानकारी भरें',
  'Grandparents': 'दादा-दादी',
  'Parents': 'माता-पिता',
  'Siblings': 'भाई-बहन',
  'Family Background': 'पारिवारिक पृष्ठभूमि',
  'Relationship': 'रिश्ता',
  "Sibling's Name *": 'भाई-बहन का नाम *',
  'Occupation': 'व्यवसाय',
  'Edit Sibling': 'भाई-बहन संपादित करें',
  'Unnamed sibling': 'बिना नाम का भाई-बहन',
  'Add each sibling individually with their name, occupation and marital status.':
      'हर भाई-बहन का नाम, व्यवसाय और वैवाहिक स्थिति अलग-अलग जोड़ें।',

  // ---- Lifestyle step ----
  'Enter lifestyle preferences, hobbies and a short bio':
      'जीवनशैली की पसंद, शौक और एक छोटा परिचय भरें',
  'Food Preference': 'भोजन की पसंद',
  'Smoking': 'धूम्रपान',
  'Drinking': 'शराब सेवन',
  'Hobbies & Interests': 'शौक और रुचियाँ',
  'Personality': 'व्यक्तित्व',

  // ---- Contact / Partner step ----
  'Contact & Partner Preference': 'संपर्क और जीवनसाथी की पसंद',
  'Contact Details': 'संपर्क विवरण',
  'Partner Preferences': 'जीवनसाथी की पसंद',
  'Enter contact info, partner expectations, or add custom fields':
      'संपर्क जानकारी, जीवनसाथी की अपेक्षाएँ भरें या कस्टम फ़ील्ड जोड़ें',

  // ---- Photo step ----
  'Profile Photo': 'प्रोफ़ाइल फ़ोटो',
  'Additional Photos': 'अतिरिक्त फ़ोटो',
  'Add Photo': 'फ़ोटो जोड़ें',
  'Tap to add': 'जोड़ने के लिए टैप करें',
  'Camera': 'कैमरा',
  'Gallery': 'गैलरी',
  'Set as profile': 'प्रोफ़ाइल के रूप में सेट करें',
  'Failed to pick image': 'फ़ोटो चुनना विफल',

  // ---- Template step ----
  'Choose Template': 'टेम्पलेट चुनें',
  'Choose a Template': 'एक टेम्पलेट चुनें',
  'Select a design template for your biodata':
      'अपने बायोडाटा के लिए एक डिज़ाइन टेम्पलेट चुनें',
  'No templates available': 'कोई टेम्पलेट उपलब्ध नहीं है',
  'Template Store': 'टेम्पलेट स्टोर',

  // ---- Download step ----
  'Generate & Download PDF': 'PDF बनाएँ और डाउनलोड करें',
  'Export your biodata as a high quality PDF, print or share directly':
      'अपना बायोडाटा उच्च गुणवत्ता वाली PDF में निर्यात करें, प्रिंट करें या सीधे शेयर करें',
  'PDF Document': 'PDF दस्तावेज़',
  'Generating your biodata PDF...': 'आपका बायोडाटा PDF बन रहा है...',
  'Print / Save as PDF': 'प्रिंट / PDF के रूप में सेव करें',
  'Share PDF File': 'PDF फ़ाइल शेयर करें',
  'Failed to generate PDF': 'PDF बनाना विफल',
  'Failed to share': 'शेयर करना विफल',

  // ---- Review step ----
  'Review your complete marriage biodata design before generating the final PDF':
      'अंतिम PDF बनाने से पहले अपने पूरे विवाह बायोडाटा की समीक्षा करें',

  // ---- Custom fields editor ----
  'Custom Fields': 'कस्टम फ़ील्ड',
  'Add Field': 'फ़ील्ड जोड़ें',
  'Edit Field': 'फ़ील्ड संपादित करें',
  'No custom fields added yet.': 'अभी तक कोई कस्टम फ़ील्ड नहीं जोड़ा गया।',
  'Extra details shown in this section will also appear in your biodata':
      'इस अनुभाग के अतिरिक्त विवरण आपके बायोडाटा में भी दिखेंगे।',

  // ---- Home / dashboard ----
  'Hello': 'नमस्ते',
  'Welcome to Biodata Maker': 'बायोडाटा मेकर में आपका स्वागत है',
  'Get Started': 'शुरू करें',
  'Continue Draft': 'ड्राफ़्ट जारी रखें',
  'Recent Biodatas': 'हाल के बायोडाटा',
  'Last updated': 'आख़िरी अपडेट',
  'Quick Actions': 'त्वरित कार्रवाई',
  'Jump to': 'यहाँ जाएँ',
  'pending': 'लंबित',
  'Biodata Maker': 'बायोडाटा मेकर',

  // ---- My Biodatas / misc actions ----
  'Favorite': 'पसंदीदा',
  'Unfavorite': 'पसंदीदा हटाएँ',
  'Duplicate': 'डुप्लिकेट बनाएँ',
  'Archive': 'संग्रह में रखें',
  'Unarchive': 'संग्रह से हटाएँ',

  // ---- Template step ----
  'Live Preview': 'लाइव प्रीव्यू',
  'This is how your filled details will appear in the PDF':
      'आपके भरे हुए विवरण पीडीएफ़ में इसी तरह दिखेंगे।',

  // ---- Basic info sub-headings ----
  'Basic Information': 'बुनियादी जानकारी',
  'Quick select:': 'त्वरित चुनें:',
  'Religion, Community & Astrology': 'धर्म, समुदाय और ज्योतिष',
  'Optional - add only what you want to share':
      'वैकल्पिक - केवल वही जोड़ें जो आप साझा करना चाहें',
  'Optional - tap to expand': 'वैकल्पिक - विस्तार के लिए टैप करें',

  // ---- Onboarding ----
  'Create Beautiful Biodata': 'सुंदर बायोडाटा बनाएँ',
  'Make professional marriage biodatas in minutes':
      'मिनटों में पेशेवर विवाह बायोडाटा बनाएँ',
  'Choose Stunning Templates': 'शानदार टेम्पलेट चुनें',
  'Pick from premium temple and modern designs':
      'प्रीमियम मंदिर और आधुनिक डिज़ाइन में से चुनें',
  'Share with Family': 'परिवार के साथ साझा करें',
  'Download as PDF and share with potential matches':
      'पीडीएफ़ में डाउनलोड करें और संभावित रिश्तों के साथ साझा करें',
  'Skip': 'छोड़ें',

  // ---- Admin ----
  'Admin Panel': 'एडमिन पैनल',
  'Sign in to manage templates': 'टेम्पलेट प्रबंधित करने के लिए साइन इन करें',
  'Free Limit Reached': 'मुफ़्त सीमा पूरी हो गई',

  // ---- Dashboard / lists ----
  'Total': 'कुल',
  'Favorites': 'पसंदीदा',
  'Archived': 'संग्रहित',
  'Untitled': 'शीर्षकहीन',
  'Draft': 'ड्राफ़्ट',
  'just now': 'अभी',
  'Create New\nBiodata': 'नया\nबायोडाटा बनाएँ',
  'Browse\nTemplates': 'टेम्पलेट\nदेखें',
  'Create your first biodata': 'अपना पहला बायोडाटा बनाएँ',
  'Design a beautiful marriage biodata\nin minutes':
      'मिनटों में एक सुंदर विवाह बायोडाटा बनाएँ',
  'Something went wrong': 'कुछ ग़लत हो गया',
  'Search biodatas...': 'बायोडाटा खोजें...',
  'All': 'सभी',
  'Drafts': 'ड्राफ़्ट',
  'Completed': 'पूर्ण',
  'No results found': 'कोई परिणाम नहीं मिला',
  'No biodatas found': 'कोई बायोडाटा नहीं मिला',
  'Try a different search or filter': 'कोई दूसरी खोज या फ़िल्टर आज़माएँ',
  'Create your first biodata to get started':
      'शुरू करने के लिए अपना पहला बायोडाटा बनाएँ',
  'No occupation': 'व्यवसाय नहीं',
  'Delete Biodata': 'बायोडाटा हटाएँ',
  'Are you sure you want to delete this biodata?':
      'क्या आप वाकई यह बायोडाटा हटाना चाहते हैं?',
  'No templates in this category': 'इस श्रेणी में कोई टेम्पलेट नहीं है',

  // ---- Time ago (keys are the dynamic strings built at runtime) ----
  '1d ago': '1 दिन पहले',
  'h ago': 'घंटे पहले',

  // ---- Preview / export ----
  'Download PDF': 'PDF डाउनलोड करें',
  'More options': 'और विकल्प',
  'Change': 'बदलें',
  'Text Size': 'टेक्स्ट आकार',
  'Biodata not found': 'बायोडाटा नहीं मिला',
  'Preview Final PDF': 'अंतिम PDF देखें',
  'Saved to your gallery': 'आपकी गैलरी में सेव हो गया',
  'Saved to your Downloads folder': 'आपके डाउनलोड फ़ोल्डर में सेव हो गया',
  'Saved to app folder': 'ऐप फ़ोल्डर में सेव हो गया',
  'Image saved to': 'छवि सेव हो गई',
  'Failed to save image': 'छवि सेव करना विफल',

  // ---- Paywall / premium ----
  'Premium': 'प्रीमियम',
  'Go Premium': 'प्रीमियम लें',
  'Unlock all features and create beautiful biodatas':
      'सभी सुविधाएँ अनलॉक करें और सुंदर बायोडाटा बनाएँ',
  'All templates unlocked': 'सभी टेम्पलेट अनलॉक',
  'No watermark on PDF': 'PDF पर कोई वॉटरमार्क नहीं',
  'Unlimited biodatas': 'असीमित बायोडाटा',
  'Custom fields support': 'कस्टम फ़ील्ड समर्थन',
  'Monthly': 'मासिक',
  'Yearly': 'वार्षिक',
  'Lifetime': 'आजीवन',
  'Best Value': 'सर्वोत्तम मूल्य',
  'Continue': 'जारी रखें',
  'Processing...': 'प्रक्रिया जारी है...',
  'Already Premium': 'पहले से प्रीमियम',
  'Restore Purchases': 'ख़रीद पुनर्स्थापित करें',
  'Welcome to Premium!': 'प्रीमियम में आपका स्वागत है!',
  'Purchase failed': 'ख़रीद विफल',
  'You are already a Premium member!': 'आप पहले से प्रीमियम सदस्य हैं!',
  'Store unavailable. Premium is activated automatically once your purchase is processed by the store.':
      'स्टोर उपलब्ध नहीं है। स्टोर द्वारा आपकी ख़रीद प्रोसेस होते ही प्रीमियम सक्रिय हो जाएगा।',
  'Store unavailable. Connect to the internet and try again.':
      'स्टोर उपलब्ध नहीं है। इंटरनेट से कनेक्ट होकर फिर से कोशिश करें।',
  'This template is Premium. Upgrade to unlock all designs.':
      'यह टेम्पलेट प्रीमियम है। सभी डिज़ाइन अनलॉक करने के लिए अपग्रेड करें।',
  'Upgrade': 'अपग्रेड करें',
  'PRO': 'प्रो',

  // ---- Profile ----
  'Edit Profile': 'प्रोफ़ाइल संपादित करें',
  'Name': 'नाम',
  'Email': 'ईमेल',
  'Phone': 'फ़ोन',
  'Name is required': 'नाम आवश्यक है',
  'Enter a valid email': 'मान्य ईमेल दर्ज करें',
  'Enter a valid phone number': 'मान्य फ़ोन नंबर दर्ज करें',
  'Total Biodatas': 'कुल बायोडाटा',
  'Downloads': 'डाउनलोड',
  'My Subscription': 'मेरी सदस्यता',
  'Logout': 'लॉगआउट',
  'Are you sure you want to sign out?': 'क्या आप वाकई साइन आउट करना चाहते हैं?',

  // ---- Settings ----
  'Could not open the store app': 'स्टोर ऐप नहीं खोला जा सका',

  // ---- Misc ----
  'Biodata': 'बायोडाटा',
  'Guest': 'अतिथि',
  'Please enter both email and password.': 'कृपया ईमेल और पासवर्ड दोनों दर्ज करें।',
  'Invalid email or password.': 'ईमेल या पासवर्ड ग़लत है।',
  'Admin Login': 'एडमिन लॉगिन',
  'Password': 'पासवर्ड',
};
