class SectionsList extends StatefulWidget {
  SectionsList(BuildContext context);

  @override
  _SectionsListState createState() => _SectionsListState();
}

class _SectionsListState extends State<SectionsList> {
  var uuid = Uuid();
  static const DEFAULT_COLOR = Colors.blue;
  String sectionName;
  List<Section> _docs;

  @override
  Widget build(BuildContext context) {
    final athkarProvider = Provider.of<AthkarProvider>(context);
    int sectionsLength = 0;

    return
      Column(
      children: [
        // Sections List
        athkarProvider.watchSectionsEvent != null? StreamBuilder(
          stream: athkarProvider.watchSectionsEvent,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              _docs = snapshot.data;
              return ConstrainedBox(
                //constraints: BoxConstraints(maxHeight:maxHeight:MediaQuery.of(context).size.height),
                constraints: BoxConstraints(maxHeight:(78.0*(_docs.length).round())),
                child: ReorderableListView(
                    onReorder: _onReorder,
                    children: _docs.map((section) =>
                        MainButton(
                          key: ObjectKey(section),
                          persist: section.persist,
                          color: section.color,
                          title: "${section.title}",
                          progress: section.progress,
                          id: section.sectionID,
                          editSection: () {},
                        )
                    ).toList(),
                  ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ):LoadingSpinner(),
//        athkarProvider.watchSectionsEvent != null? StreamBuilder(
//          stream: athkarProvider.watchSectionsEvent,
//          builder: (BuildContext context, AsyncSnapshot snapshot){
//            if(!snapshot.hasData){
//              return LoadingSpinner();
//            }else{
//              return ListView.builder(
//                  shrinkWrap: true,
//                  physics: ScrollPhysics(),
//                  itemCount: snapshot.data.length??0,
//                  itemBuilder: (context, index){
//                    return MainButton(
//                            persist: snapshot.data[index].persist,
//                            color: snapshot.data[index].color,
//                            title: "${snapshot.data[index].title}",
//                            progress: snapshot.data[index].progress,
//                            id: snapshot.data[index].sectionID,
//                          editSection: () =>
//                          _editSectionBottomSheet(
//                              context,
//                              athkarProvider,
//                              sectionsLength,
//                              snapshot.data[index].color,
//                              snapshot.data[index].sectionID,
//                              "${snapshot.data[index].title}"
//                          ),
//                        );
//                  });
//            }
//          },
//        ): LoadingSpinner(),

        //New Section Button
        SizedBox(height: 10,),
        Row(
          children: <Widget>[
            SizedBox(width: 10,),
            Expanded(
              flex: 1,
              child: MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                onPressed: (){_showBottomSheet(context, athkarProvider, sectionsLength);},
                color: ColorThree,
                height: 68,
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_circle, color: ColorOne,size: 20,),
                    SizedBox(width: 10,),
                    Text('جديد', style: TitleMediumTextStyle),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('يمكنك إضافة أقسامك وأذكارك الخاصة.',
            style: BodySmallTextStyle,
            ),
          ],
        ),
        SizedBox(height: 100,),
      ],
    );
  }
  void _onReorder(int oldIndex, int newIndex){
    final athkarProvider = Provider.of<AthkarProvider>(context, listen: false);
    if (oldIndex < newIndex) newIndex -= 1;
    final section = _docs.removeAt(oldIndex);
    _docs.insert(newIndex, section);
    for (int pos = 0; pos < _docs.length; pos++) {
      athkarProvider.updateSectionsPosition(_docs[pos].sectionID, pos);
    }
  }
