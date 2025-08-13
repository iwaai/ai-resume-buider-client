part of 'subscription_bloc.dart';

abstract class SubscriptionEvent {}

class BuySubscriptionEvent extends SubscriptionEvent {}

class InitializeSubscriptionEvent extends SubscriptionEvent {}

class SelectAPlanEvent extends SubscriptionEvent {
  final ProductDetails plan;

  SelectAPlanEvent({required this.plan});
}

class GetUserSubscriptionEvent extends SubscriptionEvent {}
