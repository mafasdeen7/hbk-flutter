import 'package:flutter/material.dart';
import 'package:hbk/helpers/GlobalConstants.dart';
import 'package:hbk/providers/ContactUsProvider.dart';
import 'package:hbk/providers/MessageProvider.dart';
import 'package:hbk/providers/NewsProvider.dart';
import 'package:hbk/providers/NotificationProvider.dart';
import 'package:hbk/providers/PaySupplierProvider.dart';
import 'package:hbk/providers/PesoValueProvider.dart';
import 'package:hbk/providers/RequestQuoteProvider.dart';
import 'package:hbk/providers/SendEmailProvider.dart';
import 'package:hbk/providers/ShippingSummaryProvider.dart';
import 'package:hbk/providers/TipsProvider.dart';
import 'package:hbk/providers/UpdateContactsProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/AdminScreen.dart';
import 'package:hbk/screens/ContactUsScreen.dart';
import 'package:hbk/screens/ContactUsGuestScreen.dart';
import 'package:hbk/screens/FAQDetailScreen.dart';
import 'package:hbk/screens/FAQScreen.dart';
import 'package:hbk/screens/HomeScreen.dart';
import 'package:hbk/screens/MyAccount/ChangePasswordScreen.dart';
import 'package:hbk/screens/MyAccount/InboxDetailScreen.dart';
import 'package:hbk/screens/MyAccount/ShowFullScreenImage.dart';
import 'package:hbk/screens/MyAccount/ShowMyPriceQuoteDetailScreen.dart';
import 'package:hbk/screens/MyAccount/ShowMyPriceQuoteScreen.dart';
import 'package:hbk/screens/MyAccount/ShowMySupplierPaymentDetailScreen.dart';
import 'package:hbk/screens/MyAccount/ShowMySupplierPaymentsScreen.dart';
import 'package:hbk/screens/MyAccount/ShowShippingSummaryScreen.dart';
import 'package:hbk/screens/MyAccountScreen.dart';
import 'package:hbk/screens/NewsDetailScreen.dart';
import 'package:hbk/screens/NewsScreen.dart';
import 'package:hbk/screens/NotificationScreen.dart';
import 'package:hbk/screens/NotificationViewScreen.dart';
import 'package:hbk/screens/PaySupplierFinanceScreen.dart';
import 'package:hbk/screens/PaySupplierNextScreen.dart';
import 'package:hbk/screens/PaySupplierScreen.dart';
import 'package:hbk/screens/RequestAQuoteGuestScreen.dart';
import 'package:hbk/screens/RequestAQuoteScreen.dart';
import 'package:hbk/screens/ServicesScreen.dart';
import 'package:hbk/screens/ShipPackFromChinaScreen.dart';
import 'package:hbk/screens/ShipPackFromTaiwanScreen.dart';
import 'package:hbk/screens/TipsDetailScreen.dart';
import 'package:hbk/screens/TipsScreen.dart';
import 'package:provider/provider.dart';
import './providers/FAQProvider.dart';
import 'package:hbk/screens/Myaccount/MyProfileScreen.dart';
import 'package:hbk/screens/MyAccount/InboxScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: FAQProvider()),
        ChangeNotifierProvider.value(value: TipsProvider()),
        ChangeNotifierProvider.value(value: SendEmailProvider()),
        ChangeNotifierProvider.value(value: NewsProvider()),
        ChangeNotifierProvider.value(value: ContactUsProvider()),
        ChangeNotifierProvider.value(value: RequestQuoteProvider()),
        ChangeNotifierProvider.value(value: PaySupplierProvider()),
        ChangeNotifierProvider.value(value: PesoValueProvider()),
        ChangeNotifierProvider.value(value: ShippingSummaryProvider()),
        ChangeNotifierProvider.value(value: UpdateContactsProvider()),
        ChangeNotifierProvider.value(value: MessageProvider()),
        ChangeNotifierProvider.value(value: NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // navigatorKey: _navKey,
        title: GlobalConstants.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blue,
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(fontSize: 16),
              ),
        ),
        home: HomeScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ServicesScreen.routeName: (ctx) => ServicesScreen(),
          RequestAQuoteScreen.routeName: (ctx) => RequestAQuoteScreen(),
          RequestAQuoteGuestScreen.routeName: (ctx) => RequestAQuoteGuestScreen(),
          ContactUsScreen.routeName: (ctx) => ContactUsScreen(),
          ContactUsGuestScreen.routeName: (ctx) => ContactUsGuestScreen(),
          FAQScreen.routeName: (ctx) => FAQScreen(),
          TipsScreen.routeName: (ctx) => TipsScreen(),
          NewsScreen.routeName: (ctx) => NewsScreen(),
          ShipPackFromChinaScreen.routeName: (ctx) => ShipPackFromChinaScreen(),
          ShipPackFromTaiwanScreen.routeName: (ctx) =>
              ShipPackFromTaiwanScreen(),
          PaySupplierScreen.routeName: (ctx) => PaySupplierScreen(),
          PaySupplierFinanceScreen.routeName: (ctx) =>
              PaySupplierFinanceScreen(),
          FAQDetailScreen.routeName: (ctx) => FAQDetailScreen(),
          TipsDetailScreen.routeName: (ctx) => TipsDetailScreen(),
          NewsDetailScreen.routeName: (ctx) => NewsDetailScreen(),
          MyAccountScreen.routeName: (ctx) => MyAccountScreen(),
          MyProfileScreen.routeName: (ctx) => MyProfileScreen(),
          InboxScreen.routeName: (ctx) => InboxScreen(),
          ShowMyPriceQuoteScreen.routeName: (ctx) => ShowMyPriceQuoteScreen(),
          ShowMyPriceQuoteDetailScreen.routeName: (ctx) =>
              ShowMyPriceQuoteDetailScreen(),
          ShowShippingSummaryScreen.routeName: (ctx) =>
              ShowShippingSummaryScreen(),
          ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
          AdminScreen.routeName: (ctx) => AdminScreen(),
          ShowMySupplierPaymentsScreen.routeName: (ctx) =>
              ShowMySupplierPaymentsScreen(),
          ShowMySupplierPaymentDetailScreen.routeName: (ctx) =>
              ShowMySupplierPaymentDetailScreen(),
          ShowFullScreenImageScreen.routeName: (ctx) =>
              ShowFullScreenImageScreen(),
          InboxDetailScreen.routeName: (ctx) => InboxDetailScreen(),
          NotificationScreen.routeName: (ctx) => NotificationScreen(),
          NotificationViewScreen.routeName: (ctx) => NotificationViewScreen(),
          PaySupplierNextScreen.routeName: (ctx) => PaySupplierNextScreen(),
        },
      ),
    );
  }
}
