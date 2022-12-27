import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartlogic/cart_provider.dart';
import 'package:shoppingcartlogic/db_helper.dart';

import 'cart_model.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper=DbHelper();
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context,value,child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white, ),);
                  },
                ),

                animationDuration: Duration(milliseconds: 300),
                child:   Icon(Icons.shopping_bag_outlined,size: 35,),

              ),
            ),
          ),


        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context,AsyncSnapshot<List<Cart>> snapshot){
                if(snapshot.hasData){
                return Expanded(
                    child:ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context,index){

                          return Card(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Image(
                                        height: 100,
                                        width: 100,
                                        image:NetworkImage(snapshot.data![index].image.toString())
                                    ),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(snapshot.data![index].productName.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                              InkWell(
                                                  onTap: (){
                                                    dbHelper.delete(snapshot.data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removetotalPrice(double.parse( snapshot.data![index].productPrice .toString()));
                                                  },
                                                  child: Icon(Icons.delete)),


                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Text(snapshot.data![index].unitTag .toString()+"  "+"Rs"+ snapshot.data![index].productPrice .toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                          SizedBox(height: 5,),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: (){

                                              },
                                              child: Container(
                                                height: 35,
                                                width: 100,
                                                child: Center(
                                                  child: Text("Add to Cart",style: TextStyle(color: Colors.white),),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    )

                                  ],
                                )
                              ],

                            ),
                          );

                        })
                );
                }else{

                }
                return Text('');
          }),
          Consumer<CartProvider>(builder: (context,value,child){
            return Column(
              children: [
                ReusableWidget(title: 'Sub Total', value: r'$'+value.getTotalPrice().toStringAsFixed(2)),
              ],
            );
          })
        ],
      ),
    );
  }
}


class ReusableWidget extends StatelessWidget {
  final String title,value;
  const ReusableWidget({required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString(),style:Theme.of(context).textTheme.subtitle2,)

        ],
      ),
    );
  }
}

