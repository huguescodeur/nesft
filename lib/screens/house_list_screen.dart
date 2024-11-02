import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nest_f/models/house.dart';
import 'package:nest_f/screens/house_details_screen.dart';
import 'package:nest_f/services/properties_services.dart';

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
