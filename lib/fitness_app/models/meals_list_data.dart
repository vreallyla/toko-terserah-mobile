class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  int kacl;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      titleTxt: 'Grosir',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    MealsListData(
      titleTxt: 'Retail',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    MealsListData(
      titleTxt: 'Lainnya',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    )
  ];
}
