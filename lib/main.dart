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

  Color getColor(String s){
    if(s=="P") return Colors.green.shade200;
    if(s=="PL") return Colors.orange.shade200;
    if(s=="CL") return Colors.red.shade200;
    if(s=="I"||s=="II"||s=="III") return Colors.blue.shade100;
    return Colors.white;
  }

  void onTapTop(int wi, int di){
    setState((){
      var cur = workers[wi].top[di];
      if(cur=="") workers[wi].top[di]="P";
      else if(cur=="P") workers[wi].top[di]="PL";
      else if(cur=="PL") workers[wi].top[di]="CL";
      else workers[wi].top[di]="";
    });
  }
  void onTapBottom(int wi, int di){
    setState((){
      var cur = workers[wi].bottom[di];
      if(cur=="") workers[wi].bottom[di]="I";
      else if(cur=="I") workers[wi].bottom[di]="II";
      else if(cur=="II") workers[wi].bottom[di]="III";
      else workers[wi].bottom[di]="";
    });
  }

  Widget cell(String txt, {double w=28, Color? bg, bool bold=false, double h=32}){
    return Container(width:w, height:h, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.5,color:Colors.black54), color:bg), child:Text(txt, style:TextStyle(fontSize:10, fontWeight: bold?FontWeight.bold:FontWeight.normal), textAlign:TextAlign.center));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("हजेरी बुक - MONTHLY MUSTER BOOK June 2026", style:TextStyle(fontWeight:FontWeight.bold, fontSize:13, color:Colors.black)), backgroundColor:Colors.white),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children:[
          Row(children:[
            cell("No.\nनंबर", w:40, h:40, bold:true, bg:Colors.grey.shade300),
            cell("Name\nनाव", w:130, h:40, bold:true, bg:Colors.grey.shade300),
            ...List.generate(30, (i){int d=i+1; bool isSun=sundays.contains(d); return cell("${isSun?"S":""}\n$d", w:38, h:40, bold:true, bg:isSun?Colors.yellow.shade300:Colors.grey.shade300);}),
          ]),
          ...workers.asMap().entries.map((entry){
            int wi=entry.key; var w=entry.value;
            return Row(children:[
              cell(w.no, w:40, h:70),
              Container(width:130, height:70, decoration:BoxDecoration(border:Border.all(width:0.5)), padding:EdgeInsets.all(4), child:Row(children:[Expanded(child:Text(w.name, style:TextStyle(fontSize:11))), IconButton(icon:Icon(Icons.close,size:14), onPressed:(){setState(()=>workers.removeAt(wi));})])),
              ...List.generate(30, (di){
                return Column(children:[
                  GestureDetector(onTap:()=>onTapTop(wi,di), child:Container(width:38, height:35, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.5), color:getColor(w.top[di])), child:Text(w.top[di], style:TextStyle(fontSize:12, fontWeight:FontWeight.bold)))),
                  GestureDetector(onTap:()=>onTapBottom(wi,di), child:Container(width:38, height:35, alignment:Alignment.center, decoration:BoxDecoration(border:Border.all(width:0.5), color:getColor(w.bottom[di])), child:Text(w.bottom[di], style:TextStyle(fontSize:11)))),
                ]);
              }),
            ]);
          }).toList(),
          SizedBox(height:10),
          Container(padding:EdgeInsets.all(8), color:Colors.black12, child:Text("Tap: वर = P(green) -> PL(orange) -> CL(red) | खाली = I -> II -> III", style:TextStyle(fontSize:11))),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:Colors.orange,
        onPressed:(){
          var c=TextEditingController();
          showDialog(context:context, builder:(_)=>AlertDialog(title:Text("Navin Nav"), content:TextField(controller:c, autofocus:true, decoration:InputDecoration(hintText:"Nav + Number", border:OutlineInputBorder())), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text("Cancel")), FilledButton(onPressed:(){if(c.text.isNotEmpty){setState(()=>workers.add(Worker("${workers.length+1})", c.text)));} Navigator.pop(context);}, child:Text("ADD"))]));
        },
        label:Text("Add New Name", style:TextStyle(color:Colors.white)), icon:Icon(Icons.person_add, color:Colors.white),
      ),
    );
  }
}
