import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const HouseFinderApp());
  runApp(const ProviderScope(child: HouseFinderApp()));
}

enum PropertyType {
  villa,
  duplex,
  studio,
  sleepingEntrance, // "Entrée à coucher"
  apartment
}

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
  final int id;
  final String address;
  final double price;
  final int? bedrooms; // Optional now
  final int? bathrooms;
  final double sqft;
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
    this.bedrooms, // Optional parameter
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
}

class HouseFinderApp extends StatelessWidget {
  const HouseFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'House F',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HouseListScreen(),
    );
  }
}

class HouseListScreen extends StatefulWidget {
  const HouseListScreen({super.key});

  @override
  State<HouseListScreen> createState() => _HouseListScreenState();
}

class _HouseListScreenState extends State<HouseListScreen> {
  final List<House> houses = [
    House(
      id: 1,
      address: "Cocody Palmeraie",
      price: 350000,
      bedrooms: 3,
      bathrooms: 2,
      sqft: 180.2,
      propertyType: PropertyType.villa,
      images: [
        "https://cf.bstatic.com/xdata/images/hotel/max1024x768/315757534.jpg?k=71d4f7611ec6c59061b2b396e5bc982e3a1b336da3cd284d76840914f2fe4459&o=&hp=1",
        "https://cf.bstatic.com/xdata/images/hotel/max1024x768/315757940.jpg?k=4bf14cb82ee2a26b4be9b229559c5504c25b017525e7b56b499f96b610bcb84b&o=&hp=1",
        "https://cf.bstatic.com/xdata/images/hotel/max1024x768/315758067.jpg?k=c1408aa1034d6d455c233bcaeb4d470eac263d68cf055e427702b346b23e0993&o=&hp=1",
        "https://cf.bstatic.com/xdata/images/hotel/max1024x768/315760495.jpg?k=4a379585110959db1c02763d34c88da46a257e5410e03c0dbd13ab325cfbed25&o=&hp=1",
      ],
      description: "Luxurious villa with garden",
      location: "Cocody",
      isNewConstruction: true,
      contactPhone: "0503020385",
      contactWhatsapp: "0503020385",
      yearBuilt: "2023",
      amenities: ["Piscine", "Jardin"],
    ),
    House(
      id: 2,
      address: "Yopougon Maroc",
      price: 150000,
      sqft: 400,
      propertyType: PropertyType.studio,
      images: [
        "https://images.pexels.com/photos/7031723/pexels-photo-7031723.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/7060811/pexels-photo-7060811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      ],
      description: "Studio moderne facile d'accès",
      location: "Yopougon",
      isNewConstruction: false,
      contactPhone: "+2250503020385",
      contactWhatsapp: "+2250503020385",
      yearBuilt: "2020",
      amenities: ["Cuisine intégrée", "Eau", "Electricité"],
    ),
    House(
      id: 3,
      address: "Gonzacque Casier",
      price: 100000,
      sqft: 300,
      propertyType: PropertyType.sleepingEntrance,
      images: [
        "https://www.logerchic.com/images/osproperty/properties/20357/20357_08fa0078-0dbb-4d3b-8994-be1cecf9e0c0.jpg",
        "https://www.logerchic.com/images/osproperty/properties/8253/8253_138289641_215524400253335_3515348602618106557_n.jpg"
      ],
      description:
          "Convenient entrance-bedroom setup Convenient entrance-bedroom setup Convenient entrance-bedroom setup Convenient entrance-bedroom setup Convenient entrance-bedroom setup Convenient entrance-bedroom setup Convenient entrance-bedroom setup",
      location: "Gonzacque",
      isNewConstruction: false,
      contactPhone: "+2250503020385",
      contactWhatsapp: "+2250503020385",
      yearBuilt: "2019",
      amenities: ["Eau", "Electricité", "Placard intégré"],
    ),
  ];

  String searchQuery = '';
  double maxPrice = 1000000;
  int? minBedrooms; // Optional now
  Set<PropertyType> selectedPropertyTypes = {};

  List<House> get filteredHouses => houses.where((house) {
        bool matchesSearch = house.address
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            house.location.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesPrice = house.price <= maxPrice;
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
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildPropertyTypeFilter(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHouses.length,
              itemBuilder: (context, index) {
                final house = filteredHouses[index];
                return _buildHouseCard(context, house);
              },
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
                  // Reset bedroom filter if no property type requires it
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
                  min: 100000,
                  max: 1000000,
                  divisions: 18,
                  label: '\$${maxPrice.toStringAsFixed(0)}',
                  onChanged: (value) {
                    setState(() {
                      maxPrice = value;
                    });
                  },
                ),
              ),
            ],
          ),
          // Show bedroom filter only if selected property types require it
          if (selectedPropertyTypes.any((type) => type.requiresBedroomCount))
            Row(
              children: [
                const Text('Min Chambres: '),
                Expanded(
                  child: Slider(
                    value: (minBedrooms ?? 0).toDouble(),
                    min: 0,
                    max: 6,
                    divisions: 6,
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
    return Card(
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    );
  }

  Widget _buildPropertyDetails(House house) {
    List<Widget> details = [];

    // Add bedrooms if they are specified
    if (house.bedrooms != null) {
      details.addAll([
        const Icon(Icons.king_bed_outlined, size: 16),
        Text(' ${house.bedrooms} cbr(s)'),
        const SizedBox(width: 16),
      ]);
    }

    // Add bathrooms if they are specified
    if (house.bathrooms != null) {
      details.addAll([
        const Icon(Icons.bathroom_outlined, size: 16),
        Text(' ${house.bathrooms} dch(s)'),
        const SizedBox(width: 16),
      ]);
    }

    // Always show square footage
    details.addAll([
      const Icon(Icons.square_foot_outlined, size: 16),
      Text(' ${house.sqft} m²'),
    ]);

    return Row(children: details);
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
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: CarouselSlider(
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    const SizedBox(height: 8),
                    Text(
                      house.address,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      house.location,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureRow(context, house),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(house.description),
                    const SizedBox(height: 24),
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailsList(context),
                    const SizedBox(height: 24),
                    Text(
                      'Comodités',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildAmenitiesList(),
                    const SizedBox(height: 24),
                    _buildContactButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, House house) {
    List<Widget> features = [];

    // Add bedrooms if they are specified
    if (house.bedrooms != null) {
      features.add(_buildFeature(
          context, Icons.king_bed, '${house.bedrooms} chambre(s)'));
    }

    // Add bathrooms if they are specified
    if (house.bathrooms != null) {
      features.add(_buildFeature(
          context, Icons.bathroom, '${house.bathrooms} douche(s)'));
    }

    // Always show square footage
    features.add(_buildFeature(context, Icons.square_foot, '${house.sqft} m²'));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          trailing: Text(house.yearBuilt,
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

// ? --------------------------------
