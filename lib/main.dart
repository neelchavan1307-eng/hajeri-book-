import 'package:flutter/material.dart';
void main()=>runApp(MaterialApp(home:Hajeri(),debugShowCheckedModeBanner:false));
class Worker{String name; int rate; List<bool> att=List.filled(31,false); Worker(this.name,this.rate);}
class Hajeri extends StatefulWidget{State<Hajeri> createState()=>_HajeriState();}
class _HajeriState extends State<Hajeri>{
 List<Worker> list=[];
 final n=TextEditingController(), r=TextEditingController();
 void add(){
  if(n.text.isEmpty||r.text.isEmpty) return;
  setState(()=>list.add(Worker(n.text,int.parse(r.text))));
  n.clear();r.clear();
 }
 @override
 Widget build(BuildContext c){
  return Scaffold(
   appBar: AppBar(title:Text("Hajeri Book - neelcha"), backgroundColor:Colors.orangeAccent, foregroundColor:Colors.black),
   body:Column(children:[
    Padding(padding:EdgeInsets.all(8),child:Row(children:[
     Expanded(child:TextField(controller:n,decoration:InputDecoration(hintText:"Nav",border:OutlineInputBorder()))),
     SizedBox(width:6),
     Expanded(child:TextField(controller:r,decoration:InputDecoration(hintText:"Rate Rs",border:OutlineInputBorder()),keyboardType:TextInputType.number)),
     SizedBox(width:6),
     ElevatedButton(onPressed:add,child:Text("ADD"))
    ])),
    Expanded(child:ListView.builder(itemCount:list.length,itemBuilder:(c,i){
     var w=list[i]; int present=w.att.where((e)=>e).length;
     return Card(child:ListTile(
      title:Text("${w.name} - Rs.${w.rate}/day"),
      subtitle:Text("Hajeri: $present / 31 = Rs.${present*w.rate}"),
      trailing:Wrap(children:List.generate(7,(d)=>Checkbox(value:w.att[d],onChanged:(v)=>setState(()=>w.att[d]=v!)))),
      onTap:()=>showDialog(context:c,builder:(_)=>AlertDialog(title:Text(w.name),content:Wrap(children:List.generate(31,(d)=>Column(children:[Text("${d+1}"),Checkbox(value:w.att[d],onChanged:(v)=>setState(()=>w.att[d]=v!))]))),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:Text("OK"))])),
     ));
    }))
   ]),
  );
 }
}
