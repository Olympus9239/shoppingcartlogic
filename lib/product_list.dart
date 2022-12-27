import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartlogic/cart_model.dart';
import 'package:shoppingcartlogic/cart_provider.dart';
import 'package:shoppingcartlogic/cart_screen.dart';
import 'package:shoppingcartlogic/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {


   DbHelper? dbHelper=DbHelper();
  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context,listen: false);
    return Scaffold(
     appBar: AppBar(
       title: Text("Product List"),
       centerTitle: true,
       actions: [
         InkWell(
           onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
           },
           child: Center(
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
         ),


       ],
     ),
      body: Column(
        children: [
          Expanded(

              child: ListView.builder(
                  itemCount: productName.length,
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
                       image:NetworkImage(productImage[index].toString())
                   ),
                       SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(productName[index].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                            SizedBox(height: 5,),
                            Text(productUnit[index].toString()+"  "+"Rs"+ productPrice[index].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 5,),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: (){
                                  dbHelper!.insert(
                                    Cart(id:index,
                                        productId:index.toString(),
                                        productName: productName[index].toString(),
                                        initialPrice:productPrice[index],
                                        productPrice:productPrice[index],
                                         quantity: 1,
                                         unitTag: productUnit[index].toString(),
                                          image: productImage[index].toString(),)
                                  ).then((value) {
                                    print('Product is added to cart');
                                    cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                    cart.addCounter();

                                  }
                                  ).onError((error, stackTrace) {
                                    print(error.toString());
                                  });
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

          ),

        ],
      ),

    );
  }

}


