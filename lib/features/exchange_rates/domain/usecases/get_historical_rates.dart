import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/exchange_repository.dart';

class GetHistoricalRates {
  final ExchangeRepository repository;

  GetHistoricalRates(this.repository);

  Future<Either<Failure, List<double>>> call(String currencyCode) async {
    return await repository.getHistoricalRates(currencyCode);
  }
}
