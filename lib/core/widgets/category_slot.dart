class CategorySlot {
  const CategorySlot({required this.title, required this.backendName});

  final String title;
  final String backendName;
}

const homeCategorySlots = [
  CategorySlot(title: "Kitchen", backendName: "Kitchen"),
  CategorySlot(title: "Living Room", backendName: "Living Room"),
  CategorySlot(title: "Bedroom", backendName: "Bedroom"),
  CategorySlot(title: "Office", backendName: "Office & Study"),
];