import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/bookmark_icon_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/bookmark/bookmark_icon_widget.dart';
import 'package:restaurant_app/screen/detail/body_of_detail_screen_widget.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
        .read<RestaurantDetailProvider>()
        .fetchRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Detail"), actions: [
        ChangeNotifierProvider(
          create: (context) => BookmarkIconProvider(),
          child: Consumer<RestaurantDetailProvider>(
            builder: (context, value, child) {
              return switch (value.resultState) {
                RestaurantDetailLoadedState(data: var restaurant) =>
                  BookmarkIconWidget(restaurant: restaurant),
                _ => const SizedBox(),
              };
            },
          ),
        )
      ]),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantDetailLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            RestaurantDetailLoadedState(data: var restaurant) =>
              BodyOfDetailScreenWidget(restaurant: restaurant),
            RestaurantDetailErrorState(error: var message) => Center(
                child: Text(message),
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
