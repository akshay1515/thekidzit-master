import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/packageselection/customclipper.dart';
import 'package:kidzit/packageselection/packageprovider.dart';
import 'package:kidzit/packageselection/payment_screen.dart';
import 'package:kidzit/packageselection/plans_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageView extends StatefulWidget {
  static const tag = '-/packageView';

  const PackageView({Key? key}) : super(key: key);

  @override
  _PackageViewState createState() => _PackageViewState();
}

var user;

bool isUserdata = false;
bool isLoading = false;
bool userpacksge = false;
int plansduration = 0;
Package mypackage = Package(
    id: 0,
    title: '',
    isActive: false,
    endDate: '',
    startDate: '',
    features: [],
    price: 0);

class _PackageViewState extends State<PackageView> {
  Future<Map> getuserData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final temp = _preferences.getString('userid');
    if (temp != null) {
      user = _preferences.getString('userid').toString();
    }
    user = user.replaceAll('{', '');
    user = user.replaceAll('}', '');
    user = user.replaceAll('"', '');

    var used = user.split(",");
    Map myMap = {};
    var key = [], value = [];
    used.forEach((element) {
      var temp = [];
      temp = element.split(':');
      key.add(temp[0]);
      value.add(temp[1]);
    });
    for (int i = 0; i < key.length; i++) {
      myMap["${key[i]}"] = "${value[i]}";
    }
    user = myMap;
    return myMap;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final plans = Provider.of<PackageProvider>(context);
    final imei = Provider.of<LoginProvider>(context).identifier;
    final userdetails = ModalRoute.of(context)!.settings.arguments as Map;

    myPackage() {
      for (int i = 0; i < plans.item.plans!.length; i++) {
        for (int j = 0; j < plans.item.plans![i].package!.length; j++) {
          if (plans.item.plans![i].package![j].isActive == true) {
            mypackage = Package(
                id: plans.item.plans![i].package![j].id,
                title: plans.item.plans![i].package![j].title,
                price: plans.item.plans![i].package![j].price,
                isActive: plans.item.plans![i].package![j].isActive,
                startDate: plans.item.plans![i].package![j].startDate,
                endDate: plans.item.plans![i].package![j].endDate,
                features: plans.item.plans![i].package![j].features);
          } else {}
        }
      }
    }

    if (isUserdata) {
      Provider.of<PackageProvider>(context, listen: false)
          .getPackageDetails(user['userid'])
          .then((value) {
            plans.getRazorpay();
        myPackage();
        if(mounted) {
          setState(() {
            isLoading = true;
          });
        }
      });
    }

    String converttoMonths(int? days) {
      if (days! < 30) {
        return '$days Days';
      } else {
        return '${(days / 30).toStringAsFixed(0)} Months';
      }
    }

    return Scaffold(
      body: isLoading
          ? SingleChildScrollView(
              child: Column(children: [
                ClipPath(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: size.width,
                    height: size.height * 0.25,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/circular.png'),
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topRight),
                        gradient: LinearGradient(
                          colors: [Color(0xffce93d6), Color(0xffefe1f2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      primary: Colors.transparent,
                                      elevation: 0,
                                      minimumSize: const Size(45, 45),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100))),
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 25,
                                  ),
                                  label: const Text(''),
                                ),
                                const Text(
                                  'Premium',
                                  style: TextStyle(
                                    fontFamily: 'SourceSandPro',
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.030,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Select Plan Type',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.5),
                              ),
                            ),
                            // const Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                  clipper: CustomClipPath(),
                ),
                Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: mypackage.id == 0
                              ? const DecorationImage(
                                  image:
                                      AssetImage('assets/transbackground.png'),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topRight)
                              : const DecorationImage(
                                  image: AssetImage('assets/flower.png'),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topRight),
                          gradient: LinearGradient(
                            colors: mypackage.id == 0
                                ? const [Color(0xFFD8D8D8), Color(0xFFE0E0E0)]
                                : const [Color(0xffce93d6), Color(0xffefe1f2)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          )),
                      constraints: const BoxConstraints(
                          minHeight: 115,
                          minWidth: double.infinity,
                          maxHeight: 115),
                      child: mypackage.id != 0
                          ? Column(children: [
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      'Current Subscription : ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${mypackage.title} Plan',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                        Text(
                                          '  for ₹ ${mypackage.price}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ]),
                              const SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Starts from:  ${mypackage.startDate} Plan',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      'Valid till:  ${mypackage.endDate}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            ])
                          : const Center(
                              child: Text(
                              'You don\'t have any active subscription',
                              style: TextStyle(fontSize: 20),
                            )),
                    )),
                Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: plans.item.plans!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  plans.changeDuration(index);
                                  plans.changePackage(0);
                                  setState(() {
                                   plansduration = index;
                                 });

                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    constraints: const BoxConstraints(minWidth: 100),
                                    decoration: BoxDecoration(
                                        color: plans.durationselector == index
                                            ? const Color(0xFFce93d6)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                                plans.durationselector != index
                                                    ? const Color(0xFFce93d6)
                                                    : Colors.transparent,
                                            style: BorderStyle.solid,
                                            width: 1)),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      converttoMonths(
                                          plans.item.plans![index].duration),
                                      style: TextStyle(
                                          color: plans.durationselector == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            );
                          }),
                    )
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: int.parse('${plans.item.plans![plans.durationselector].package!.length}'),
                    itemBuilder: (_,i){
                  return Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                              style: BorderStyle.solid)),
                    ),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: MaterialButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 8, right: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        if(plans.durationselector == plansduration){
                          plans.changePackage(i);
                        }else{

                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 25,
                            width: 25,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: plans.durationselector == plansduration ?
                                    plans.packageselector == i
                                        ? const Color(0xFFce93d6)
                                        : Colors.grey
                                    :Colors.grey,
                                    width: 1)),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: plans.durationselector == plansduration ?
                                  plans.packageselector == i
                                      ? const Color(0xFFce93d6)
                                      : Colors.transparent
                                      :Colors.transparent,),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            plans.item.plans![plans.durationselector].package![i].title.toString(),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: plans.durationselector == plansduration ?
                                plans.packageselector == i
                                    ? FontWeight.bold
                                    : FontWeight.w300
                            :FontWeight.w300),
                          ),
                          const  Spacer(),
                          Text(
                            '₹ ${plans.item.plans![plans.durationselector].package![i].price}',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: plans.durationselector == plansduration ?
                                plans.packageselector == i
                                    ? FontWeight.bold
                                    : FontWeight.w300
                                    :FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                ListView.builder(
                    shrinkWrap: true,
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 10),
                    physics:const NeverScrollableScrollPhysics(),
                    itemCount: (plans.item.plans![plans.durationselector].package![plans.packageselector].features!.length),

                    itemBuilder: (_, index) {

                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 4.0,top:4.0,bottom:4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                alignment: Alignment.center,
                                child: Text(
                                  plans.item.plans![plans.durationselector].package![plans.packageselector]
                                      .features![index].title.toString(),
                                  style:const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                              ),
                              const SizedBox(height:10),
                              SizedBox(
                                child: Html(
                                   data: plans.item.plans![plans.durationselector].package![plans.packageselector].features![index].image,
                                )
                              ),
                            ],
                          ),
                        );

                    }),
                const SizedBox(height: 70,),
                MaterialButton(
                  onPressed: () {
                    plansduration = 0;
                    Navigator.of(context).pushNamed(
                        PaymentScreen.tag,arguments: {
                      'name' : userdetails['name'],
                      'email': userdetails['email'],
                      'mobile': userdetails['mobile'],
                      'imei' : imei,
                      'userid' : userdetails['userid'],
                      'planid' :  plans.item.plans![plans.durationselector].package![plans.packageselector].id,
                      'amount' :  plans.item.plans![plans.durationselector].package![plans.packageselector].price,
                      'title' :  plans.item.plans![plans.durationselector].package![plans.packageselector].title,
                      'duration' :  plans.item.plans![plans.durationselector].duration,
                    }).then((value) {
                      plans.changePackage(0);
                      plans.changeDuration(0);
                    });
                  },
                  child: const  Padding(
                    padding:  EdgeInsets.all(14),
                    child: Text(
                      'Go Premium',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      softWrap: true,
                    ),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  color: const Color(0xFFce93d6),
                ),
                const SizedBox(height:20)
              ]),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    super.initState();
    getuserData().then((value) {
      setState(() {
        isUserdata = true;
      });
    });
  }
}
