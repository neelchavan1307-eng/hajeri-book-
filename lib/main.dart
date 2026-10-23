import 'package:flutter/material.dart';
void main()=>runApp(MaterialApp(home:MusterBook(),debugShowCheckedModeBanner:false));

class Worker{
  String no, name;
  List<String> top = List.filled(31, "");
  List<String> bottom = List.filled(31, "");
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

  int getNextSunday(int currentDayIndex){
    int day = currentDayIndex + 1;
    for(int s in sundays){ if(s > day) return s; }
    return day+1; // last
  }

  void editCell(int wi, int di){
    var topCtrl = TextEditingController(text: workers[wi].top[di]);
    var bottomCtrl = TextEditingController(text: workers[wi].bottom[di]);
    int nextSun = getNextSunday(di);
    
    showDialog(context:context, builder:(_)=>AlertDialog(
      title: Text("${workers[wi].name.split("\n")[0]} - ${di+1} तारीख"),
      content: SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children:[
        Text("VAR - C OFF / P / PL", style:TextStyle(fontWeight:FontWeight.bold, fontSize:12)),
        TextField(controller: topCtrl, onChanged: (v){
          if(v.toUpperCase().contains("C OFF") || v.toUpperCase().contains("OFF")){
            if(bottomCtrl.text.isEmpty){
              bottomCtrl.text = "$nextSun";
            }
          }
        }, decoration:InputDecoration(hintText:'P, PL, C OFF, 6 OFF', border:OutlineInputBorder())),
        SizedBox(height:5),
        Wrap(spacing:4, runSpacing:4, children: ["P","PL","CL","C OFF","6 OFF","BUS LATE","BUS LATE 11.50"].map((e)=>ActionChip(label:Text(e, style:TextStyle(fontSize:10)), onPressed:(){
          topCtrl.text=e;
          // AUTO SUNDAY
          if(e.contains("OFF")){
            bottomCtrl.text = "$nextSun";
            setState((){}); // refresh dialog text
          }
        })).toList()),
        
        SizedBox(height:14),
        Text("KHALI - Sunday tarikh / Shift (EDIT karu shakta)", style:TextStyle(fontWeight:FontWeight.bold, fontSize:12, color:Colors.blue.shade800)),
        Row(children:[
          Expanded(child:TextField(controller: bottomCtrl, decoration:InputDecoration(hintText:'Sunday tarikh - 7, 14...', border:OutlineInputBorder(), suffixIcon:Icon(Icons.edit)))),
          SizedBox(width:6),
          FilledButton.tonal(onPressed:(){ bottomCtrl.text="$nextSun"; }, child:Text("S $nextSun", style:TextStyle(fontSize:11)))
        ]),
        SizedBox(height:5),
        Wrap(spacing:4, children: ["I","II","III","7","14","21","28","7/16","11.50"].map((e)=>ActionChip(label:Text(e, style:TextStyle(fontSize:10)), onPressed:(){bottomCtrl.text=e;})).toList(),
      ])),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")),
        FilledButton(onPressed:(){
          setState((){
            workers[wi].top[di]=topCtrl.text;
            workers[wi].bottom[di]=bottomCtrl.text; // EDITABLE
          });
          Navigator.pop(context);
        }, child:Text("SAVE"))
      ],
    ));
  }

  Widget cell(String txt, {double w=28, Color? bg, bool bold=false, double h=40}){
    return Container(width:w, height:h, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6,color:Colors.black), color:bg), child:Text(txt, style:TextStyle(fontSize:10, fontWeight: bold?FontWeight.bold:FontWeight.normal), textAlign:TextAlign.center));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("हजेरी बुक - MONTHLY MUSTER BOOK June 2026", style:TextStyle(fontWeight:FontWeight.bold, fontSize:13, color:Colors.black)), backgroundColor:Colors.white),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children:[
          Row(children:[
            cell("No.\nनंबर", w:40, h:45, bold:true, bg:Colors.grey.shade300),
            cell("Name\nनाव", w:130, h:45, bold:true, bg:Colors.grey.shade300),
            ...List.generate(30, (i){int d=i+1; bool isSun=sundays.contains(d); return cell("${isSun?"S":""}\n$d", w:52, h:45, bold:true, bg:isSun?Colors.yellow.shade300:Colors.grey.shade300);}),
          ]),
          ...workers.asMap().entries.map((entry){
            int wi=entry.key; var w=entry.value;
            return Row(children:[
              cell(w.no, w:40, h:72),
              Container(width:130, height:72, decoration:BoxDecoration(border:Border.all(width:0.6)), padding:EdgeInsets.all(4), child:Text(w.name, style:TextStyle(fontSize:11))),
              ...List.generate(30, (di){
                return Column(children:[
                  GestureDetector(onTap:()=>editCell(wi, di), child:Container(width:52, height:36, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: w.top[di].contains("OFF")?Colors.purple.shade100 : w.top[di].contains("PL")?Colors.orange.shade100 : w.top[di]=="P"?Colors.green.shade100 : Colors.white), child:Text(w.top[di], style:TextStyle(fontSize:9, fontWeight:FontWeight.bold), textAlign:TextAlign.center))),
                  GestureDetector(onTap:()=>editCell(wi, di), child:Container(width:52, height:36, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.6), color: w.bottom[di].isNotEmpty? Colors.yellow.shade100 : Colors.grey.shade100), child: Row(mainAxisAlignment:MainAxisAlignment.center, children:[Text(w.bottom[di], style:TextStyle(fontSize:10)), if(w.bottom[di].isNotEmpty && int.tryParse(w.bottom[di])!=null) Icon(Icons.edit, size:8)]) )),
                ]);
              }),
            ]);
          }).toList(),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(backgroundColor:Colors.orange, onPressed:(){
        var c=TextEditingController();
        showDialog(context:context, builder:(_)=>AlertDialog(title:Text("Navin Nav"), content:TextField(controller:c, decoration:InputDecoration(hintText:"Nav + Number", border:OutlineInputBorder())), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")), FilledButton(onPressed:(){if(c.text.isNotEmpty){setState(()=>workers.add(Worker("${workers.length+1})", c.text)));} Navigator.pop(context);}, child:Text("ADD"))]));
      }, label:Text("Add New Name", style:TextStyle(color:Colors.white)), icon:Icon(Icons.person_add, color:Colors.white)),
    );
  }
        }
