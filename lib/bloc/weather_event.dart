part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeatherDataEvent extends WeatherEvent {
  final Position position;

  const FetchWeatherDataEvent(this.position);

  @override
  List<Object> get props => [position];
}
