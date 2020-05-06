class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  _createInitialSections() async{
    final sections = await DBProvider.db.getSections();
    if(sections.length == 0){
      await DBProvider.db.createInitialSections();
      await DBProvider.db.createInitialAthkar();
    }
  }

}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _homeDrawerKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    widget._createInitialSections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: ColorTwo,),
            child: StretchyHeader.singleChild(
                headerData: headerData(context),
                child: SectionsList(context),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {_homeDrawerKey.currentState.openDrawer();},
                  child: Icon(Icons.menu, color: ColorEight,),
                ),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.settings, color: ColorEight,),
                      )
                  ),
                ],
              )
          )
        ],
      ),
