import 'package:flutter/material.dart';

import '../../../../../../../core/resources/color_manager.dart';

class PropertyDetails {
  final String title;
  final String location;
  final String date;
  final int views;
  final String listingType;
  final String propertyType;
  final int areaSqMeters;
  final int numberOfRooms;
  final int numberOfFloors;
  final String description;
  final String agencyName;
  final String agencyDetails;
  final String agencyLogoAsset;
  final String mainImageAsset;

  PropertyDetails({
    required this.title,
    required this.location,
    required this.date,
    required this.views,
    required this.listingType,
    required this.propertyType,
    required this.areaSqMeters,
    required this.numberOfRooms,
    required this.numberOfFloors,
    required this.description,
    required this.agencyName,
    required this.agencyDetails,
    required this.agencyLogoAsset,
    required this.mainImageAsset,
  });
}

class AdsDetails extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const AdsDetails({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 18, color: Colors.blueGrey.shade700),
            ],
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class AdsDetailsScreen extends StatelessWidget {
  // Mock Data (Controller/Data Layer Simulation)
  final PropertyDetails property = PropertyDetails(
    title: 'بيت في الرميثية ٣ ادوار وسرداب',
    location: 'الرميثية',
    date: '17.11.2025',
    views: 96,
    listingType: 'للبيع',
    propertyType: 'بيت',
    areaSqMeters: 750,
    numberOfRooms: 0, // Based on the icon showing '0 غرف'
    numberOfFloors: 4, // Based on the icon showing '4 طوابق'
    description:
        'للبيع فيلا في الرميثية - ٧٥٠م زاوية سكة وارتداد - تشطيب جديد سوبر ديلوكس - ثلاثة ادوار وسرداب "شقق" - مؤجر بالكامل - يمنع الوسطاء - وادي السلام العقارية ',
    agencyName: 'وادي السلام العقارية',
    agencyDetails: 'حساب وسيط',
    agencyLogoAsset:
        'https://www.pexels.com/photo/apartment-interior-with-open-kitchen-near-table-with-chairs-6899345/', // Placeholder
    mainImageAsset:
        'https://images.pexels.com/photos/26556320/pexels-photo-26556320.jpeg', // Placeholder
  );

  AdsDetailsScreen({super.key});

  // Helper method for the status/type tags
  Widget _buildTag(String text, {MaterialColor color = Colors.blueGrey}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: color.shade800),
      ),
    );
  }

  // Helper method for the agency action buttons (call/chat)
  Widget _buildActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorManager.primary),
      ),
      child: Icon(icon, color: ColorManager.primary, size: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Ensure RTL layout
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true, // Image goes behind app bar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. MAIN IMAGE SECTION (Header)
              _buildImageHeader(context),

              // 2. MAIN DETAILS AND TAGS
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Price/Location
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '340 د.ك',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.primary,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          property.location,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Row(
                    //   children: [
                    //     Text(property.date,
                    //         style: const TextStyle(
                    //             fontSize: 12, color: Colors.grey)),
                    //     const SizedBox(width: 12),
                    //     const Icon(Icons.remove_red_eye_outlined,
                    //         color: Colors.grey, size: 14),
                    //     const SizedBox(width: 4),
                    //     Text('${property.views}',
                    //         style: const TextStyle(
                    //             fontSize: 12, color: Colors.grey)),
                    //   ],
                    // ),
                    //  const Divider(height: 30),

                    // Tags and Metrics (Area, Rooms, Floors)
                    // Row(
                    //   children: [
                    //     _buildTag(property.listingType, color: Colors.blue),
                    //     _buildTag('سكني', color: Colors.green),
                    //     _buildTag(property.propertyType, color: Colors.brown),
                    //   ],
                    // ),
                    const SizedBox(height: 16),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Area
                        // DetailsSectionHeader(
                        //   title: 'م² ',
                        //   value: '${property.areaSqMeters}',
                        //   icon: Icons.fullscreen_exit,
                        // ),
                        // Rooms (Custom icon for room count)
                        // DetailsSectionHeader(
                        //   title: 'غرف',
                        //   value: '${property.numberOfRooms}',
                        //   icon: Icons.bed_outlined,
                        // ),
                        // Floors
                        // DetailsSectionHeader(
                        //   title: 'طوابق',
                        //   value: '${property.numberOfFloors}',
                        //   icon: Icons.apartment,
                        // ),
                      ],
                    ),
                    const Divider(height: 30),

                    // 3. ABOUT PROPERTY SECTION
                    const Text(
                      'عن الاعلان',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      property.description,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    //const Divider(height: 30),
                  ],
                ),
              ),

              // 5. AGENCY FOOTER
              _buildAgencyFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(property.mainImageAsset),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay for App Name
        // Positioned(
        //   bottom: 10,
        //   right: 20,
        //   child: Text(
        //     'الحسبة', // Al-Hisba
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 28,
        //       fontWeight: FontWeight.w900,
        //       shadows: [
        //         Shadow(
        //             blurRadius: 5.0,
        //             color: Colors.black.withOpacity(0.5),
        //             offset: const Offset(2.0, 2.0))
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildAgencyFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Action Buttons
          _buildActionButton(Icons.phone),
          const SizedBox(width: 20),
          _buildActionButton(Icons.chat_bubble_outline),

          // Agency Info
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         property.agencyName,
          //         style: const TextStyle(
          //             fontSize: 16, fontWeight: FontWeight.bold),
          //       ),
          //       Text(
          //         property.agencyDetails,
          //         style: const TextStyle(fontSize: 14, color: Colors.grey),
          //       ),
          //     ],
          //   ),
          // ),

          // Agency Logo Placeholder
          // Container(
          //   width: 50,
          //   height: 50,
          //   color: Colors.grey.shade200, // Placeholder background
          //   child: const Icon(Icons.business, color: Colors.blueGrey),
          // ),
        ],
      ),
    );
  }
}
