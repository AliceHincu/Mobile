import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' show Dio, Options, RequestOptions, ResponseType;

import '../models/symptom.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "http://192.168.43.20:8080/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;
  @GET("days")
  Future<List<String>> getDays();

  @GET("symptoms/{date}")
  Future<List<Symptom>> getSymptomsByDate(@Path() String date);

  @POST("symptom")
  Future<Symptom> postSymptom(@Body() Symptom symptom);

  @DELETE("symptom/{id}")
  Future<Symptom> deleteSymptom(@Path() int id);

  @GET("entries")
  Future<List<Symptom>> getSymptoms();

  ////////////////////////
  @GET("spaces")
  Future<List<Symptom>> getParkings();

  @GET("spaces")
  Future<List<Symptom>> getAllParkings();

  @GET("free")
  Future<List<Symptom>> getAvailableParkings();

  @GET("parking/{id}")
  Future<Symptom> getParking(@Path() String id);

  @POST("space")
  Future<Symptom> postParking(@Body() Symptom parking);

  @POST("take")
  Future<Symptom> borrowParking(@Body() Object obj);

  @PUT("space/{id}")
  Future<Symptom> putParking(@Path() String id, @Body() Symptom parking);

  @DELETE("space/{id}")
  Future<Symptom> deleteParking(@Path() int id);
}
