# BLOC/CUBIT memento

## Définition d'un bloc ou d'un cubit

### 1 - State

* Contient des objets affichés dans des `Widgets`
* Extends `Equatable`
* Implements `copyWith(...args)`
* /!\ pas de abstract avec héritage.

```dart
class MyBlocOrCubitState extends Equatable {
  final int count;
  final String name;

  const MyBlocOrCubitState({required this.count, required this.name});

  @override
  List<Object?> get props => [count, name];

  // defines a default state to bloc constructor
  factory MyBlocOrCubitState.initial() {
    return const MyBlocOrCubitState(count: 0, name: '');
  }

  // enables bloc to change state
  MyBlocOrCubitState copyWith({int? count, String? name}) {
    return MyBlocOrCubitState(
      count: count ?? this.count,
      name: name ?? this.name,
    );
  }
}
```

### 2 - cubit

* contient des fonctions déclenchés par des `Widgets`

```dart
class MyCubit extends Cubit<MyBlocOrCubitState> {
  MyCubit() : super(MyBlocOrCubitState.initial());

  void selectItem() => emit(state.copyWith(count: 1));
  void loadView() => emit(state.copyWith(name: ''));
}
```

### 3 -  bloc

* Déclare des évènements liés aux actions possible sur les `Widgets`.
* ces évements génèrent des changements d'états `emit(state.copyWith(...))`

```dart
// bloc events
sealed class MyBlocEvents {}

class MyBlocOnViewLoaded extends MyBlocEvents {}
class MyBlocOnSelectItem extends MyBlocEvents {}

// bloc
class MyBloc extends Bloc<MyBlocEvents, MyBlocOrCubitState> {
  MyBloc() : super(MyBlocState.initial()) {
    on<MyBlocOnViewLoaded>(_handleViewLoaded);
    on<MyBlocOnSelectItem>(_handleItemSeleted);
  }

  void _handleItemSeleted(MyBlocEvents event, Emitter emit) =>
      emit(state.copyWith(count: 1));

  void _handleViewLoaded(MyBlocEvents event, Emitter emit) =>
      emit(state.copyWith(name: ''));
}

```

## 3 étapes

### 1. Création

```dart
BlocProvider(
  create: (_) => MyBloc(),
  child: MyWidget()
);
```

### 2. Appeler un évenement

#### cubit

```dart
context.read<MyCubit>().selectItem();
```

#### bloc

```dart
context.read<MyBloc>().add(MyBlocOnSelectItem());
```

### 3. S'abonner aux changements d'états du cubit/bloc

#### Option 1 - BlocBuilder

```dart
 @override
  Widget build(BuildContext context) {
    BlocBuilder<MyBlocOrCubit, MyBlocOrCubitState>(
      builder: (context, state) {
        return Text(state.name)
      },
    );
  }

```

#### Option 2 - context.watch

/!\ encapsuler dans un builder pour ne pas reconstruire l'ensemble du Widget si besoin

```dart
 @override
  Widget build(BuildContext context) {
    Text(context.watch<MyBlocOrCubit>.state.name)
  }

```

### Autres notions

#### BlocSelector

* s'abonne aux changements d'une partie du `State`
* équivaut à `context.select()`

#### BlocListener

* déclencher une évenement sur un changement d'état
