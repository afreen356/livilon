import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/cart/data/cart_service.dart';
import 'package:livilon/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:livilon/features/home/data/chat_service.dart';
import 'package:livilon/features/home/presentation/bloc/address/address_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_event.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/products/homebloc.dart';

import 'package:livilon/features/home/presentation/screen/showproduct_screen.dart';
import 'package:livilon/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:livilon/features/auth/presentation/bloc/forgetpass/forgot_password_bloc.dart';
import 'package:livilon/features/auth/presentation/screen/logo_screen.dart';
import 'package:livilon/features/auth/presentation/screen/user_login.dart';
import 'package:livilon/features/wishlist/data/wishlist_service.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:livilon/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:livilon/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ForgotPasswordBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
          child: const UserLoginScreen(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
          child: ShowProducts(categoryId: ''),
        ),
        BlocProvider(
            create: (context) =>
                FavouriteBloc(FavouritesRepositoryImplementation())
                  ..add(LoadFavouritesEvent()),
                  ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(CartRepositoryImplementation()),
        ),
        BlocProvider(create: (context)=>DimensionBloc()),
        BlocProvider(
          create: (context) => AddressCheckBoxBloc(),
          
        ),
        BlocProvider(
          create: (context) => ChatBloc(ChatService())..add(LoadMessages())
          
        )
       
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            appBarTheme:
                AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home:const LogoScreen()),
    );
  }
}
