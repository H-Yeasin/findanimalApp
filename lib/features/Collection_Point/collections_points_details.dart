import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CollectionPointsDetailsScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoUrl;
  final String description;
  final double? latitude;
  final double? longitude;

  const CollectionPointsDetailsScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoUrl,
    required this.description,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);
    const surface = Color(0xFFFBF4E9);
    const cardBg = Color(0xFFFFF6E5);

    return Scaffold(
      backgroundColor: surface,
      body: CustomPaint(
        painter: _GridPainter(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildCustomAppBar(context, brandPrimary),
                const SizedBox(height: 10),
                _buildDetailCard(brandPrimary, cardBg),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.undo, color: Colors.white, size: 24),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const CircleAvatar(
              backgroundColor: Color(0xFFBA4A22),
              radius: 20,
              child: Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(Color color, Color cardBg) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: logoUrl.startsWith('http')
                      ? Image.network(
                          logoUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.store,
                            color: Color(0xFFBA4A22),
                            size: 40,
                          ),
                        )
                      : const Icon(
                          Icons.store,
                          color: Color(0xFFBA4A22),
                          size: 40,
                        ),
                ),
              ),
              const SizedBox(width: 20),
              // Title Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.startsWith('COLLECTION')
                          ? title
                          : 'COLLECTION POINT',
                      style: TextStyle(
                        color: color,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Impact',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      title, // Using title as the name if it's not a generic header
                      style: TextStyle(
                        color: color.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            description,
            style: TextStyle(
              color: color,
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'Together, let\'s help animals in need.',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          // Map section
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: latitude != null && longitude != null
                      ? LatLng(latitude!, longitude!)
                      : const LatLng(43.6047, 1.4442),
                  zoom: 15.0,
                ),
                markers: latitude != null && longitude != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected_point'),
                          position: LatLng(latitude!, longitude!),
                          infoWindow: InfoWindow(title: title),
                        ),
                      }
                    : {},
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // See on map button
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'SEE ON MAP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBA4A22).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    double step = 25;

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
