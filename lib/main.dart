import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main()=>runApp(MaterialApp(home:MusterBook(),debugShowCheckedModeBanner:false));

class Worker{
  String no, name;
  List<String> top, mid, busLate, busTime;
  Worker(this.no,this.name): 
    top=List.filled(31,""),
    mid=List.filled(31,""),
    busLate=List.filled(31,""),
    busTime=List.filled(31,"");
  Map<String,dynamic> toJson()=>{"no":no,"name":name,"top":top,"mid":mid,"busLate":busLate,"busTime":busTime};
  static Worker fromJson(Map<String,dynamic> j){
    var w=Worker(j["no"],j["name"]);
    w.top=List<String>.from(j["top"]??List.filled(31,""));
    w.mid=List<String>.from(j["mid"]??List.filled(31,""));
    w.busLate=List<String>.from(j["busLate"]??List.filled(31,""));
    w.busTime=List<String>.from(j["busTime"]??List.filled(31,""));
    return w;
  }
}

class MusterBook extends StatefulWidget{State<MusterBook> createState()=>_MusterBookState();}
class _MusterBookState extends State<MusterBook>{
  List<Worker> workers = [];
  DateTime now = DateTime.now();
  late int daysInMonth;
  late Set<int> sundays;
  late String monthName;
  bool loading = true;
  final TransformationController _transController = TransformationController();
  // FIXED WATERMARK - Edit nahi
  final String watermarkText = "Create by Pradip Chavan";

  @override
  void initState(){super.initState(); _calcMonth(); _loadData();}

  void _calcMonth(){
    daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    sundays = {};
    List<String> months = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sep","Oct","Nov","Dec"];
    monthName = "${months[now.month-1]} ${now.year}";
    for(int d=1; d<=daysInMonth; d++){
      if(DateTime(now.year, now.month, d).weekday == DateTime.sunday) sundays.add(d);
    }
  }

  String get keyName => "muster_${now.year}_${now.month}";

  Future<void> _loadData() async {
    setState(()=>loading=true);
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(keyName);
    if(data!=null){
      List list = jsonDecode(data);
      workers = list.map((e)=>Worker.fromJson(e)).toList();
    } else {
      workers = [
        Worker("1)", "Mangesh Pawar\n2303 7090"),
        Worker("2)", "Pradip Chavan\n2303 9367"),
        Worker("3)", "Anil Desai\n2300 1711"),
      ];
    }
    setState(()=>loading=false);
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonStr = jsonEncode(workers.map((e)=>e.toJson()).toList());
    await prefs.setString(keyName, jsonStr);
  }

  void changeMonth(int add){
    _saveData();
    setState((){
      now = DateTime(now.year, now.month + add, 1);
      _calcMonth();
      _transController.value = Matrix4.identity(); // reset zoom on month change
    });
    _loadData();
  }

  int getNextSunday(int di){ int day=di+1; for(int s in sundays){ if(s>day) return s; } return day+1; }

  void editCell(int wi, int di){
    var topCtrl = TextEditingController(text: workers[wi].top[di]);
    var midCtrl = TextEditingController(text: workers[wi].mid[di]);
    var busLateCtrl = TextEditingController(text: workers[wi].busLate[di]);
    var busTimeCtrl = TextEditingController(text: workers[wi].busTime[di]);
    int nextSun = getNextSunday(di);
    showDialog(context:context, builder:(_)=>AlertDialog(
      title: Text("${workers[wi].name.split("\n")[0]} - ${di+1} $monthName", style:TextStyle(fontSize:14)),
      content: SingleChildScrollView(child:Column(crossAxisAlignment:CrossAxisAlignment.start, mainAxisSize:MainAxisSize.min, children:[
        Text("1) VAR - P / C OFF", style:TextStyle(fontWeight:FontWeight.bold, fontSize:11)),
        TextField(controller: topCtrl, decoration:InputDecoration(border:OutlineInputBorder(), isDense:true)),
        Wrap(spacing:4, children: ["P","PL","C OFF","6 OFF"].map((e)=>ActionChip(label:Text(e, style:TextStyle(fontSize:10)), onPressed:(){topCtrl.text=e; if(e.contains("OFF")) midCtrl.text="$nextSun";})).toList()),
        SizedBox(height:8),
        Text("2) MADHE - Sunday Tarikh", style:TextStyle(fontWeight:FontWeight.bold, fontSize:11, color:Colors.blue)),
        Row(children:[ Expanded(child:TextField(controller: midCtrl, decoration:InputDecoration(border:OutlineInputBorder(), isDense:true))), SizedBox(width:4), FilledButton.tonal(onPressed:(){midCtrl.text="$nextSun";}, child:Text("S $nextSun", style:TextStyle(fontSize:10))) ]),
        SizedBox(height:8),
        Text("3) KHALI - BUS LATE + TIME", style:TextStyle(fontWeight:FontWeight.bold, fontSize:11, color:Colors.red)),
        Row(children:[ Expanded(child:TextField(controller: busLateCtrl, decoration:InputDecoration(labelText:"BUS LATE", border:OutlineInputBorder(), isDense:true))), SizedBox(width:6), Expanded(child:TextField(controller: busTimeCtrl, decoration:InputDecoration(labelText:"Time", border:OutlineInputBorder(), isDense:true)))]),
        Row(children:[
          ActionChip(label:Text("BUS LATE"), onPressed:(){busLateCtrl.text="BUS LATE";}), SizedBox(width:4),
          ActionChip(label:Text("11:57"), onPressed:(){busTimeCtrl.text="11:57";}), SizedBox(width:4),
          ActionChip(label:Text("12:00"), onPressed:(){busTimeCtrl.text="12:00";}),
          IconButton(icon:Icon(Icons.access_time, color:Colors.orange), onPressed:() async {
            TimeOfDay? t = await showTimePicker(context:context, initialTime:TimeOfDay.now());
            if(t!=null){ busTimeCtrl.text="${t.hour}:${t.minute.toString().padLeft(2,'0')}"; busLateCtrl.text="BUS LATE"; }
          }),
        ]),
        FilledButton.tonalIcon(icon:Icon(Icons.delete), label:Text("Ha Divas Delete"), onPressed:(){ setState((){workers[wi].top[di]=""; workers[wi].mid[di]=""; workers[wi].busLate[di]=""; workers[wi].busTime[di]="";}); _saveData(); Navigator.pop(context); })
      ])),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")),
        FilledButton(onPressed:(){
          setState((){
            workers[wi].top[di]=topCtrl.text; workers[wi].mid[di]=midCtrl.text; workers[wi].busLate[di]=busLateCtrl.text; workers[wi].busTime[di]=busTimeCtrl.text;
          });
          _saveData(); Navigator.pop(context);
        }, child:Text("SAVE"))
      ],
    ));
  }

  void deleteWorker(int wi){
    showDialog(context:context, builder:(_)=>AlertDialog(
      title:Text("Delete?"), content:Text("${workers[wi].name} delete karaycha ka?"),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context), child:Text("Nahi")),
        FilledButton(style:FilledButton.styleFrom(backgroundColor:Colors.red), onPressed:(){ setState(()=>workers.removeAt(wi)); _saveData(); Navigator.pop(context); }, child:Text("Delete")),
      ],
    ));
  }

  Widget hCell(String txt, {double w=40, Color? bg}){
    return Container(width:w, height:45, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6,color:Colors.black), color:bg), child:Text(txt, style:TextStyle(fontSize:10, fontWeight:FontWeight.bold), textAlign:TextAlign.center));
  }

  @override
  Widget build(BuildContext context){
    if(loading) return Scaffold(body:Center(child:CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text("हजेरी बुक - MUSTER BOOK $monthName", style:TextStyle(fontWeight:FontWeight.bold, fontSize:13, color:Colors.black)),
          Text("SAVE Aahe | ${daysInMonth} divas | Sun: ${sundays.join(", ")}", style:TextStyle(fontSize:10, color:Colors.green.shade700)),
        ]),
        actions:[
          IconButton(icon:Icon(Icons.zoom_out_map), tooltip:"Zoom Reset", onPressed:(){ _transController.value = Matrix4.identity(); }),
          IconButton(icon:Icon(Icons.arrow_back), onPressed:(){changeMonth(-1);}),
          IconButton(icon:Icon(Icons.calendar_today, size:18), onPressed:(){ setState(()=>now=DateTime.now()); _calcMonth(); _loadData(); _transController.value = Matrix4.identity(); }),
          IconButton(icon:Icon(Icons.arrow_forward), onPressed:(){changeMonth(1);}),
        ],
      ),
      body: Stack(
        children: [
          // PINCH ZOOM AREA - 2 Finger Zoom + Minus
          InteractiveViewer(
            transformationController: _transController,
            minScale: 0.4,
            maxScale: 4.0,
            scaleEnabled: true,
            panEnabled: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(), // pinch zoom sathi
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                child: Column(children:[
                  Row(children:[
                    hCell("No.", w:40, bg:Colors.grey.shade300),
                    hCell("Name", w:130, bg:Colors.grey.shade300),
                    ...List.generate(daysInMonth, (i){int d=i+1; bool isSun=sundays.contains(d); return hCell("${isSun?"S":""}\n$d", w:65, bg:isSun?Colors.yellow.shade300:Colors.grey.shade300);}),
                  ]),
                  ...workers.asMap().entries.map((e){
                    int wi=e.key; var w=e.value;
                    return Row(children:[
                      Container(width:40, height:114, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6)), child:Text(w.no)),
                      GestureDetector(onLongPress: ()=>deleteWorker(wi), child: Container(width:130, height:114, decoration:BoxDecoration(border:Border.all(width:0.6)), padding:EdgeInsets.all(4), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[ Text(w.name, style:TextStyle(fontSize:11)), Spacer(), Text("Long press delete", style:TextStyle(fontSize:8, color:Colors.grey)) ]))),
                      ...List.generate(daysInMonth, (di){
                        bool hasBus = w.busLate[di].isNotEmpty || w.busTime[di].isNotEmpty;
                        return Column(children:[
                          GestureDetector(onTap:()=>editCell(wi, di), onLongPress:(){ setState((){w.top[di]=""; w.mid[di]=""; w.busLate[di]=""; w.busTime[di]="";}); _saveData();}, child:Container(width:65, height:38, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: w.top[di].contains("OFF")?Colors.purple.shade100 : w.top[di]=="P"?Colors.green.shade100 : Colors.white), child:Text(w.top[di], style:TextStyle(fontSize:10, fontWeight:FontWeight.bold)))),
                          GestureDetector(onTap:()=>editCell(wi, di), onLongPress:(){ setState((){w.top[di]=""; w.mid[di]=""; w.busLate[di]=""; w.busTime[di]="";}); _saveData();}, child:Container(width:65, height:38, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: w.mid[di].isNotEmpty? Colors.yellow.shade100 : Colors.grey.shade100), child:Text(w.mid[di], style:TextStyle(fontSize:10)))),
                          GestureDetector(onTap:()=>editCell(wi, di), onLongPress:(){ setState((){w.top[di]=""; w.mid[di]=""; w.busLate[di]=""; w.busTime[di]="";}); _saveData();}, child:Container(width:65, height:38, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: hasBus?Colors.red.shade100 : Colors.orange.shade50), child:Column(mainAxisAlignment:MainAxisAlignment.center, children:[
                            if(w.busLate[di].isNotEmpty) Text(w.busLate[di], style:TextStyle(fontSize:7, fontWeight:FontWeight.bold, color:Colors.red.shade800)),
                            if(w.busTime[di].isNotEmpty) Text(w.busTime[di], style:TextStyle(fontSize:11, fontWeight:FontWeight.bold, color:Colors.red.shade900)),
                            if(!hasBus) Icon(Icons.directions_bus, size:12, color:Colors.grey)
                          ]))),
                        ]);
                      }),
                    ]);
                  }).toList(),
                ]),
              ),
            ),
          ),
          // FIXED WATERMARK - No Edit
          IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: 0.18,
                child: Transform.rotate(
                  angle: -0.7,
                  child: Text(
                    watermarkText,
                    style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.black54, letterSpacing: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(onPressed: (){ _transController.value = Matrix4.identity()..scale(1.5); }, child: Icon(Icons.zoom_in)),
          SizedBox(height: 6),
          FloatingActionButton.small(onPressed: (){ _transController.value = Matrix4.identity()..scale(0.7); }, child: Icon(Icons.zoom_out)),
          SizedBox(height: 10),
          FloatingActionButton.extended(backgroundColor:Colors.orange, onPressed:(){
            var c=TextEditingController();
            showDialog(context:context, builder:(_)=>AlertDialog(title:Text("Navin Nav"), content:TextField(controller:c, decoration:InputDecoration(hintText:"Nav + Number", border:OutlineInputBorder())), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")), FilledButton(onPressed:(){if(c.text.isNotEmpty){setState(()=>workers.add(Worker("${workers.length+1})", c.text))); _saveData();} Navigator.pop(context);}, child:Text("ADD"))]));
          }, label:Text("Add New Name", style:TextStyle(color:Colors.white)), icon:Icon(Icons.person_add, color:Colors.white)),
        ],
      ),
    );
  }
}
