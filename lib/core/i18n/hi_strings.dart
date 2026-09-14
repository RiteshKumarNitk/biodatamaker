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
};
