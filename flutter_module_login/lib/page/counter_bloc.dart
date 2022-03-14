import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, int> {



  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        // state - 1;
        yield state +1;
        break;
      case CounterEvent.decrement:
        yield state - 1;

        break;

      default:
        throw Exception('oops');
    }
  }

  CounterBloc():super(0);
}

enum CounterEvent { increment, decrement }
