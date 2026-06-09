import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../base/constants/app_colors.dart';
import '../../../base/ui/widgets/shared_text_form_field.dart';
import '../../../base/ui/widgets/text_widget.dart';
import '../../../core/utilities/main_utilities.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const LatLng _fallbackLatLng = LatLng(24.7136, 46.6753); // Example

  LatLng _selectedLatLng = _fallbackLatLng;
  String _selectedAddress = '';
  bool _isLoadingAddress = false;
  GoogleMapController? _mapController;

  // Search related
  final TextEditingController _searchController = TextEditingController();
  List<Location> _searchResults = [];
  bool _isSearching = false;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Don't call _initCurrentLocation here - wait for map to be created
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchLocations(query);
    });
  }

  Future<void> _searchLocations(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });
    try {
      final locations = await locationFromAddress(query);
      if (mounted) {
        setState(() {
          _searchResults = locations;
          _isSearching = false;
        });
      }
    } catch (e) {
      debugPrint("Error searching locations: $e");
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _goToLocation(Location location) async {
    final latLng = LatLng(location.latitude, location.longitude);
    setState(() {
      _selectedLatLng = latLng;
      _searchResults = [];
      _searchController.clear();
    });

    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
    }
    await _reverseGeocode(latLng);
  }

  Future<void> _initCurrentLocation() async {
    try {
      final position = await MainUtilities.getPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLatLng = latLng;
      });

      // Wait for map controller to be ready before moving camera
      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 14),
        );
      }
      await _reverseGeocode(latLng);
    } catch (e) {
      debugPrint("Error getting current location: $e");
      // Fallback to default if permission denied or other errors
      setState(() {
        _selectedLatLng = _fallbackLatLng;
      });
      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_fallbackLatLng, 14),
        );
      }
      await _reverseGeocode(_fallbackLatLng);
    }
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    if (!mounted) return;

    setState(() {
      _isLoadingAddress = true;
    });
    try {
      final placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (mounted && placemarks.isNotEmpty) {
        final p = placemarks.first;
        final buffer = [
          if (p.street != null && p.street!.isNotEmpty) p.street,
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.country != null && p.country!.isNotEmpty) p.country,
        ].whereType<String>().join(', ');
        setState(() {
          _selectedAddress =
              buffer.isNotEmpty ? buffer : 'Address not available';
        });
      }
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
      if (mounted) {
        setState(() {
          _selectedAddress = 'Address not available';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAddress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          'Select address'.tr(),
          textSize: 16,
          fontWeight: FontWeight.w600,
          textColor: AppColors.fontColor,
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SharedTextFormField(
              label: '',
              hint: 'Search location'.tr(),
              controller: _searchController,
              prefixIcon: Icon(Icons.search, color: AppColors.grey500),
              onSubmitted: (_) {
                if (_searchResults.isNotEmpty) {
                  _goToLocation(_searchResults.first);
                }
              },
            ),
          ),
          // Search results list
          if (_searchResults.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final location = _searchResults[index];
                  return ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: AppColors.mainColor,
                    ),
                    title: TextWidget(
                      _searchController.text,
                      textSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.fontColor,
                    ),
                    subtitle: TextWidget(
                      '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
                      textSize: 12,
                      textColor: AppColors.typography500,
                    ),
                    onTap: () => _goToLocation(location),
                  );
                },
              ),
            ),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          // Selected address display
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextWidget(
              _isLoadingAddress
                  ? 'Loading address...'.tr()
                  : (_selectedAddress.isEmpty
                      ? 'Tap on the map to select address'.tr()
                      : _selectedAddress),
              textSize: 13,
              fontWeight: FontWeight.w400,
              textColor: AppColors.typography700,
            ),
          ),
          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _fallbackLatLng,
                zoom: 14,
              ),
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedLatLng,
                ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
                // Initialize location after map is created
                _initCurrentLocation();
              },
              onTap: (latLng) {
                setState(() {
                  _selectedLatLng = latLng;
                  _searchResults = [];
                  _searchController.clear();
                });
                _reverseGeocode(latLng);
              },
            ),
          ),
          // Use this address button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.of(context).pop(_selectedAddress);
                },
                child: TextWidget(
                  'Use this address'.tr(),
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
