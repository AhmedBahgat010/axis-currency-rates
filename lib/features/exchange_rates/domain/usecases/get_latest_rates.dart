import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exchange_rate.dart';
import '../repositories/exchange_repository.dart';

class GetLatestRates {
  final ExchangeRepository repository;

  GetLatestRates(this.repository);

  Future<Either<Failure, List<ExchangeRate>>> call() async {
    return await repository.getLatestRates();
  }
}
