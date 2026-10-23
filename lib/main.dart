import 'package:flutter/material.dart';
void main()=>runApp(MaterialApp(home:Hajeri(),debugShowCheckedModeBanner:false));

class Worker{
  String name;
  List<String> status = List.filled(31, ""); // ""=absent, "P"=Present, "L"=Late Bus
  Worker(this.name);
}

class Hajeri extends StatefulWidget{State<Hajeri> createState()=>_HajeriState();}
class _HajeriState extends State<Hajeri>{
 List<Worker> list=[];
 final nameCtrl = TextEditingController();

 void add(){ if(nameCtrl.text.isEmpty) return; setState(()=>list.add(Worker(nameCtrl.text))); nameCtrl.clear(); }

 @override
 Widget build(BuildContext context){
  return Scaffold(
   appBar: AppBar(title:Text("Hajeri Book"), backgroundColor:Colors.orange),
   body: Column(children:[
    // ADD BAR
    Padding(padding:EdgeInsets.all(8), child: Row(children:[
      Expanded(child:TextField(controller:nameCtrl, decoration:InputDecoration(hintText:"Nav taka", border:OutlineInputBorder()))),
      SizedBox(width:8),
      ElevatedButton(onPressed:add, child:Text("ADD"))
    ])),

    // HEADER - 1st to 30
    Container(color:Colors.black87, padding:EdgeInsets.symmetric(vertical:8), child: Row(children:[
      Container(width:80, child:Text("  NAME", style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold))),
      ...List.generate(30, (i)=>Expanded(child:Text("${i+1}", textAlign:TextAlign.center, style:TextStyle(color:Colors.white, fontSize:11))))
    ])),

    // LIST
    Expanded(child:ListView.builder(itemCount:list.length, itemBuilder:(c,i){
      var w = list[i];
      return Column(children:[
        // Row 1 - Present
        Container(color:i%2==0?Colors.white:Colors.grey.shade100, child:Row(children:[
          Container(width:80, padding:EdgeInsets.all(8), child:Text(w.name, style:TextStyle(fontWeight:FontWeight.bold), overflow:TextOverflow.ellipsis)),
          ...List.generate(30, (d){
            return Expanded(child:GestureDetector(
              onTap:(){ setState((){
                if(w.status[d]=="") w.status[d]="P";
                else if(w.status[d]=="P") w.status[d]="L";
                else w.status[d]="";
              });},
              child:Container(margin:EdgeInsets.all(1), height:35, color: w.status[d]=="P"?Colors.green : w.status[d]=="L"?Colors.orange : Colors.grey.shade300, child:Center(child:Text(w.status[d], style:TextStyle(fontSize:10, fontWeight:FontWeight.bold)))),
            ));
          })
        ])),
        // Row 2 - Bus Late Label
        Container(color:Colors.orange.shade50, child:Row(children:[
          Container(width:80, padding:EdgeInsets.only(left:8, top:2, bottom:2), child:Text("Bus Late", style:TextStyle(fontSize:9, color:Colors.orange.shade800))),
          ...List.generate(30, (d){
            return Expanded(child:Container(margin:EdgeInsets.all(1), height:10, color: w.status[d]=="L"?Colors.orange : Colors.transparent));
          })
        ])),
        Divider(height:1)
      ]);
    }))
   ]),
   bottomNavigationBar: Container(padding:EdgeInsets.all(8), color:Colors.black12, child:Text("Tap kara: 1st tap = P (Present - Green), 2nd tap = L (Late Bus - Orange), 3rd tap = Khali", style:TextStyle(fontSize:11))),
  );
 }
}
