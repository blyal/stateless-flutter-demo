import 'package:flutter/material.dart';
import './data_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final counter = ProvidableValue(initial: 0);

  @override
  Widget build(BuildContext context) {
    return DataProvider<ProvidableValue<int>>(
        builder: (context) => MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MyHomePage(title: 'Alex\'s Stateless Flutter Demo'),
            ),
        data: counter);
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final myApp = ancestorOf<MyApp>(context);

    void incrementCounter() {
      myApp.counter.value = myApp.counter.value + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ProvidableValueConsumer(
                providableValue: myApp.counter,
                builder: (context, counter) => Text(
                      '$counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
