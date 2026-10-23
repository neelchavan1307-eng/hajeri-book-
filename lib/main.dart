import 'package:flutter/material.dart';
void main()=>runApp(MaterialApp(home:MusterBook(),debugShowCheckedModeBanner:false));

class Worker{
  String no, name;
  List<String> top = List.filled(31, ""); // P, C OFF
  List<String> mid = List.filled(31, ""); // Sunday tarikh, I II
  List<String> bus = List.filled(31, ""); // BUS LATE + Time
  Worker(this.no,this.name);
}

class MusterBook extends StatefulWidget{State<MusterBook> createState()=>_MusterBookState();}
class _MusterBookState extends State<MusterBook>{
  List<Worker> workers = [
    Worker("1)", "Mangesh Pawar\n2303 7090"),
    Worker("2)", "Pradip Chavan\n2303 9367"),
    Worker("3)", "Anil Desai\n2300 1711"),
  ];
  Set<int> sundays = {7,14,21,28};

  int getNextSunday(int di){
    int day = di + 1;
    for(int s in sundays){ if(s > day) return s; }
    return day+1;
  }

  void editCell(int wi, int di){
    var topCtrl = TextEditingController(text: workers[wi].top[di]);
    var midCtrl = TextEditingController(text: workers[wi].mid[di]);
    var busCtrl = TextEditingController(text: workers[wi].bus[di]);
    int nextSun = getNextSunday(di);
    
    showDialog(context:context, builder:(_)=>AlertDialog(
      title: Text("${workers[wi].name.split("\n")[0]} - ${di+1} तारीख"),
      content: SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children:[
        Text("1) VAR - Hajeri / C OFF", style:TextStyle(fontWeight:FontWeight.bold, fontSize:11)),
        TextField(controller: topCtrl, decoration:InputDecoration(hintText:'P, C OFF', border:OutlineInputBorder(), isDense:true)),
        Wrap(spacing:4, children: ["P","PL","CL","C OFF","6 OFF"].map((e)=>ActionChip(label:Text(e, style:TextStyle(fontSize:10)), onPressed:(){
          topCtrl.text=e;
          if(e.contains("OFF")) midCtrl.text="$nextSun";
        })).toList()),
        
        SizedBox(height:10),
        Text("2) MADHE - Sunday Tarikh / Shift (AUTO+EDIT)", style:TextStyle(fontWeight:FontWeight.bold, fontSize:11, color:Colors.blue.shade800)),
        Row(children:[
          Expanded(child:TextField(controller: midCtrl, decoration:InputDecoration(hintText:'7, I, II', border:OutlineInputBorder(), isDense:true))),
          SizedBox(width:4),
          FilledButton.tonal(onPressed:(){midCtrl.text="$nextSun";}, child:Text("S $nextSun", style:TextStyle(fontSize:10)))
        ]),
        Wrap(spacing:4, children: ["I","II","III","7","14","21"].map((e)=>ActionChip(label:Text(e, style:TextStyle(fontSize:10)), onPressed:(){midCtrl.text=e;})).toList()),

        SizedBox(height:10),
        Text("3) KHALI NAVIN - BUS LATE + TIMING", style:TextStyle(fontWeight:FontWeight.bold, fontSize:11, color:Colors.red.shade800)),
        TextField(controller: busCtrl, decoration:InputDecoration(hintText:'BUS LATE 11.50, 7/16', border:OutlineInputBorder(), isDense:true, suffixIcon:Icon(Icons.directions_bus, size:18))),
        Wrap(spacing:4, children: ["BUS LATE","BUS LATE 11.50","11.50","7/16","LATE"].map((e)=>ActionChip(label:Text(e, style:TextStyle(fontSize:10)), onPressed:(){busCtrl.text=e;})).toList()),
      ])),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")),
        FilledButton(onPressed:(){
          setState((){
            workers[wi].top[di]=topCtrl.text;
            workers[wi].mid[di]=midCtrl.text;
            workers[wi].bus[di]=busCtrl.text;
          });
          Navigator.pop(context);
        }, child:Text("SAVE"))
      ],
    ));
  }

  Widget hCell(String txt, {double w=40, Color? bg}){
    return Container(width:w, height:45, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6,color:Colors.black), color:bg), child:Text(txt, style:TextStyle(fontSize:10, fontWeight:FontWeight.bold), textAlign:TextAlign.center));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("हजेरी बुक - MUSTER BOOK June 2026", style:TextStyle(fontWeight:FontWeight.bold, fontSize:13, color:Colors.black)), backgroundColor:Colors.white),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children:[
          Row(children:[
            hCell("No.", w:40, bg:Colors.grey.shade300),
            hCell("Name", w:130, bg:Colors.grey.shade300),
            ...List.generate(30, (i){int d=i+1; bool isSun=sundays.contains(d); return hCell("${isSun?"S":""}\n$d", w:60, bg:isSun?Colors.yellow.shade300:Colors.grey.shade300);}),
          ]),
          ...workers.asMap().entries.map((entry){
            int wi=entry.key; var w=entry.value;
            return Row(children:[
              Container(width:40, height:108, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6)), child:Text(w.no)),
              Container(width:130, height:108, decoration:BoxDecoration(border:Border.all(width:0.6)), padding:EdgeInsets.all(4), child:Text(w.name, style:TextStyle(fontSize:11))),
              ...List.generate(30, (di){
                return Column(children:[
                  // 1 VAR
                  GestureDetector(onTap:()=>editCell(wi, di), child:Container(width:60, height:36, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: w.top[di].contains("OFF")?Colors.purple.shade100 : w.top[di]=="P"?Colors.green.shade100 : Colors.white), child:Text(w.top[di], style:TextStyle(fontSize:9, fontWeight:FontWeight.bold), textAlign:TextAlign.center))),
                  // 2 MADHE
                  GestureDetector(onTap:()=>editCell(wi, di), child:Container(width:60, height:36, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: w.mid[di].isNotEmpty? Colors.yellow.shade100 : Colors.grey.shade100), child:Text(w.mid[di], style:TextStyle(fontSize:9), textAlign:TextAlign.center))),
                  // 3 KHALI NAVIN - BUS LATE
                  GestureDetector(onTap:()=>editCell(wi, di), child:Container(width:60, height:36, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: w.bus[di].contains("BUS")?Colors.red.shade100 : Colors.orange.shade50), child:Text(w.bus[di], style:TextStyle(fontSize:8, fontWeight:FontWeight.bold, color:Colors.red.shade800), textAlign:TextAlign.center, maxLines:2))),
                ]);
              }),
            ]);
          }).toList(),
          Padding(padding:EdgeInsets.all(8), child:Text("VAR=P/C OFF | MADHE=Sunday Tarikh I/II | KHALI=BUS LATE + Time", style:TextStyle(fontSize:10))),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(backgroundColor:Colors.orange, onPressed:(){
        var c=TextEditingController();
        showDialog(context:context, builder:(_)=>AlertDialog(title:Text("Navin Nav"), content:TextField(controller:c, decoration:InputDecoration(hintText:"Nav + Number", border:OutlineInputBorder())), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")), FilledButton(onPressed:(){if(c.text.isNotEmpty){setState(()=>workers.add(Worker("${workers.length+1})", c.text)));} Navigator.pop(context);}, child:Text("ADD"))]));
      }, label:Text("Add New Name", style:TextStyle(color:Colors.white)), icon:Icon(Icons.person_add, color:Colors.white)),
    );
  }
}
