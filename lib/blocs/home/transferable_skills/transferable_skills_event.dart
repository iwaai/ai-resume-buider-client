part of 'transferable_skills_bloc.dart';

abstract class TransferableSkillsEvent {}

class GreenNodePressed extends TransferableSkillsEvent {
  final ShowNode showNode;

  GreenNodePressed({required this.showNode});
}

class GetData extends TransferableSkillsEvent {}

class GeneratePDFEvent extends TransferableSkillsEvent {}

class ToggleLike extends TransferableSkillsEvent {
  final String nodeId;
  final String descriptionId;
  final ShowNode nodeName;

  ToggleLike(
      {required this.nodeId,
      required this.descriptionId,
      required this.nodeName});
}

class ShareTSkillReportEvent extends TransferableSkillsEvent {
  final AddSupportPeopleInTSkill model;

  ShareTSkillReportEvent({required this.model});
}

class SentSkillSToEmail extends TransferableSkillsEvent {
  final File TSkillPdf;

  SentSkillSToEmail({required this.TSkillPdf});
}
