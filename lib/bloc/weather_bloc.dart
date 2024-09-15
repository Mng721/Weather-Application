import 'package:Weather/data/my_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitialState()) {
    on<FetchWeatherDataEvent>((event, emit) async {
      // TODO: implement event handler
      emit(WeatherLoadingState());
      try {
        WeatherFactory wf =
            WeatherFactory(WEATHER_API, language: Language.ENGLISH);
        final weather = await wf.currentWeatherByLocation(
            event.position.latitude, event.position.longitude);
        print(weather);
        emit(WeatherSuccessState(weather: weather));
      } catch (e) {
        final message = e.toString();
        emit(WeatherFailedState(errorMessage: message));
      }
    });
  }
}
