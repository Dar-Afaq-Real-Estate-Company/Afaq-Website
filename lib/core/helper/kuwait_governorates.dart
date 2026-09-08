/// خريطة محافظات الكويت ← مناطقها، تُستخدم لتجميع قائمة المناطق
/// (اللي تجي من الأدمن/الـ API) تحت محافظتها الصحيحة بدل عرضها كقائمة
/// مسطحة. أي منطقة موجودة بالنظام وما تطابق قائمة معروفة تروح تلقائيًا
/// تحت محافظة "أخرى".
const Map<String, List<String>> kuwaitGovernorateAreas = {
  'العاصمة': [
    'مدينة الكويت', 'دسمان', 'الشرق', 'المرقاب', 'الصالحية', 'الصالحيه', 'القبلة',
    'الوطية', 'قرطبة', 'الروضة', 'الروضه', 'الدعية', 'الشميساني', 'المنصورية',
    'الفيحاء', 'كيفان', 'خالدية', 'العديلية', 'النزهة', 'اليرموك',
    'القادسية', 'الدسمة', 'بنيد القار', 'الدوحة', 'الصليبيخات', 'الصليبخات',
    'الشويخ', 'الشويخ الصناعية', 'الجزيرة', 'الري', 'جزيرة فيلكا',
    'الصوابر', 'الشامية', 'غرناطة', 'جنوب السرة', 'السرة', 'النهضة',
    'مدينة جابر الأحمد', 'جابر الاحمد', 'قصر السيف', 'جبلة',
  ],
  'حولي': [
    'حولي', 'السالمية', 'السالميه', 'الجابرية', 'مشرف', 'الرميثية', 'بيان',
    'البيان', 'سلوى', 'الشعب', 'حطين', 'ميدان حولي', 'النقرة',
    'الزهراء', 'ضاحية عبدالله السالم', 'الشهداء', 'مبارك العبدالله الجابر',
    'مبارك العبد الله (غرب مشرف)', 'غرب مشرف', 'السلام',
  ],
  'الفروانية': [
    'الفروانية', 'الفروانيه', 'خيطان', 'أبرق خيطان', 'جليب الشيوخ', 'جليب الشويخ',
    'العارضية', 'العارضية الصناعية', 'الرقعي', 'الرابية', 'العمرية', 'الأندلس',
    'الرحاب', 'صباح الناصر', 'عبدالله المبارك', 'عبدالله مبارك',
    'جنوب عبدالله المبارك', 'جنوب عبدالله مبارك', 'غرب عبدالله مبارك',
    'ضاحية عبدالله المبارك', 'الضجيج', 'أشبيلية', 'الفردوس', 'كبد',
    'الشدادية', 'ريا',
  ],
  'مبارك الكبير': [
    'مبارك الكبير', 'القرين', 'القصور', 'صباح السالم', 'العدان',
    'المسايل', 'المسيلة', 'الفنيطيس', 'الفنيطاس', 'أبو الحصانية',
    'ضاحية أبو الحصانية', 'أبو فطيرة', 'غرب أبو فطيرة', 'ضاحية أبو فطيرة',
    'صباح الأحمد', 'الوفرة السكنية',
  ],
  'الأحمدي': [
    'الأحمدي', 'مدينة الأحمدي', 'الفحيحيل', 'المهبولة', 'المهبوله', 'الظهر',
    'الرقة', 'المنقف', 'أبو حليفة', 'الصباحية', 'العقيلة', 'الفنطاس', 'هدية',
    'الزور', 'الشعيبة', 'الوفرة', 'الوفرة الزراعية', 'النويصيب',
    'الخيران', 'ميناء عبدالله', 'أم الهيمان', 'الظفير', 'الرميلة',
    'المقوع', 'جابر العلي', 'جابر العلى', 'فهد الأحمد',
  ],
  'الجهراء': [
    'الجهراء', 'الجهراء القديمة', 'الجهراء الصناعية', 'العبدلي', 'النعيم',
    'القصر', 'تيماء', 'الصليبية', 'الصليبية الصناعية', 'الواحة', 'النسيم',
    'أمغرة', 'كاظمة', 'الروضتين', 'الصبية', 'الشقايا', 'المطلاع',
    'بر الجهراء', 'سعد العبدالله', 'السالمي', 'القيروان',
    'جزيرة بوبيان', 'جزيرة وربة',
  ],
};

/// الاسم الإنجليزي للمحافظات (نفس مفاتيح kuwaitGovernorateAreas بالعربي)
const Map<String, String> _governorateNamesEn = {
  'العاصمة': 'Capital',
  'حولي': 'Hawally',
  'الفروانية': 'Farwaniya',
  'مبارك الكبير': 'Mubarak Al-Kabeer',
  'الأحمدي': 'Ahmadi',
  'الجهراء': 'Jahra',
  'أخرى': 'Other',
};

/// الاسم الإنجليزي لكل منطقة (نفس القيم الموجودة بـ kuwaitGovernorateAreas)
const Map<String, String> _areaNamesEn = {
  'مدينة الكويت': 'Kuwait City', 'دسمان': 'Dasman', 'الشرق': 'Sharq',
  'المرقاب': 'Mirqab', 'الصالحية': 'Salhiya', 'الصالحيه': 'Salhiya',
  'القبلة': 'Qibla', 'الوطية': 'Watiya', 'قرطبة': 'Qortuba',
  'الروضة': 'Rawda', 'الروضه': 'Rawda', 'الدعية': 'Daiya',
  'الشميساني': 'Shumaisani', 'المنصورية': 'Mansouriya', 'الفيحاء': 'Faiha',
  'كيفان': 'Kaifan', 'خالدية': 'Khaldiya', 'العديلية': 'Adailiya',
  'النزهة': 'Nuzha', 'اليرموك': 'Yarmouk', 'القادسية': 'Qadsiya',
  'الدسمة': 'Dasma', 'بنيد القار': 'Bneid Al-Qar', 'الدوحة': 'Doha',
  'الصليبيخات': 'Sulaibikhat', 'الصليبخات': 'Sulaibikhat', 'الشويخ': 'Shuwaikh',
  'الشويخ الصناعية': 'Shuwaikh Industrial', 'الجزيرة': 'Jazeera',
  'الري': 'Ray', 'جزيرة فيلكا': 'Failaka Island', 'الصوابر': 'Sawaber',
  'الشامية': 'Shamiya', 'غرناطة': 'Granada', 'جنوب السرة': 'South Surra',
  'السرة': 'Surra', 'النهضة': 'Nahda', 'مدينة جابر الأحمد': 'Jaber Al-Ahmad City',
  'جابر الاحمد': 'Jaber Al-Ahmad', 'قصر السيف': 'Qasr Al-Saif', 'جبلة': 'Jibla',
  'حولي': 'Hawally', 'السالمية': 'Salmiya', 'السالميه': 'Salmiya',
  'الجابرية': 'Jabriya', 'مشرف': 'Mishref', 'الرميثية': 'Rumaithiya',
  'بيان': 'Bayan', 'البيان': 'Bayan', 'سلوى': 'Salwa', 'الشعب': 'Shaab',
  'حطين': 'Hitteen', 'ميدان حولي': 'Maidan Hawally', 'النقرة': 'Nuqra',
  'الزهراء': 'Zahra', 'ضاحية عبدالله السالم': 'Abdullah Al-Salem Suburb',
  'الشهداء': 'Shohada', 'مبارك العبدالله الجابر': 'Mubarak Al-Abdullah Al-Jaber',
  'مبارك العبد الله (غرب مشرف)': 'Mubarak Al-Abdullah (West Mishref)',
  'غرب مشرف': 'West Mishref', 'السلام': 'Salam',
  'الفروانية': 'Farwaniya', 'الفروانيه': 'Farwaniya', 'خيطان': 'Khaitan',
  'أبرق خيطان': 'Abraq Khaitan', 'جليب الشيوخ': 'Jleeb Al-Shuyoukh',
  'جليب الشويخ': 'Jleeb Al-Shuyoukh', 'العارضية': 'Ardiya',
  'العارضية الصناعية': 'Ardiya Industrial', 'الرقعي': 'Riggae',
  'الرابية': 'Rabiya', 'العمرية': 'Omariya', 'الأندلس': 'Andalous',
  'الرحاب': 'Rehab', 'صباح الناصر': 'Sabah Al-Naser',
  'عبدالله المبارك': 'Abdullah Al-Mubarak', 'عبدالله مبارك': 'Abdullah Al-Mubarak',
  'جنوب عبدالله المبارك': 'South Abdullah Al-Mubarak',
  'جنوب عبدالله مبارك': 'South Abdullah Al-Mubarak',
  'غرب عبدالله مبارك': 'West Abdullah Al-Mubarak',
  'ضاحية عبدالله المبارك': 'Abdullah Al-Mubarak Suburb',
  'الضجيج': 'Dajeej', 'أشبيلية': 'Ishbiliya', 'الفردوس': 'Firdous',
  'كبد': 'Kabd', 'الشدادية': 'Shdadiya', 'ريا': 'Riya',
  'مبارك الكبير': 'Mubarak Al-Kabeer', 'القرين': 'Qurain',
  'القصور': 'Qusour', 'صباح السالم': 'Sabah Al-Salem', 'العدان': 'Adan',
  'المسايل': 'Masayel', 'المسيلة': 'Masayel', 'الفنيطيس': 'Funaitees',
  'الفنيطاس': 'Funaitees', 'أبو الحصانية': 'Abu Al-Hasaniya',
  'ضاحية أبو الحصانية': 'Abu Al-Hasaniya Suburb', 'أبو فطيرة': 'Abu Fatira',
  'غرب أبو فطيرة': 'West Abu Fatira', 'ضاحية أبو فطيرة': 'Abu Fatira Suburb',
  'صباح الأحمد': 'Sabah Al-Ahmad', 'الوفرة السكنية': 'Wafra Residential',
  'الأحمدي': 'Ahmadi', 'مدينة الأحمدي': 'Ahmadi City', 'الفحيحيل': 'Fahaheel',
  'المهبولة': 'Mahboula', 'المهبوله': 'Mahboula', 'الظهر': 'Dhaher',
  'الرقة': 'Riqqa', 'المنقف': 'Mangaf', 'أبو حليفة': 'Abu Halifa',
  'الصباحية': 'Sabahiya', 'العقيلة': 'Egaila', 'الفنطاس': 'Fintas',
  'هدية': 'Hadiya', 'الزور': 'Zour', 'الشعيبة': 'Shuaiba',
  'الوفرة': 'Wafra', 'الوفرة الزراعية': 'Wafra Agricultural',
  'النويصيب': 'Nuwaiseeb', 'الخيران': 'Khairan', 'ميناء عبدالله': 'Mina Abdullah',
  'أم الهيمان': 'Umm Al-Haiman', 'الظفير': 'Dhafeer', 'الرميلة': 'Rumaila',
  'المقوع': 'Maqwa', 'جابر العلي': 'Jaber Al-Ali', 'جابر العلى': 'Jaber Al-Ali',
  'فهد الأحمد': 'Fahad Al-Ahmad',
  'الجهراء': 'Jahra', 'الجهراء القديمة': 'Old Jahra',
  'الجهراء الصناعية': 'Jahra Industrial', 'العبدلي': 'Abdali',
  'النعيم': 'Naeem', 'القصر': 'Qasr', 'تيماء': 'Taima',
  'الصليبية': 'Sulaibiya', 'الصليبية الصناعية': 'Sulaibiya Industrial',
  'الواحة': 'Waha', 'النسيم': 'Naseem', 'أمغرة': 'Umghara',
  'كاظمة': 'Kadhma', 'الروضتين': 'Rawdatain', 'الصبية': 'Subiya',
  'الشقايا': 'Shqaya', 'المطلاع': 'Mutlaa', 'بر الجهراء': 'Bur Jahra',
  'سعد العبدالله': 'Saad Al-Abdullah', 'السالمي': 'Salmi',
  'القيروان': 'Qairawan', 'جزيرة بوبيان': 'Bubiyan Island',
  'جزيرة وربة': 'Warba Island',
};

/// نص عرض المنطقة/المحافظة حسب اللغة الحالية (يرجع الاسم الإنجليزي لو
/// موجود، وإلا يرجع الاسم العربي كما هو - القيمة الفعلية المرسلة/المخزّنة
/// بالفلترة تبقى عربي دايمًا، هذا للعرض فقط)
final Map<String, String> _normalizedAreaNamesEn = {
  for (final entry in _areaNamesEn.entries) _normalizeArabic(entry.key): entry.value,
};

String areaLabel(String area, String lang) {
  if (lang == 'ar') return area;
  return _normalizedAreaNamesEn[_normalizeArabic(area)] ?? area;
}

String governorateLabel(String governorate, String lang) {
  if (lang == 'ar') return governorate;
  return _governorateNamesEn[governorate] ?? governorate;
}

/// توحيد الحروف المتقاربة إملائيًا (ة/ه، أ/إ/آ/ا) عشان مطابقة المناطق
/// تشتغل بغض النظر عن اختلاف طريقة الكتابة بين الإعلانات المختلفة.
String _normalizeArabic(String input) {
  return input
      .trim()
      .replaceAll('ة', 'ه')
      .replaceAll(RegExp(r'[أإآ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp(r'\s+'), ' ');
}

/// يبني خريطة (محافظة ← مناطقها الموجودة فعليًا بالقائمة الممررة) من
/// قائمة مسطحة، مع تجميع أي منطقة غير معروفة تحت "أخرى".
Map<String, List<String>> groupRegionsByGovernorate(List<String> regions) {
  final Map<String, List<String>> result = {
    for (final gov in kuwaitGovernorateAreas.keys) gov: [],
  };
  final List<String> others = [];

  for (final region in regions) {
    final normalizedRegion = _normalizeArabic(region);
    String? matchedGov;
    for (final entry in kuwaitGovernorateAreas.entries) {
      if (entry.value.any((a) => _normalizeArabic(a) == normalizedRegion)) {
        matchedGov = entry.key;
        break;
      }
    }
    if (matchedGov != null) {
      result[matchedGov]!.add(region);
    } else {
      others.add(region);
    }
  }

  result.removeWhere((key, value) => value.isEmpty);
  if (others.isNotEmpty) result['أخرى'] = others;
  return result;
}


/// المحافظة اللي تنتمي لها منطقة معيّنة (تُستخدم لعرض "المحافظة — المنطقة")
String governorateOf(String region) {
  final target = _normalizeArabic(region);
  for (final entry in kuwaitGovernorateAreas.entries) {
    if (entry.value.any((a) => _normalizeArabic(a) == target)) return entry.key;
  }
  return 'أخرى';
}

/// نص العرض: "المحافظة — المنطقة" (بلغة معيّنة - افتراضيًا عربي للتوافق
/// مع الاستخدامات القديمة اللي ما تمرر لغة)
String regionWithGovernorate(String region, [String lang = 'ar']) {
  if (region.trim().isEmpty) return '';
  return '${governorateLabel(governorateOf(region), lang)} — ${areaLabel(region, lang)}';
}
