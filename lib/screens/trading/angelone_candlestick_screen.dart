import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../services/angelone_candle_api.dart';

class AngelOneCandlestickScreen extends StatefulWidget {
  final String exchange;
  final String symbolToken;
  final String symbol;
  const AngelOneCandlestickScreen({super.key, required this.exchange, required this.symbolToken, required this.symbol});
  @override State<AngelOneCandlestickScreen> createState() => _AngelOneCandlestickScreenState();
}

class _AngelOneCandlestickScreenState extends State<AngelOneCandlestickScreen> {
  String interval = 'FIVE_MINUTE';
  List<List<dynamic>> candles = [];
  bool loading = true;
  String? error;

  final options = const {'1D':'FIVE_MINUTE','1W':'THIRTY_MINUTE','1M':'ONE_HOUR','1Y':'ONE_DAY'};

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final now = DateTime.now();
      final days = interval == 'ONE_DAY' ? 365 : interval == 'ONE_HOUR' ? 30 : interval == 'THIRTY_MINUTE' ? 7 : 1;
      final data = await AngelOneCandleApi.candles(widget.exchange, widget.symbolToken, interval, now.subtract(Duration(days: days)), now);
      setState(() { candles = data; loading = false; error = null; });
    } catch (e) { setState(() { loading = false; error = e.toString(); }); }
  }

  @override void initState() { super.initState(); load(); }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.symbol)),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: SegmentedButton<String>(segments: options.keys.map((x) => ButtonSegment(value:x,label:Text(x))).toList(), selected: {options.entries.firstWhere((e)=>e.value==interval).key}, onSelectionChanged:(s){setState(()=>interval=options[s.first]!);load();})),
      if (loading) const Expanded(child: Center(child:CircularProgressIndicator()))
      else if (error != null) Expanded(child: Center(child: Column(mainAxisSize:MainAxisSize.min,children:[Text(error!),const SizedBox(height:12),FilledButton(onPressed:load,child:const Text('Retry'))])))
      else Expanded(child: Padding(padding:const EdgeInsets.all(12),child:CustomPaint(painter:_CandlePainter(candles),child:const SizedBox.expand())))
    ]));
}

class _CandlePainter extends CustomPainter {
  final List<List<dynamic>> data; _CandlePainter(this.data);
  @override void paint(Canvas c, Size s) {
    if(data.isEmpty) return;
    final parsed=data.map((x)=>[double.parse('${x[1]}'),double.parse('${x[2]}'),double.parse('${x[3]}'),double.parse('${x[4]}')]).toList();
    final lo=parsed.map((x)=>x[2]).reduce(math.min), hi=parsed.map((x)=>x[1]).reduce(math.max), span=(hi-lo)==0?1:hi-lo;
    final w=s.width/parsed.length;
    for(var i=0;i<parsed.length;i++) { final o=parsed[i][0], h=parsed[i][1], l=parsed[i][2], cl=parsed[i][3]; final x=i*w+w/2; final y(double v)=>s.height-(v-lo)/span*s.height; c.drawLine(Offset(x,y(h)),Offset(x,y(l)),Paint()..strokeWidth=1); final top=y(math.max(o,cl)), bottom=y(math.min(o,cl)); c.drawRect(Rect.fromLTRB(x-w*.3,top,x+w*.3,math.max(bottom,top+1)),Paint()..style=PaintingStyle.fill); }
  }
  @override bool shouldRepaint(covariant _CandlePainter old) => old.data != data;
}
