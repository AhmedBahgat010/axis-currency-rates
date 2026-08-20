import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:task_axis/core/networking/api_constants.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('https://latest.currency-api.pages.dev/v1/${ApiConstants.latestCurrencyRates}')
  Future<dynamic> getLatestRates();

  @GET('https://{date}.currency-api.pages.dev/v1/${ApiConstants.latestCurrencyRates}')
  Future<dynamic> getHistoricalRates(
    @Path('date') String date,
  );
}

