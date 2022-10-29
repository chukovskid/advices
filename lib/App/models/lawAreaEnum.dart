enum LawArea { family, public, home }

extension CatExtension on LawArea {
  String? get name {
    switch (this) {
      case LawArea.family:
        return 'Family law';
      case LawArea.public:
        return 'pubic law';
      case LawArea.home:
        return 'Home law';
      default:
        return null;
    }
  }

  void talk() {
    print('meow');
  }
}
