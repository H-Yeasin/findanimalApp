import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/features/seek/data/models/report_model.dart';
import '../../data/repositories/reports_repository.dart';

class ReportFormState {
  const ReportFormState({
    this.currentStep = 1,
    this.postType,
    this.animalName,
    this.species,
    this.breed,
    this.gender,
    this.age,
    this.status,
    this.description,
    this.hasMicrochip,
    this.hasTattoo,
    this.hasCollarOrHarness,
    this.eventDate,
    this.address,
    this.lat,
    this.lng,
    this.images = const [],
    this.phoneNumber,
    this.isPhoneVisible = false,
    this.emailAddress,
    this.isEmailVisible = false,
    this.editingReportId,
    this.submissionState = const AsyncValue.data(null),
  });

  final int currentStep;
  final String? postType;
  final String? animalName;
  final String? species;
  final String? breed;
  final String? gender;
  final String? age;
  final String? status;
  final String? description;
  final String?
  hasMicrochip; // Changed to String to handle "Yes/No/I don't know"
  final String? hasTattoo;
  final String? hasCollarOrHarness;
  final DateTime? eventDate;
  final String? address;
  final double? lat;
  final double? lng;
  final List<File> images;
  final String? phoneNumber;
  final bool isPhoneVisible;
  final String? emailAddress;
  final bool isEmailVisible;
  final String? editingReportId;
  final AsyncValue<void> submissionState;

  ReportFormState copyWith({
    int? currentStep,
    String? postType,
    String? animalName,
    String? species,
    String? breed,
    String? gender,
    String? age,
    String? status,
    String? description,
    String? hasMicrochip,
    String? hasTattoo,
    String? hasCollarOrHarness,
    DateTime? eventDate,
    String? address,
    double? lat,
    double? lng,
    List<File>? images,
    String? phoneNumber,
    bool? isPhoneVisible,
    String? emailAddress,
    bool? isEmailVisible,
    String? editingReportId,
    AsyncValue<void>? submissionState,
  }) {
    return ReportFormState(
      currentStep: currentStep ?? this.currentStep,
      postType: postType ?? this.postType,
      animalName: animalName ?? this.animalName,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      status: status ?? this.status,
      description: description ?? this.description,
      hasMicrochip: hasMicrochip ?? this.hasMicrochip,
      hasTattoo: hasTattoo ?? this.hasTattoo,
      hasCollarOrHarness: hasCollarOrHarness ?? this.hasCollarOrHarness,
      eventDate: eventDate ?? this.eventDate,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      images: images ?? this.images,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneVisible: isPhoneVisible ?? this.isPhoneVisible,
      emailAddress: emailAddress ?? this.emailAddress,
      isEmailVisible: isEmailVisible ?? this.isEmailVisible,
      editingReportId: editingReportId ?? this.editingReportId,
      submissionState: submissionState ?? this.submissionState,
    );
  }
}

class ReportFormNotifier extends Notifier<ReportFormState> {
  @override
  ReportFormState build() => const ReportFormState();

  void populate(ReportModel report) {
    String? postType;
    switch (report.status.toLowerCase()) {
      case 'lost':
        postType = 'Lost';
        break;
      case 'found':
        postType = 'Found';
        break;
      case 'sighted':
        postType = 'Spotted';
        break;
      case 'rescued':
        postType = 'Injured';
        break;
      default:
        postType = 'Lost';
    }

    state = ReportFormState(
      editingReportId: report.id,
      postType: postType,
      animalName: report.animalName,
      species: report.species,
      breed: report.breed,
      gender: report.gender,
      age: report.age,
      description: report.description,
      hasMicrochip: _mapYesNoFromBackend(report.hasMicrochip),
      hasTattoo: _mapYesNoFromBackend(report.hasTattoo),
      hasCollarOrHarness: _mapYesNoFromBackend(report.hasCollarOrHarness),
      eventDate: report.eventDate,
      address: report.location.address,
      lat: report.location.coordinates.isNotEmpty
          ? report.location.coordinates[1]
          : null,
      lng: report.location.coordinates.isNotEmpty
          ? report.location.coordinates[0]
          : null,
      phoneNumber: report.contactPhone,
      isPhoneVisible: report.isPhoneVisible,
      emailAddress: report.contactEmail,
      isEmailVisible: report.isEmailVisible,
      // Note: Images are handled separately since they are URLs,
      // for now we only support adding new images during edit.
    );
  }

  String _mapYesNoFromBackend(String value) {
    if (value == 'Unknown') return "I don't know";
    return value;
  }

  void setStep(int value) {
    state = state.copyWith(currentStep: value);
  }

  void setBasicInfo({
    String? postType,
    String? animalName,
    String? species,
    String? breed,
    String? gender,
  }) {
    state = state.copyWith(
      postType: postType,
      animalName: animalName,
      species: species,
      breed: breed,
      gender: gender,
    );
  }

  void setDescriptionInfo({
    String? address,
    double? lat,
    double? lng,
    String? description,
    List<File>? images,
  }) {
    state = state.copyWith(
      address: address,
      lat: lat,
      lng: lng,
      description: description,
      images: images,
    );
  }

  void setTechnicalInfo({
    String? hasMicrochip,
    String? hasTattoo,
    String? hasCollarOrHarness,
    DateTime? eventDate,
  }) {
    state = state.copyWith(
      hasMicrochip: hasMicrochip,
      hasTattoo: hasTattoo,
      hasCollarOrHarness: hasCollarOrHarness,
      eventDate: eventDate,
    );
  }

  void setPersonalInfo({
    String? phoneNumber,
    bool? isPhoneVisible,
    String? emailAddress,
    bool? isEmailVisible,
  }) {
    state = state.copyWith(
      phoneNumber: phoneNumber,
      isPhoneVisible: isPhoneVisible,
      emailAddress: emailAddress,
      isEmailVisible: isEmailVisible,
    );
  }

  Future<bool> submit() async {
    state = state.copyWith(submissionState: const AsyncValue.loading());

    try {
      final repository = ref.read(reportsRepositoryProvider);
      if (state.editingReportId != null) {
        await repository.updateReport(state.editingReportId!, state);
      } else {
        await repository.createReport(state);
      }
      state = state.copyWith(submissionState: const AsyncValue.data(null));
      return true;
    } catch (e, stack) {
      state = state.copyWith(submissionState: AsyncValue.error(e, stack));
      return false;
    }
  }

  void reset() {
    state = const ReportFormState();
  }
}

final reportFormProvider =
    NotifierProvider<ReportFormNotifier, ReportFormState>(
      ReportFormNotifier.new,
    );
