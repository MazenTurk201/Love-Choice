// ignore_for_file: file_names, sized_box_for_whitespace
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class SkiletonSkin extends StatefulWidget {
  final SkiletonStyle style;
  final bool? heigh;

  const SkiletonSkin({
    super.key,
    this.style = SkiletonStyle.oneCard,
    this.heigh,
  });

  @override
  State<SkiletonSkin> createState() => _SkiletonSkinState();
}

enum SkiletonStyle { iconsrow, oneCard }

class _SkiletonSkinState extends State<SkiletonSkin> {
  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case SkiletonStyle.iconsrow:
        return Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 20, spreadRadius: 3),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
              ).redacted(context: context, redact: true),
              Container(
                width: 50,
                height: 50,
              ).redacted(context: context, redact: true),
              Container(
                width: 50,
                height: 50,
              ).redacted(context: context, redact: true),
            ],
          ),
        ).redacted(context: context, redact: true);

      case SkiletonStyle.oneCard:
        return Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            height: (widget.heigh ?? false)
                ? 300
                : MediaQuery.of(context).size.height / 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "images/quiz1.jpg",
                      fit: BoxFit.cover,
                    ).redacted(context: context, redact: true),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 100,
                        height: 50,
                      ).redacted(context: context, redact: true),
                    ),
                    Center(
                      child: Text(
                        'fetching data',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ).redacted(context: context, redact: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // spacing: 50,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                          ).redacted(context: context, redact: true),
                          Container(
                            width: 50,
                            height: 50,
                          ).redacted(context: context, redact: true),
                          Container(
                            width: 50,
                            height: 50,
                          ).redacted(context: context, redact: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  }

  Container towCardMethod(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "images/quiz1.jpg",
                fit: BoxFit.cover,
              ).redacted(context: context, redact: true),
            ),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "jskfjks",
                  style: TextStyle(
                    fontSize: 30,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ).redacted(context: context, redact: true),
              ),
              Text(
                'fetching data',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ).redacted(context: context, redact: true),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                    ).redacted(context: context, redact: true),
                    Container(
                      width: 50,
                      height: 50,
                    ).redacted(context: context, redact: true),
                    Container(
                      width: 50,
                      height: 50,
                    ).redacted(context: context, redact: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
