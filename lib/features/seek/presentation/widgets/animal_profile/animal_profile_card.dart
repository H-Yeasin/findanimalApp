import 'package:flutter/material.dart';
import 'animal_profile_data.dart';

class AnimalProfileCard extends StatelessWidget {
  final AnimalProfileData data;

  const AnimalProfileCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String buttonText = 'Contact the owner';
    if (data.details.toLowerCase().contains('found')) {
      buttonText = 'I know the owner';
    }
    if (data.status.toLowerCase().contains('injured')) {
      buttonText = 'I am available to take care of it';
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === TOP ROW: image left + info right ===
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── LEFT: Name + Image ───
                SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Impact',
                          fontSize: 26,
                          color: Color(0xFFBA4A22),
                          letterSpacing: 0.8,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Image without golden frame
                      Expanded(
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: data.isPlaceholder
                                ? Container(
                                    color: const Color(0xFFFDF6ED),
                                    child: const Center(
                                      child: Icon(
                                        Icons.pets,
                                        color: Color(0xFFBA4A22),
                                        size: 50,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    data.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.pets,
                                        color: Color(0xFFBA4A22),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // ─── RIGHT: Owner info + details + status ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Owner row
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFBA4A22),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.ownerName,
                            style: const TextStyle(
                              color: Color(0xFFBA4A22),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            data.time,
                            style: const TextStyle(
                              color: Color(0xFFD3A482),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Details: Adult | Cat | Angora | Lost
                      Text(
                        data.details,
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFBA4A22),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Current status: ${data.status}',
                          style: const TextStyle(
                            color: Color(0xFFBA4A22),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        '"${data.description}"',
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontSize: 10.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // === CONTACT BUTTON ===
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBA4A22),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
