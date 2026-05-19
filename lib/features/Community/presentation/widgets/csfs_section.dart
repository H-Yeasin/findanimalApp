import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class CsfsSection extends StatefulWidget {
  final Color cardBg;
  final Color color;
  final AppLocalizations l10n;

  const CsfsSection({
    super.key,
    required this.cardBg,
    required this.color,
    required this.l10n,
  });

  @override
  State<CsfsSection> createState() => _CsfsSectionState();
}

class _CsfsSectionState extends State<CsfsSection> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterExpanded = false;
  bool _filterByDepartment = false;
  bool _filterByRegion = false;
  String _sortSelection = 'alpha_az';

  static const List<_CsfsContact> _contacts = [
    _CsfsContact(name: 'PIAFS', phone: '07.88.87.98.32', region: 'Bretagne'),
    _CsfsContact(
      name: 'CSFS LPO AURA',
      phone: '04.74.05.78.85',
      region: 'Auvergne Rhône Alpes',
    ),
    _CsfsContact(
      name: 'CSFS LPO ALSACE',
      phone: '03.88.22.07.35',
      region: 'Grand-Est',
    ),
    _CsfsContact(name: 'CSFL', phone: '09.70.57.30.30', region: 'Grand-Est'),
    _CsfsContact(
      name: 'CSFS LPO OCCITANIE',
      phone: '05.63.73.08.38',
      region: 'PACA',
    ),
    _CsfsContact(
      name: 'CSFS DE LA SEOR',
      phone: '02.62.20.46.65',
      region: 'Réunion',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _filteredContacts;

    return Column(
      children: [
        const SizedBox(height: 34),
        Text(
          'CSFS',
          style: AppTextStyles.heading.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Centres de Sauvegarde de la Faune Sauvage',
          style: AppTextStyles.caption.copyWith(
            color: widget.color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        _buildSearchBar(),
        const SizedBox(height: 10),
        _buildFilterDropdown(),
        const SizedBox(height: 32),
        if (contacts.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.l10n.noReportsFound,
              style: AppTextStyles.body.copyWith(
                color: widget.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          _buildGrid(contacts),
        const SizedBox(height: 24),
        _buildPagination(),
      ],
    );
  }

  List<_CsfsContact> get _filteredContacts {
    final query = _searchController.text.trim().toLowerCase();
    final contacts = _contacts.where((contact) {
      if (query.isEmpty) return true;
      return contact.name.toLowerCase().contains(query) ||
          contact.region.toLowerCase().contains(query) ||
          contact.phone.contains(query);
    }).toList();

    contacts.sort((a, b) {
      final result = a.name.compareTo(b.name);
      return _sortSelection == 'alpha_za' ? -result : result;
    });

    return contacts;
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: widget.color.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Rechercher par nom',
          hintStyle: AppTextStyles.caption.copyWith(
            color: widget.color.withValues(alpha: 0.5),
            fontSize: 12,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: widget.color, size: 24),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: widget.color),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: widget.color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isFilterExpanded = !_isFilterExpanded;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isFilterExpanded
                        ? 'Filtrer par'
                        : 'Filtrer par / Trier par',
                    style: AppTextStyles.caption.copyWith(
                      color: widget.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isFilterExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: widget.color,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          if (_isFilterExpanded) ...[
            const SizedBox(height: 14),
            Container(height: 1, color: widget.color.withValues(alpha: 0.35)),
            const SizedBox(height: 16),
            _buildFilterOption(
              label: 'Filtrer par département',
              value: _filterByDepartment,
              onChanged: (value) {
                setState(() {
                  _filterByDepartment = value;
                });
              },
            ),
            _buildFilterOption(
              label: 'Filtrer par région',
              value: _filterByRegion,
              onChanged: (value) {
                setState(() {
                  _filterByRegion = value;
                });
              },
            ),
            const SizedBox(height: 18),
            Text(
              'Trier par',
              style: AppTextStyles.caption.copyWith(
                color: widget.color,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: widget.color.withValues(alpha: 0.35)),
            const SizedBox(height: 16),
            _buildFilterOption(
              label: 'Ordre alphabétique A-Z',
              value: _sortSelection == 'alpha_az',
              onChanged: (value) {
                if (!value) return;
                setState(() {
                  _sortSelection = 'alpha_az';
                });
              },
            ),
            _buildFilterOption(
              label: 'Ordre alphabétique Z-A',
              value: _sortSelection == 'alpha_za',
              onChanged: (value) {
                if (!value) return;
                setState(() {
                  _sortSelection = 'alpha_za';
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterOption({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: Checkbox(
                value: value,
                onChanged: (next) => onChanged(next ?? false),
                activeColor: widget.color,
                checkColor: Colors.white,
                side: BorderSide(color: widget.color.withValues(alpha: 0.8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: widget.color,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<_CsfsContact> contacts) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.65,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: contacts.map(_buildCard).toList(),
    );
  }

  Widget _buildCard(_CsfsContact contact) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: widget.color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                contact.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                contact.phone,
                style: AppTextStyles.caption.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => _launchCaller(contact.phone),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'APPELER',
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: widget.color, size: 12),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  contact.region,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: widget.color,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.chevron_left, color: widget.color, size: 28),
        const SizedBox(width: 8),
        _pageNumber('1', isActive: true),
        _pageNumber('2'),
        _pageNumber('3'),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right, color: widget.color, size: 28),
      ],
    );
  }

  Widget _pageNumber(String value, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        value,
        style: AppTextStyles.caption.copyWith(
          color: widget.color,
          fontSize: 18,
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _launchCaller(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri.parse('tel:$cleanNumber');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}

class _CsfsContact {
  final String name;
  final String phone;
  final String region;

  const _CsfsContact({
    required this.name,
    required this.phone,
    required this.region,
  });
}
