import 'dart:io';
import 'package:airpay_package/airpay_package.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final bool isSandbox;
  Home({required this.isSandbox});

  @override
  _HomeState createState() => _HomeState(isSandbox: isSandbox);
}

class _HomeState extends State<Home> {
  final bool isSandbox;
  _HomeState({required this.isSandbox});

  bool isSuccess = false;
  bool isVisible = false;
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController orderId = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController fullAddress = TextEditingController();

  void _showAddress() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    super.initState();

    fname.text = "";
    lname.text = "";
    email.text = "";
    phone.text = "";
    fullAddress.text = "";
    pincode.text = "";
    orderId.text = "";
    amount.text = "";
    city.text = "";
    state.text = "";
    country.text = "";

    fname.text = "Yagnesh";
    lname.text = "Londhe";
    email.text = "yagnesh.londhe@wwindia.com";
    phone.text = "9870884171";
    fullAddress.text = "Mumbai";
    pincode.text = "600011";
    orderId.text = "2428";
    amount.text = "1.00";
    city.text = "testCity";
    state.text = "Maharastra";
    country.text = "India";
  }

  onComplete(status, response) {
    var resp = response.toJson();
    debugPrint('resp: ${resp.toString()}');
    var txtStsMsg = resp['STATUSMSG'] ?? "";
    var txtSts = resp['TRANSACTIONSTATUS'] ?? "";
    Navigator.pop(context);
    if (txtStsMsg == '') {
      // txtStsMsg = response['STATUSMSG'] ?? "";
      // txtSts = response['TRANSACTIONSTATUS'] ?? "";
    }
    if (txtStsMsg == 'Invalid Checksum') {
      // txtStsMsg = "Transaction Canceled";
    }

    AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            headerAnimationLoop: true,
            animType: AnimType.BOTTOMSLIDE,
            title: "AirPay",
            desc: 'Transaction Status: ' +
                txtSts +
                '\nTransaction Status Message: ' +
                txtStsMsg)
        .show();
  }

  void ValidateFields() {
    var msg = '';
    if (fname.text.length < 2) {
      msg = 'Enter first name';
    } else if (RegExp(r"^[a-zA-Z0-9]+$").hasMatch(fname.text) == false) {
      msg = 'Enter a valid first name';
    } else if (lname.text.isEmpty) {
      msg = 'Enter last name';
    } else if (RegExp(r"^[a-zA-Z0-9]+$").hasMatch(lname.text) == false) {
      msg = 'Enter a valid last name';
    } else if (email.text.isEmpty && phone.text.isEmpty) {
      msg = 'Enter an email ID or phone number';
    } else if (email.text.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email.text) ==
            false) {
      msg = "Please enter a valid email";
    } else if (phone.text.isNotEmpty && phone.text.length < 10) {
      msg = 'Enter a valid phone number';
    } else if (orderId.text.isEmpty) {
      msg = 'Enter order ID';
    } else if (amount.text.isEmpty) {
      msg = 'Enter an amount to proceed';
    } else if (amount.text == '0') {
      msg = 'Enter valid amount to proceed';
    }

    if (msg.isNotEmpty) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              headerAnimationLoop: true,
              animType: AnimType.BOTTOMSLIDE,
              title: "AirPay",
              btnOkOnPress: () {},
              btnOkColor: Colors.red,
              desc: msg)
          .show();
      return;
    }

    String domainPath = 'https://intschoolpay.nowpay.co.in/pay/index.php';

    String kAirPaySecretKey = 'A3brM5V9wjMWZh29';

    String kAirPayUserName = '5926256';

    String kAirPayPassword = 'me65Pf2K';

    String merchantID = '40594';

    String successURL =
        'https://intschoolpay.nowpay.co.in/"'; //'https://www.mosaics.amelio.in/';

/* For V3
    String domainPath = 'https://sushant.invoicepay.co.in/invoice/paymentResponse';

    String kAirPaySecretKey = '74QpNYaT1oyqhxdL';

    String kAirPayUserName = '8419743';

    String kAirPayPassword = 'JRLcAz5Y';

    String merchantID = '1';

    String successURL = 'https://sushant.invoicepay.co.in/invoice/paymentResponse'; 

*/

    // domainPath = '';
    //
    // kAirPaySecretKey = '';
    //
    // kAirPayUserName =  '';
    //
    // kAirPayPassword = '';
    //
    // merchantID = '';
    //
    // successURL = '';

    UserRequest user = UserRequest(
        username: kAirPayUserName,
        password: kAirPayPassword,
        secret: kAirPaySecretKey,
        merchantId: merchantID,
        protoDomain: domainPath,
        fname: fname.text,
        lname: lname.text,
        email: email.text,
        phone: phone.text,
        fulladdress: fullAddress.text,
        pincode: pincode.text,
        orderid: orderId.text,
        amount: amount.text,
        city: city.text,
        state: state.text,
        country: country.text,
        currency: "356",
        isCurrency: "INR",
        chMode: "",
        customVar: "test",
        txnSubtype: "",
        wallet: "0",
        isStaging: true, //True for the Staging
        successUrl: successURL,
        failedUrl:
            successURL); //'https://devel-ma.airpayme.com/airpay_php/responsefromairpay.php');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => new AirPay(
            user: user,
            closure: (status, response) => {onComplete(status, response)}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'assets/airpays.png',
            height: 40,
            color: Colors.white,
            width: 200,
          ),
          backgroundColor: Colors.blue[900],
        ),
        backgroundColor: Colors.grey[400],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(8.0, 8, 8.0, 4),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              'First Name *',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.blue[900]),
                            )),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                'Last Name *',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blue[900]),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              inputFormatters: [
                                // FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
                                new LengthLimitingTextInputFormatter(18),
                              ],
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: 'First Name',
                                //   contentPadding: EdgeInsets.all(2.0),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                              ),
                              controller: fname,
                            )),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  // FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
                                  new LengthLimitingTextInputFormatter(18),
                                ],
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  // contentPadding: EdgeInsets.all(2.0),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15.0),
                                ),
                                controller: lname,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          child: TextFormField(
                            /*validator: (value) => EmailValidator.validate(value)
                                ? null
                                : "Please enter a valid email",*/
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email Id',
                              // contentPadding: EdgeInsets.all(2.0),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                            ),
                            controller: email,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              new LengthLimitingTextInputFormatter(
                                  10), // for mobile
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                            decoration: InputDecoration(
                              hintText: 'Phone',
                              // contentPadding: EdgeInsets.all(2.0),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                            ),
                            controller: phone,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: true,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(8.0, 8, 8.0, 4),
                      color: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 8, 8.0, 4),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showAddress();
                                    },
                                    icon: isVisible
                                        ? Icon(Icons.arrow_drop_up)
                                        : Icon(Icons.arrow_drop_down),
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              Visibility(
                                visible: isVisible,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          //  FilteringTextInputFormatter.allow(RegExp(r'(^[0-9]{0,7}(?:\.[0-9]{0,2})?)')),

                                          new LengthLimitingTextInputFormatter(
                                              254),
                                        ],
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Full Address',
                                          // contentPadding: EdgeInsets.all(2.0),
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0),
                                        ),
                                        controller: fullAddress,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Container(
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          //  FilteringTextInputFormatter.allow(RegExp(r'(^[0-9]{0,7}(?:\.[0-9]{0,2})?)')),

                                          new LengthLimitingTextInputFormatter(
                                              18),
                                        ],
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'City Name',
                                          // contentPadding: EdgeInsets.all(2.0),
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0),
                                        ),
                                        controller: city,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'State Name',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.blue[900]),
                                        )),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Country Name',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.blue[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: TextFormField(
                                          inputFormatters: <TextInputFormatter>[
                                            //  FilteringTextInputFormatter.allow(RegExp(r'(^[0-9]{0,7}(?:\.[0-9]{0,2})?)')),

                                            new LengthLimitingTextInputFormatter(
                                                18),
                                          ],
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            hintText: 'State',
                                            //   contentPadding: EdgeInsets.all(2.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0),
                                          ),
                                          controller: state,
                                        )),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              //  FilteringTextInputFormatter.allow(RegExp(r'(^[0-9]{0,7}(?:\.[0-9]{0,2})?)')),

                                              new LengthLimitingTextInputFormatter(
                                                  18),
                                            ],
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                              hintText: 'Country ',
                                              // contentPadding: EdgeInsets.all(2.0),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0),
                                            ),
                                            controller: country,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Container(
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          new LengthLimitingTextInputFormatter(
                                              8),
                                        ],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'PinCode',
                                          // contentPadding: EdgeInsets.all(2.0),
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0),
                                        ),
                                        controller: pincode,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    )),
                Card(
                  margin: EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Transaction Information',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              'Order Id *',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.blue[900]),
                            )),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                'Amount *',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blue[900]),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(8),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'([a-zA-Z0-9])')),
                              ],
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: 'Order Id',
                                //   contentPadding: EdgeInsets.all(2.0),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                              ),
                              controller: orderId,
                            )),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'(^[0-9]{0,7}(?:\.[0-9]{0,2})?)')),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  // contentPadding: EdgeInsets.all(2.0),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15.0),
                                ),
                                controller: amount,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    // padding: EdgeInsets.fromLTRB(2.0, 11.0, 2.0, 11.0),
                    onPressed: () {
                      ValidateFields();
                    },
                    // color: Colors.blue[900],
                    child: Text(
                      'NEXT',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    // padding: EdgeInsets.fromLTRB(2.0, 11.0, 2.0, 11.0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    // color: Colors.blue[900],
                    child: Text(
                      'BACK',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
