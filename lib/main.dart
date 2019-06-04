import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: InheretBloc(
        child: Center(
          child: Column(
            children: <Widget>[
              PageViewer(),
              PageIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class PageViewer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final InheretBloc bloc = InheretBloc.of(context);

    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.7,
      child: PageView(
        onPageChanged: bloc.bloc.changedSink.add,
        children: <Widget>[
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            color: Colors.red,
            child: Text("0"),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            color: Colors.green,
            child: Text("1"),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            color: Colors.yellow,
            child: Text("2"),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatefulWidget {
  //int index = 0;

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    final InheretBloc bloc = InheretBloc.of(context);
    return StreamBuilder<int>(
      stream: bloc.bloc.indexStream,
      initialData: 0,
      builder: (context, snapshot) {
        return Text("Index ${snapshot.data}");
      },
    );
  }
}

abstract class BlocBase {
  void dispose();
}

// Generic BLoC provider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class Bloc implements BlocBase{
  int _index;

  StreamController<int> _indexController = StreamController<int>();
  Sink<int> get _indexSink => _indexController.sink;
  Stream<int> get indexStream => _indexController.stream;

  StreamController<int> _changerController = StreamController<int>();
  Sink<int>  get changedSink => _changerController.sink;


  Bloc(){
    _index = 0;
    _changerController.stream.listen(_setIndex);
  }

  @override
  void dispose() {
    _indexController.close();
    _changerController.close();

  }

  void _setIndex(newValue){
    _index = newValue;
    _indexSink.add(_index);
    print(newValue);
  }

}

class InheretBloc extends InheritedWidget{
  final Widget child;
  final Bloc bloc = Bloc();

  InheretBloc({this.child});

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheretBloc of(BuildContext context){
    return context.inheritFromWidgetOfExactType(InheretBloc);
  }


}