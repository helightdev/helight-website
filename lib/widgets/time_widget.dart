import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeWidget extends StatefulWidget {
  const TimeWidget({Key? key}) : super(key: key);

  @override
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.addStatusListener((status) {
      setState(() {});
    });
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toLocal();
    var theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(now.hour.toString() +":" + now.minute.toString().padLeft(2, "0"), style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),),
          SizedBox(height: 2,),
          Text(now.day.toString().padLeft(2, "0") + "." + now.month.toString().padLeft(2, "0") + "." + now.year.toString(), style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),)
        ],
      ),
    );
  }
}
