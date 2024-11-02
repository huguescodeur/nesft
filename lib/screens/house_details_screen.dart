import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nest_f/models/house.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class HouseDetailScreen extends StatelessWidget {
  final House house;

  const HouseDetailScreen({super.key, required this.house});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //     child: Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         automaticallyImplyLeading: false,
    //         expandedHeight: 300,
    //         floating: false,
    //         pinned: true,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: CarouselSlider(
    //             options: CarouselOptions(
    //               height: 300,
    //               viewportFraction: 1.0,
    //               enlargeCenterPage: false,
    //               autoPlay: true,
    //             ),
    //             items: house.images.map((imageUrl) {
    //               return Image.network(
    //                 imageUrl,
    //                 fit: BoxFit.cover,
    //                 width: double.infinity,
    //               );
    //             }).toList(),
    //           ),
    //         ),
    //       ),
    //       SliverToBoxAdapter(
    //         child: Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     '${house.price.toStringAsFixed(0)} FCFA',
    //                     style:
    //                         Theme.of(context).textTheme.headlineSmall?.copyWith(
    //                               color: Theme.of(context).primaryColor,
    //                             ),
    //                   ),
    //                   if (house.isNewConstruction)
    //                     Container(
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 8,
    //                         vertical: 4,
    //                       ),
    //                       decoration: BoxDecoration(
    //                         color: Colors.green,
    //                         borderRadius: BorderRadius.circular(4),
    //                       ),
    //                       child: const Text(
    //                         'NEW CONSTRUCTION',
    //                         style: TextStyle(color: Colors.white),
    //                       ),
    //                     ),
    //                 ],
    //               ),
    //               const SizedBox(height: 8),
    //               Text(
    //                 house.address,
    //                 style: Theme.of(context).textTheme.titleLarge,
    //               ),
    //               Text(
    //                 house.location,
    //                 style: Theme.of(context).textTheme.titleMedium,
    //               ),
    //               const SizedBox(height: 16),
    //               _buildFeatureRow(context, house),
    //               const SizedBox(height: 24),
    //               Text(
    //                 'Description',
    //                 style: Theme.of(context).textTheme.titleLarge,
    //               ),
    //               const SizedBox(height: 8),
    //               house.description.isEmpty
    //                   ? const Text("Aucune Description")
    //                   : ReadMoreText(
    //                       house.description,
    //                       trimMode: TrimMode.Line,
    //                       trimLines: 4,
    //                       colorClickableText: Colors.black,
    //                       trimCollapsedText: 'Lire plus',
    //                       trimExpandedText: 'moins',
    //                       moreStyle: const TextStyle(
    //                           fontSize: 14, fontWeight: FontWeight.bold),
    //                       lessStyle: const TextStyle(
    //                           fontSize: 14, fontWeight: FontWeight.bold),
    //                     ),
    //               // house.description.isEmpty
    //               //     ? const Text("Aucune Description")
    //               //     : Text(house.description),
    //               const SizedBox(height: 24),
    //               Text(
    //                 'Details',
    //                 style: Theme.of(context).textTheme.titleLarge,
    //               ),
    //               const SizedBox(height: 8),
    //               _buildDetailsList(context),
    //               const SizedBox(height: 24),
    //               Text(
    //                 'Comodités',
    //                 style: Theme.of(context).textTheme.titleLarge,
    //               ),
    //               const SizedBox(height: 8),
    //               _buildAmenitiesList(),
    //               const SizedBox(height: 24),
    //               _buildContactButtons(context),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ));
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: FadeIn(
                duration: const Duration(milliseconds: 800),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: true,
                  ),
                  items: house.images.map((imageUrl) {
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${house.price.toStringAsFixed(0)} FCFA',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        if (house.isNewConstruction)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NEW CONSTRUCTION',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      house.address,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      house.location,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 800),
                    child: _buildFeatureRow(context, house),
                  ),
                  const SizedBox(height: 24),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 800),
                    child: house.description.isEmpty
                        ? const Text("Aucune Description")
                        : ReadMoreText(
                            house.description,
                            trimMode: TrimMode.Line,
                            trimLines: 4,
                            colorClickableText: Colors.black,
                            trimCollapsedText: 'Lire plus',
                            trimExpandedText: 'moins',
                            moreStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            lessStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 24),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 1200),
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  FadeIn(
                    delay: const Duration(milliseconds: 1400),
                    duration: const Duration(milliseconds: 800),
                    child: _buildDetailsList(context),
                  ),
                  const SizedBox(height: 24),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 1600),
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Comodités',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1800),
                    duration: const Duration(milliseconds: 800),
                    child: _buildAmenitiesList(),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    delay: const Duration(milliseconds: 2000),
                    duration: const Duration(milliseconds: 800),
                    child: _buildContactButtons(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, House house) {
    List<Widget> features = [];

    if (house.bedrooms != 0) {
      features.add(_buildFeature(
          context, Icons.king_bed_outlined, '${house.bedrooms} chambre(s)'));
    }

    if (house.bathrooms != 0) {
      features.add(_buildFeature(
          context, Icons.bathroom_outlined, '${house.bathrooms} douche(s)'));
    }

    if (house.sqft != 0) {
      features.add(_buildFeature(
          context, Icons.square_foot_outlined, '${house.sqft} m²'));
    }

    return (house.sqft != 0 && house.bedrooms != 0 && house.bathrooms != 0)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: features,
          )
        : Wrap(
            spacing: 10.0,
            runSpacing: 4.0,
            children: features,
          );
  }

  Widget _buildFeature(BuildContext context, IconData icon, String text) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(text),
      ],
    );
  }

  Widget _buildDetailsList(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Année de construction'),
          trailing: Text(house.yearBuilt.isEmpty ? "Aucun" : house.yearBuilt,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Lieu'),
          trailing: Text(
            house.location,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: house.amenities.map((amenity) {
        return Chip(
          label: Text(amenity),
          backgroundColor: Colors.blue.withOpacity(0.1),
        );
      }).toList(),
    );
  }

  Widget _buildContactButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(house.contactPhone),
            icon: const Icon(Icons.phone),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _openWhatsApp(house.contactWhatsapp),
            icon: const Icon(Icons.message),
            label: const Text('WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
