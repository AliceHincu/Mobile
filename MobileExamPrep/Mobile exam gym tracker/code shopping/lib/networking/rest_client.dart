import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' show Dio, Options, RequestOptions, ResponseType;

import '../models/my_entity.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "http://192.168.43.20:8080/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("categories")
  Future<List<String>> getCategories();

  @GET("activities/{category}")
  Future<List<MyEntity>> getEntitiesByCategory(@Path() String category);

  @POST("activity")
  Future<MyEntity> postEntity(@Body() MyEntity entity);

  @DELETE("activity/{id}")
  Future<MyEntity> deleteEntity(@Path() int id);

  @GET("easiest")
  Future<List<MyEntity>> getEntities();

  @POST("intensity")
  Future<MyEntity> postMyEntity2(@Body() Object myEntity);

  /////////////////////////
  // @GET("days")
  // Future<List<String>> getDays();
  //
  // @GET("symptoms/{date}")
  // Future<List<Activity>> getSymptomsByDate(@Path() String date);
  //
  // @POST("symptom")
  // Future<Activity> postSymptom(@Body() Activity symptom);
  //
  // @DELETE("symptom/{id}")
  // Future<Activity> deleteSymptom(@Path() int id);
  //
  // @GET("entries")
  // Future<List<Activity>> getSymptoms();

  ////////////////////////
  // @GET("spaces")
  // Future<List<Activity>> getParkings();
  //
  // @GET("spaces")
  // Future<List<Activity>> getAllParkings();
  //
  // @GET("free")
  // Future<List<Activity>> getAvailableParkings();
  //
  // @GET("parking/{id}")
  // Future<Activity> getParking(@Path() String id);
  //
  // @POST("space")
  // Future<Activity> postParking(@Body() Activity parking);
  //
  // @POST("take")
  // Future<Activity> borrowParking(@Body() Object obj);
  //
  // @PUT("space/{id}")
  // Future<Activity> putParking(@Path() String id, @Body() Activity parking);
  //
  // @DELETE("space/{id}")
  // Future<Activity> deleteParking(@Path() int id);
}
