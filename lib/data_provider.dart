import 'dart:async';
import 'package:flutter/material.dart';

class ProvidableValue<T> {
  final _controller = StreamController<T>();
  late Stream<T> _stream;
  late T _value;

  ProvidableValue({
    required T initial,
  }) {
    _value = initial;
    _stream = _controller.stream.asBroadcastStream();
  }

  T get value => _value;

  Stream<T> get stream => _stream;

  void notify(T data) => _controller.add(data);

  set value(T data) {
    _value = data;
    notify(data);
  }
}

//####################################################################################

class ProvidableValueConsumer<T> extends StatefulWidget {
  final Widget Function(BuildContext, T) builder;
  final ProvidableValue<T> providableValue;

  const ProvidableValueConsumer({
    Key? key,
    required this.providableValue,
    required this.builder,
  }) : super(key: key);

  @override
  State<ProvidableValueConsumer<T>> createState() =>
      _ProvidableValueConsumerState<T>();
}

class _ProvidableValueConsumerState<T>
    extends State<ProvidableValueConsumer<T>> {
  StreamSubscription<T>? _subscription;
  late T _value;

  @override
  void initState() {
    super.initState();
    final providableValue = widget.providableValue;
    _value = providableValue.value;
    _subscription = providableValue.stream.listen((data) {
      setState(() {
        _value = data;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}

//####################################################################################

class DataProvider<T> extends StatelessWidget {
  final WidgetBuilder builder;
  final T data;

  const DataProvider({Key? key, required this.builder, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) => builder(context);
}

//####################################################################################

T ancestorOf<T extends Widget>(BuildContext context) {
  final widget = context.findAncestorWidgetOfExactType<T>();
  if (widget != null) {
    return widget;
  }
  throw Exception('Ancestor widget "${T.toString()}" not found.');
}
