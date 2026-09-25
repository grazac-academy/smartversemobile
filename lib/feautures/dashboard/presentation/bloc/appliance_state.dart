import 'package:smartversemobile/feautures/dashboard/data/models/appliance.dart';

import '../../data/models/appliance_category.dart';


enum ApplianceLoadStatus { initial, loading, loaded, error }

class ApplianceState {
  const ApplianceState({
    this.status = ApplianceLoadStatus.initial,
    this.appliances = const [],
    this.categories = const [],
    this.errorMessage,
    this.quantities = const {},
    this.wattageOverrides = const {},
    this.searchQuery = '',
    this.searchResults,
    this.isSearching = false,
  });

  final ApplianceLoadStatus status;
  final List<Appliance> appliances;
  final List<Category> categories;
  final String? errorMessage;
  final Map<String, int> quantities;
  final Map<String, int> wattageOverrides;
  final String searchQuery;
  final List<Appliance>? searchResults;
  final bool isSearching;

  /// The list the UI should render: the full appliance list normally, or
  /// the backend search results while a search query is active.
  List<Appliance> get displayedAppliances =>
      searchQuery.isEmpty ? appliances : (searchResults ?? const []);

  int quantityOf(String id) => quantities[id] ?? 0;

  int wattageOf(Appliance appliance) => wattageOverrides[appliance.id] ?? appliance.defaultWattage;

  String subtitleFor(Appliance appliance) => "${wattageOf(appliance)}W · tap to edit";

  List<String> badgesFor(Appliance appliance) {
    final badges = <String>[];
    if (appliance.heavyLoad) badges.add("HEAVY");
    if (appliance.surgeApplicable) badges.add("SURGE");

    return badges;
  }

  int get totalItems => quantities.values.fold(0, (sum, q) => sum + q);

  int get totalWatts {
    int total = 0;
    for (final a in appliances) {
      total += quantityOf(a.id) * wattageOf(a);
    }
    return total;
  }

  int totalItemsInCategory(String categoryId) =>
      appliances.where((a) => a.categoryId == categoryId).fold(0, (sum, a) => sum + quantityOf(a.id));

  int totalWattsInCategory(String categoryId) {
    int total = 0;
    for (final a in appliances.where((a) => a.categoryId == categoryId)) {
      total += quantityOf(a.id) * wattageOf(a);
    }
    return total;
  }

  String get formattedLoad => formatWatts(totalWatts);

  static String formatWatts(int watts) {
    if (watts >= 1000) {
      final kw = watts / 1000;
      final display = kw == kw.roundToDouble() ? kw.toStringAsFixed(0) : kw.toStringAsFixed(1);
      return "${display}kW";
    }

    return "${watts}W";
  }

  ApplianceState copyWith({
    ApplianceLoadStatus? status,
    List<Appliance>? appliances,
    List<Category>? categories,
    String? errorMessage,
    Map<String, int>? quantities,
    Map<String, int>? wattageOverrides,
    String? searchQuery,
    List<Appliance>? searchResults,
    bool? isSearching,
  }) {
    return ApplianceState(
      status: status ?? this.status,
      appliances: appliances ?? this.appliances,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
      quantities: quantities ?? this.quantities,
      wattageOverrides: wattageOverrides ?? this.wattageOverrides,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}