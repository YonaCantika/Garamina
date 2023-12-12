import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/img/slider/1.JPG',
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/img/slider/2.JPG',
            ),
          ),
        ],
      ),
    );
  }
}
