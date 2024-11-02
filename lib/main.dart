// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nest_f/screens/splash_screen.dart';
import 'package:nest_f/services/auth/auth_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';
import 'package:animate_do/animate_do.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const HouseFinderApp());
  runApp(const MyAPP());
  // runApp(const SplashScreen());
}

enum PropertyType { villa, duplex, studio, sleepingEntrance, apartment }

extension PropertyTypeExtension on PropertyType {
  String get displayName {
    switch (this) {
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.duplex:
        return 'Duplex';
      case PropertyType.studio:
        return 'Studio';
      case PropertyType.sleepingEntrance:
        return 'Entrée à coucher';
      case PropertyType.apartment:
        return 'Apartment';
    }
  }

  bool get requiresBedroomCount {
    return this == PropertyType.villa ||
        this == PropertyType.duplex ||
        this == PropertyType.apartment;
  }
}

class House {
  final String id;
  final String address;
  final int price;
  final int? bedrooms;
  final int? bathrooms;
  final dynamic sqft;
  final List<String> images;
  final String description;
  final String location;
  final bool isNewConstruction;
  final String contactPhone;
  final String contactWhatsapp;
  final String yearBuilt;
  final List<String> amenities;
  final PropertyType propertyType;

  House({
    required this.id,
    required this.address,
    required this.price,
    this.bedrooms,
    this.bathrooms,
    required this.sqft,
    required this.images,
    required this.description,
    required this.location,
    required this.isNewConstruction,
    required this.contactPhone,
    required this.contactWhatsapp,
    required this.yearBuilt,
    required this.amenities,
    required this.propertyType,
  });

  factory House.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return House(
      id: data['id'],
      address: data['address'],
      price: data['price'] ?? 0,
      bedrooms: data['bedrooms'] ?? 0,
      bathrooms: data['bathrooms'] ?? 0,
      sqft: data['sqft'] ?? 0,
      images: List<String>.from(data['images']),
      description: data['description'],
      location: data['location'],
      isNewConstruction: data['isNewConstruction'],
      contactPhone: data['phone'],
      contactWhatsapp: data['contactWhatsapp'],
      yearBuilt: data['yearBuilt'],
      amenities: List<String>.from(data['amenities']),
      propertyType:
          PropertyType.values.byName(data['propertyType'].toLowerCase()),
    );
  }
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nest F',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // home: const AuthWrapper(),
      home: const SplashScreen(),
    );
  }
}

class HouseFinderApp extends StatelessWidget {
  const HouseFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HouseListScreen();
  }
}

// class HouseListScreen extends StatefulWidget {
//   const HouseListScreen({super.key});

//   @override
//   State<HouseListScreen> createState() => _HouseListScreenState();
// }

// class _HouseListScreenState extends State<HouseListScreen> {
//   final List<House> houses = [];
//   String searchQuery = '';
//   double maxPrice = 0;
//   double minPrice = 0;
//   int? minBedrooms;
//   int? maxBedrooms;
//   Set<PropertyType> selectedPropertyTypes = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchHouses();
//   }

//   Future<void> fetchHouses() async {
//     final querySnapshot =
//         await FirebaseFirestore.instance.collection('properties').get();
//     final allHouses =
//         querySnapshot.docs.map((doc) => House.fromFirestore(doc)).toList();

//     if (allHouses.isNotEmpty) {
//       setState(() {
//         houses.addAll(allHouses);

//         minPrice = houses
//             .map((house) => house.price)
//             .reduce((a, b) => a < b ? a : b)
//             .toDouble();
//         maxPrice = houses
//             .map((house) => house.price)
//             .reduce((a, b) => a > b ? a : b)
//             .toDouble();

//         final bedrooms = houses
//             .where((house) => house.bedrooms != null)
//             .map((house) => house.bedrooms!);
//         if (bedrooms.isNotEmpty) {
//           minBedrooms = bedrooms.reduce((a, b) => a < b ? a : b);
//           maxBedrooms = bedrooms.reduce((a, b) => a > b ? a : b);
//         }
//       });
//     }

//     print('Max price: $maxPrice');
//     print('Min price: $minPrice');
//     print('Max Bedroom: $maxBedrooms');
//     print('Min Bedroom: $minBedrooms');
//   }

//   List<House> get filteredHouses => houses.where((house) {
//         bool matchesSearch = house.address
//                 .toLowerCase()
//                 .contains(searchQuery.toLowerCase()) ||
//             house.location.toLowerCase().contains(searchQuery.toLowerCase());
//         bool matchesPrice = house.price >= minPrice && house.price <= maxPrice;
//         bool matchesPropertyType = selectedPropertyTypes.isEmpty ||
//             selectedPropertyTypes.contains(house.propertyType);
//         bool matchesBedrooms = minBedrooms == null ||
//             !house.propertyType.requiresBedroomCount ||
//             (house.bedrooms != null && house.bedrooms! >= minBedrooms!);

//         return matchesSearch &&
//             matchesPrice &&
//             matchesPropertyType &&
//             matchesBedrooms;
//       }).toList();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nest F'),
//       ),
//       body: Column(
//         children: [
//           _buildFilters(),
//           _buildPropertyTypeFilter(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredHouses.length,
//               itemBuilder: (context, index) {
//                 final house = filteredHouses[index];
//                 return _buildHouseCard(context, house);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

class HouseListScreen extends StatefulWidget {
  const HouseListScreen({super.key});

  @override
  State<HouseListScreen> createState() => _HouseListScreenState();
}

class _HouseListScreenState extends State<HouseListScreen> {
  final List<House> houses = [];
  String searchQuery = '';
  double maxPrice = 0;
  double minPrice = 0;
  int? minBedrooms;
  int? maxBedrooms;
  Set<PropertyType> selectedPropertyTypes = {};

  @override
  void initState() {
    super.initState();
    fetchHouses();
  }

  Future<void> fetchHouses() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('properties').get();
    final allHouses =
        querySnapshot.docs.map((doc) => House.fromFirestore(doc)).toList();

    if (allHouses.isNotEmpty) {
      setState(() {
        houses
            .clear(); // Vider la liste existante avant d'ajouter les nouvelles données
        houses.addAll(allHouses);

        minPrice = houses
            .map((house) => house.price)
            .reduce((a, b) => a < b ? a : b)
            .toDouble();
        maxPrice = houses
            .map((house) => house.price)
            .reduce((a, b) => a > b ? a : b)
            .toDouble();

        final bedrooms = houses
            .where((house) => house.bedrooms != null)
            .map((house) => house.bedrooms!);
        if (bedrooms.isNotEmpty) {
          minBedrooms = bedrooms.reduce((a, b) => a < b ? a : b);
          maxBedrooms = bedrooms.reduce((a, b) => a > b ? a : b);
        }
      });
    }
  }

  List<House> get filteredHouses => houses.where((house) {
        bool matchesSearch = house.address
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            house.location.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesPrice = house.price >= minPrice && house.price <= maxPrice;
        bool matchesPropertyType = selectedPropertyTypes.isEmpty ||
            selectedPropertyTypes.contains(house.propertyType);
        bool matchesBedrooms = minBedrooms == null ||
            !house.propertyType.requiresBedroomCount ||
            (house.bedrooms != null && house.bedrooms! >= minBedrooms!);

        return matchesSearch &&
            matchesPrice &&
            matchesPropertyType &&
            matchesBedrooms;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nest F'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildPropertyTypeFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Actualiser les données
                await fetchHouses();
              },
              child: ListView.builder(
                itemCount: filteredHouses.length,
                itemBuilder: (context, index) {
                  final house = filteredHouses[index];
                  return _buildHouseCard(context, house);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: PropertyType.values.map((type) {
          bool isSelected = selectedPropertyTypes.contains(type);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(type.displayName),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedPropertyTypes.add(type);
                  } else {
                    selectedPropertyTypes.remove(type);
                  }
                  if (!selectedPropertyTypes
                      .any((type) => type.requiresBedroomCount)) {
                    minBedrooms = null;
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Recherchez par adresse ou lieu',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Prix Max: '),
              Expanded(
                child: Slider(
                  value: maxPrice,
                  // min: minPrice,
                  min: 0,
                  max: 9999999,
                  // max: maxPrice,
                  divisions: 1000,
                  label: '${maxPrice.toStringAsFixed(0)} FCFA',
                  onChanged: (value) {
                    setState(() {
                      maxPrice = value;
                    });
                  },
                ),
              ),
            ],
          ),
          if (selectedPropertyTypes.any((type) => type.requiresBedroomCount))
            Row(
              children: [
                const Text('Min Chambres: '),
                Expanded(
                  child: Slider(
                    value: (minBedrooms ?? 0).toDouble(),
                    // min: (minBedrooms ?? 0).toDouble(),
                    min: 0,
                    max: 20,
                    // max: (maxBedrooms ?? 6).toDouble(),
                    divisions: 1000,
                    label: (minBedrooms ?? 0).toString(),
                    onChanged: (value) {
                      setState(() {
                        minBedrooms = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHouseCard(BuildContext context, House house) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HouseDetailScreen(house: house),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                house.images[0],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${house.price.toStringAsFixed(0)} FCFA',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        Chip(
                          label: Text(house.propertyType.displayName),
                          backgroundColor: Colors.blue.withOpacity(0.1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      house.address,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      house.location,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildPropertyDetails(house),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildHouseCard(BuildContext context, House house) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     clipBehavior: Clip.antiAlias,
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => HouseDetailScreen(house: house),
  //           ),
  //         );
  //       },
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Image.network(
  //             house.images[0],
  //             height: 200,
  //             width: double.infinity,
  //             fit: BoxFit.cover,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       '${house.price.toStringAsFixed(0)} FCFA',
  //                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                             color: Theme.of(context).primaryColor,
  //                           ),
  //                     ),
  //                     Chip(
  //                       label: Text(house.propertyType.displayName),
  //                       backgroundColor: Colors.blue.withOpacity(0.1),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   house.address,
  //                   style: Theme.of(context).textTheme.titleMedium,
  //                 ),
  //                 Text(
  //                   house.location,
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //                 const SizedBox(height: 8),
  //                 _buildPropertyDetails(house),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPropertyDetails(House house) {
    List<Widget> details = [];

    // Add bedrooms if they are specified
    if (house.bedrooms != 0) {
      details.addAll([
        const Icon(Icons.king_bed_outlined, size: 16),
        Text(' ${house.bedrooms} cbr(s)'),
        const SizedBox(width: 16),
      ]);
    }

    // Add bathrooms if they are specified
    if (house.bathrooms != 0) {
      details.addAll([
        const Icon(Icons.bathroom_outlined, size: 16),
        Text(' ${house.bathrooms} dch(s)'),
        const SizedBox(width: 16),
      ]);
    }

    if (house.sqft != 0) {
      details.addAll([
        const Icon(Icons.square_foot_outlined, size: 16),
        Text(' ${house.sqft} m²'),
      ]);
    }

    return (house.sqft != 0 && house.bedrooms != 0 && house.bathrooms != 0)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: details,
          )
        : Wrap(
            spacing: 10.0,
            runSpacing: 4.0,
            children: details,
          );
  }
}

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


// --------------------
// Widget _buildFeatureRow(BuildContext context, House house) {
//   List<Widget> features = [];

//   if (house.bedrooms != 0) {
//     features.add(_buildFeature(
//         context, Icons.king_bed_outlined, '${house.bedrooms} chambre(s)'));
//   }

//   if (house.bathrooms != 0) {
//     features.add(_buildFeature(
//         context, Icons.bathroom_outlined, '${house.bathrooms} douche(s)'));
//   }

//   if (house.sqft != 0) {
//     features.add(
//         _buildFeature(context, Icons.square_foot_outlined, '${house.sqft} m²'));
//   }

//   return (house.sqft != 0 && house.bedrooms != 0 && house.bathrooms != 0)
//       ? Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: features,
//         )
//       : Wrap(
//           spacing: 10.0,
//           runSpacing: 4.0,
//           children: features,
//         );
// }

// Widget _buildFeature(BuildContext context, IconData icon, String text) {
//   return Column(
//     children: [
//       Icon(icon),
//       const SizedBox(height: 4),
//       Text(text),
//     ],
//   );
// }

// Widget _buildDetailsList(BuildContext context) {
//   return Column(
//     children: [
//       ListTile(
//         leading: const Icon(Icons.calendar_today),
//         title: const Text('Année de construction'),
//         trailing: Text(house.yearBuilt.isEmpty ? "Aucun" : house.yearBuilt,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//       ),
//       ListTile(
//         leading: const Icon(Icons.location_on),
//         title: const Text('Lieu'),
//         trailing: Text(
//           house.location,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildAmenitiesList() {
//   return Wrap(
//     spacing: 8,
//     runSpacing: 8,
//     children: house.amenities.map((amenity) {
//       return Chip(
//         label: Text(amenity),
//         backgroundColor: Colors.blue.withOpacity(0.1),
//       );
//     }).toList(),
//   );
// }

// Widget _buildContactButtons(BuildContext context) {
//   return Row(
//     children: [
//       Expanded(
//         child: ElevatedButton.icon(
//           onPressed: () => _makePhoneCall(house.contactPhone),
//           icon: const Icon(Icons.phone),
//           label: const Text('Call'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ),
//       const SizedBox(width: 16),
//       Expanded(
//         child: ElevatedButton.icon(
//           onPressed: () => _openWhatsApp(house.contactWhatsapp),
//           icon: const Icon(Icons.message),
//           label: const Text('WhatsApp'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green.shade700,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ),
//     ],
//   );
// }
