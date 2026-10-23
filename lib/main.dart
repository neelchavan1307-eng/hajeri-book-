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

  Widget cell(String txt, {double w=28, Color? bg, bool bold=false, double h=32}){
    return Container(width:w, height:h, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.5,color:Colors.black54), color:bg), child:Text(txt, style:TextStyle(fontSize:10, fontWeight: bold?FontWeight.bold:FontWeight.normal), textAlign:TextAlign.center));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text("हजेरी बुक - MONTHLY MUSTER BOOK June 2026", style:TextStyle(fontWeight:FontWeight.bold, color:Colors.black, fontSize:13)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children:[
            Row(children:[
              cell("No.\nनंबर", w:40, h:40, bold:true, bg:Colors.grey.shade300),
              cell("Name\nनाव", w:130, h:40, bold:true, bg:Colors.grey.shade300),
              ...List.generate(30, (i){
                int d=i+1;
                bool isSun = sundays.contains(d);
                return cell("${isSun?"S":""}\n$d", w:32, h:40, bold:true, bg:isSun?Colors.yellow.shade200:Colors.grey.shade300);
              }),
            ]),
            ...workers.map((w){
              return Row(children:[
                cell(w.no, w:40, h:64),
                Container(width:130, height:64, decoration:BoxDecoration(border:Border.all(width:0.5)), padding:EdgeInsets.all(4), child:Text(w.name, style:TextStyle(fontSize:11, fontWeight:FontWeight.w500))),
                ...List.generate(30, (i){
                  return Column(children:[
                    GestureDetector(
                      onTap:(){
                        showDialog(context:context, builder:(_)=>AlertDialog(title:Text("${w.name.split("\n")[0]} - ${i+1}"), content:Wrap(spacing:6, children: ["P","PL","CL","W","A",""].map((e)=>ActionChip(label:Text(e.isEmpty?"Clear":e), onPressed:(){setState(()=>w.top[i]=e); Navigator.pop(context);})).toList())));
                      },
                      child: Container(width:32, height:32, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.5)), child:Text(w.top[i], style:TextStyle(fontSize:11, fontWeight:FontWeight.bold))),
                    ),
                    GestureDetector(
                      onTap:(){
                        showDialog(context:context, builder:(_)=>AlertDialog(title:Text("Shift - ${i+1}"), content:Wrap(spacing:6, children: ["I","II","III",""].map((e)=>ActionChip(label:Text(e.isEmpty?"Clear":e), onPressed:(){setState(()=>w.bottom[i]=e); Navigator.pop(context);})).toList())));
                      },
                      child: Container(width:32, height:32, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.5), color:Colors.grey.shade100), child:Text(w.bottom[i], style:TextStyle(fontSize:10))),
                    ),
                  ]);
                }),
              ]);
            }).toList(),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:Colors.orange,
        onPressed:(){
          var c=TextEditingController();
          showDialog(context:context, builder:(_)=>AlertDialog(
            title:Text("Navin Kamgar Add kara"),
            content:TextField(controller:c, autofocus:true, decoration:InputDecoration(hintText:"उदा. Shyam Jagtap\n3214 5157", border:OutlineInputBorder())),
            actions:[
              TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")),
              FilledButton(onPressed:(){
                if(c.text.isNotEmpty){
                  setState(()=>workers.add(Worker("${workers.length+1})", c.text)));
                }
                Navigator.pop(context);
              }, child:Text("ADD"))
            ]
          ));
        },
        label:Text("Add New Name", style:TextStyle(color:Colors.white)), icon:Icon(Icons.person_add, color:Colors.white),
      ),
    );
  }
}
