import 'package:flutter/material.dart';

import '../../../../core/location/cities.dart';
import '../../../../l10n/app_localizations.dart';

/// A searchable list of bundled cities. Resolves to the chosen city.
Future<City?> showCityPicker(BuildContext context) => showModalBottomSheet<City>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => const _CityPicker(),
    );

class _CityPicker extends StatefulWidget {
  const _CityPicker();

  @override
  State<_CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<_CityPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cities = kCities
        .where((c) => c.name.toLowerCase().contains(_query.toLowerCase().trim()))
        .toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  autofocus: false,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: l10n.searchCity,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, i) {
                    final city = cities[i];
                    return ListTile(
                      minTileHeight: 56,
                      leading: const Icon(Icons.location_city_outlined),
                      title: Text(city.name),
                      subtitle: Text(city.countryCode),
                      onTap: () => Navigator.of(context).pop(city),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
