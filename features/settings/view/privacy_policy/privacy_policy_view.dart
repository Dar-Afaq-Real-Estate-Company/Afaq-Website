import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  static const String _fullText = '''
مقدمة قانونية

يُعد استخدامك لتطبيق "افاق" (المشار إليه فيما بعد بـ "التطبيق") بمثابة إقرار صريح وموافقة قانونية غير مشروطة على جميع البنود الواردة في هذه الوثيقة.

أولاً: سياسة الخصوصية وحماية البيانات (Privacy Policy)

1. جمع ومعالجة البيانات:
البيانات التعريفية: نلتزم بجمع البيانات اللازمة لتقديم الخدمة فقط (الاسم، الهوية الرقمية، البريد الإلكتروني، أرقام التواصل).

الموقع الجغرافي: يتم استخدام تقنية GPS لتقديم خدمات البحث والخرائط الهندسية، ويتم التعامل مع هذه البيانات بسرية تامة.

أمن المعلومات: نستخدم بروتوكولات تشفير متطورة (SSL/AES) لحماية البيانات من الاختراق أو الوصول غير المصرح به.

2. مشاركة البيانات:
لا يتم بيع بيانات المستخدمين لأي طرف ثالث لأغراض تسويقية. يتم مشاركة البيانات فقط مع مزودي الخدمة (شركات المقاولات، المكاتب الهندسية، شركات العقارية) بناءً على طلب المستخدم المباشر للاستشارة أو التواصل.

ثانياً: شروط استخدام الخدمات (لمزودي الخدمة والمستخدمين)

1. الأهلية القانونية للمعلنين: يقر مزود الخدمة (شركة عقارية، ملاك عقار، مسوقين عقاريين، مكتب هندسي، شركة مقاولات، فنادق... إلى آخره) بأنه كيان مرخص قانونًا بموجب القوانين الكويتية، ويتحمل كامل المسؤولية عن صحة المستندات والتراخيص المرفوعة على المنصة.

يقر المستخدم بأن أي معلومات غير صحيحة يقوم بإدخالها (خاصة من قبل الشركات والمقاولين) تقع تحت مسؤوليته الجنائية والمدنية الكاملة أمام الجهات المختصة، ولا يتحمل التطبيق أي مسؤولية عن تزييف البيانات من قبل الغير.

2. محتوى الإعلانات: يلتزم المعلن بتقديم صور واقعية وبيانات دقيقة للخدمة. يُحظر نشر أي محتوى مضلل أو منتهك لحقوق الغير، ولإدارة التطبيق الحق في حذف أي إعلان يثبت عدم صحته دون إشعار مسبق.

لا يتحمل التطبيق أي مسؤولية عن صحة أو مصداقية الإعلانات المنشورة من قبل المستخدمين.

3. استقلال العلاقة التعاقدية: تطبيق "افاق" هو منصة تقنية وسيطة فقط. أي اتفاقيات تعاقدية تنشأ بين المستخدم ومزود الخدمة (مثل عقود بناء أو استشارات هندسية) هي علاقة ثنائية مستقلة، ولا يُعد التطبيق طرفًا فيها ولا يتحمل أي مسؤولية عن جودة التنفيذ أو الإخلال بالالتزامات.

ثالثاً: مادة إخلاء المسؤولية

1. الطبيعة الاسترشادية: يقر المستخدم بأن جميع التقييمات السعرية والتحليلات اللحظية لأسعار العقار في الكويت هي بيانات استرشادية استنتاجية بناءً على خوارزميات ذكاء اصطناعي.

2. نفي الضمان: لا تُعتبر هذه التقييمات تثمينًا رسميًا أو سندًا قانونيًا للبيع والشراء. تخلي إدارة التطبيق مسؤوليتها عن أي تفاوت بين التقييم البرمجي والسعر السوقي الواقعي، وتؤكد أن القرار الاستثماري يقع تحت مسؤولية المستخدم بالكامل.

3. يُعتبر تطبيق "افاق" منصة إعلان ووساطة، ولا يحق الرجوع إليه قانونيًا بأي نوع من تعويض مدني وتجاري أو أي إخلال بعقد يُبرم بين المستخدم وطرف آخر.

4. لا يحق للمستخدم المطالبة بأي مبالغ مالية بعد الاستفادة من خدمة داخل منصة التطبيق.

5. لا تضمن الشركة استمرار المنصة دون انقطاع أو خلوها من الأخطاء التقنية، وتخلي مسؤوليتها عن أي خسائر ناتجة عن مشاكل تقنية خارجة عن إرادتها.

رابعاً: حقوق الملكية الفكرية

جميع المحتويات البرمجية، الفلاتر الذكية، خوارزميات التقييم، الشعارات، والتصاميم هي ملكية حصرية لشركة "دار افاق العقارية". يُمنع منعًا باتًا استنساخ أو هندسة عكسية أو اقتباس أي جزء من التطبيق لأغراض تجارية دون إذن خطي مسبق.

خامساً: حقوق المستخدم (السيطرة والتحكم)

بموجب هذه السياسة، يمتلك المستخدم الحقوق التالية:

1. حق الوصول والتصحيح: الاطلاع على بياناته وتحديثها في أي وقت.

2. حق المحو (الحق في النسيان): طلب حذف حسابه وكافة بياناته الشخصية من خوادمنا، ما لم يتعارض ذلك مع التزامات قانونية قائمة.

3. لا يجوز التنازل عن حقوق الحساب أو تفويض الغير بالتمثيل دون موافقة مكتوبة من الشركة.

4. حق سحب الموافقة: يحق إيقاف تتبع الموقع أو إلغاء الاشتراك بين الطرفين بإشعار خطي للطرف الآخر قبل 30 يوم عمل على الأقل. وتحتفظ الشركة بحق إنهاء الحساب فورًا دون إشعار في حال مخالفة أي من الشروط والأحكام.

سادساً: التعديلات على السياسة

تمتلك إدارة تطبيق "افاق" الحق في تعديل هذه السياسة دوريًا لمواكبة التطورات التشريعية والتقنية دون إشعار مسبق. ويُعتبر استمرار استخدامك للتطبيق بعد نشر التعديلات موافقة ضمنية عليها.

سابعاً: النزاعات والقانون الواجب التطبيق

تخضع هذه الاتفاقية وتُفسر وفقًا لقوانين دولة الكويت. وفي حال نشوب أي نزاع قانوني، تختص محاكم الكويت (بجميع درجاتها) حصريًا بالنظر في النزاع.

إقرار المستخدم

بالنقر على "موافق" أو الاستمرار في استخدام التطبيق، فإنك تقر بأنك قرأت وفهمت كافة البنود أعلاه، وتوافق على الالتزام بها قانونًا.
''';

  static const String _fullTextEn = '''
Legal Introduction

Your use of the "Afaq" application (hereinafter "the App") constitutes an explicit acknowledgment and unconditional legal consent to all the terms contained in this document.

First: Privacy Policy and Data Protection

1. Data Collection and Processing:
Identifying Data: We are committed to collecting only the data necessary to provide the service (name, civil ID, email, contact numbers).

Geographic Location: GPS technology is used to provide search and engineering map services, and this data is handled with full confidentiality.

Information Security: We use advanced encryption protocols (SSL/AES) to protect data from breach or unauthorized access.

2. Data Sharing:
User data is not sold to any third party for marketing purposes. Data is shared only with service providers (contracting companies, engineering offices, real estate companies) based on the user's direct request for consultation or communication.

Second: Terms of Service (for Service Providers and Users)

1. Legal Eligibility of Advertisers: The service provider (real estate company, property owner, real estate marketer, engineering office, contracting company, hotels, etc.) acknowledges that it is a legally licensed entity under Kuwaiti law, and bears full responsibility for the accuracy of the documents and licenses uploaded on the platform.

The user acknowledges that any incorrect information entered (especially by companies and contractors) falls under their full criminal and civil liability before the competent authorities, and the App bears no responsibility for data falsification by others.

2. Advertisement Content: The advertiser is obligated to provide realistic photos and accurate service data. Publishing any misleading content or content that violates the rights of others is prohibited, and the App administration has the right to delete any advertisement proven to be inaccurate without prior notice.

The App bears no responsibility for the accuracy or credibility of advertisements published by users.

3. Independence of Contractual Relationship: The "Afaq" application is merely an intermediary technical platform. Any contractual agreements arising between the user and the service provider (such as construction contracts or engineering consultations) are an independent bilateral relationship, and the App is not a party to it and bears no responsibility for the quality of execution or breach of obligations.

Third: Disclaimer

1. Indicative Nature: The user acknowledges that all price valuations and real-time analyses of real estate prices in Kuwait are indicative inferential data based on artificial intelligence algorithms.

2. Disclaimer of Warranty: These valuations are not considered an official appraisal or a legal instrument for sale and purchase. The App administration disclaims responsibility for any discrepancy between the software valuation and the actual market price, and confirms that the investment decision is entirely the user's responsibility.

3. The "Afaq" application is considered an advertising and brokerage platform, and it may not be legally held liable for any type of civil or commercial compensation or any breach of contract concluded between the user and another party.

4. The user has no right to claim any financial amounts after benefiting from a service within the App platform.

5. The Company does not guarantee the platform's uninterrupted operation or freedom from technical errors, and disclaims responsibility for any losses resulting from technical issues beyond its control.

Fourth: Intellectual Property Rights

All software content, smart filters, valuation algorithms, logos, and designs are the exclusive property of "Dar Afaq Real Estate" company. It is strictly prohibited to reproduce, reverse-engineer, or quote any part of the App for commercial purposes without prior written permission.

Fifth: User Rights (Control and Management)

Under this policy, the user has the following rights:

1. Right of Access and Correction: To view and update their data at any time.

2. Right to Erasure (Right to be Forgotten): To request deletion of their account and all personal data from our servers, unless this conflicts with existing legal obligations.

3. Account rights may not be waived or delegated to others without written consent from the Company.

4. Right to Withdraw Consent: The right to stop location tracking or cancel the subscription between the parties with written notice to the other party at least 30 business days in advance. The Company reserves the right to terminate the account immediately without notice in case of violation of any of the terms and conditions.

Sixth: Amendments to the Policy

The "Afaq" application administration has the right to periodically amend this policy to keep pace with legislative and technical developments without prior notice. Continued use of the App after amendments are published constitutes implicit consent to them.

Seventh: Disputes and Applicable Law

This agreement is governed by and construed in accordance with the laws of the State of Kuwait. In the event of any legal dispute, the courts of Kuwait (at all levels) shall have exclusive jurisdiction to consider the dispute.

User Acknowledgment

By clicking "Agree" or continuing to use the App, you acknowledge that you have read and understood all the terms above, and agree to be legally bound by them.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'privacy_title'.tr(),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  (context.locale.languageCode == 'en' ? _fullTextEn : _fullText).trim(),
                  style: TextStyle(
                    height: 1.7,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpace(40)),
        ],
      ),
    );
  }
}
