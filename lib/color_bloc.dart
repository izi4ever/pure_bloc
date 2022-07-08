import 'dart:async';
import 'package:flutter/material.dart';

enum ColorEvent {eventRed, eventGreen}

class ColorBloc {
  Color _color = Colors.red;

    // Создаём ВХОДНОЙ ПОТОК. 
    //_inputEventController — произвольное название переменной для StreamController, который принимает тип ColorEvent
  final _inputEventController = StreamController<ColorEvent>();
    // Описываем getter для входного потока. Для этого используем тип StreamSink, который содержит ColorEvent. 
    // Геттер с произвольным названием inputEventSink будет возвращать _inputEventController с параметром sink, 
    // который добавит событие в поток, т.к. sink — это входной поток, куда пользователь добавляет событие или данные.
    // Геттер позволяет не писать каждый раз _inputEventController.sink, и у входа/выхода появляется осмысленное имя
  StreamSink<ColorEvent> get inputEventSink => _inputEventController.sink;

    // Теперь нужно создать ИСХОДЯЩИЙ ПОТОК, в который будут передаваться новые состояния. _outputStateController — 
    // произвольное название второго StreamController с типом Color. Т.к. изменяемое состояние касается цвета
  final _outputStateController = StreamController<Color>();
    // Геттер выходного потока состояния с произвольным названием. Stream вместо StreamSink и Sink. State вместо Event
  Stream<Color> get outputStateStream => _outputStateController.stream;

    // Метод, который преобразует события в новые состояния. Входным параметром принимает event типа ColorEvent
  void _mapEventToState(ColorEvent event) {
    if (event == ColorEvent.eventRed) _color = Colors.red;
    else if (event == ColorEvent.eventGreen) _color = Colors.green;
    else throw Exception('Wront Event Type');

      // После того, как будет получено новое состояние, в зависимости от события, его нужно добавить в выходной поток,
      // используя метод add у sink. В него нужно передать новое состояние, которое содержится в переменной _color
    _outputStateController.sink.add(_color);
  }
  
    // Теперь нужно подписаться на прослушивание выходного потока для нового состояния. Для этого создаём конструктор класса
  ColorBloc() {
      // В этом конструкторе берём _inputEventController, вызываем у него stream. У straem вызываем метод listen. И в этот 
      // listen передаём _mapEventToState. Здесь мы подписываемся на поток и обрабатываем событие, пришедшее со стороны UI,
      // и трансформируем их в новый State через метод _mapEventToState
    _inputEventController.stream.listen(_mapEventToState);
  }

    // В конце работы потоков их нужно закрыть методом close для обоих контроллеров, т.к. они являются обёрткой над потоками
  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}