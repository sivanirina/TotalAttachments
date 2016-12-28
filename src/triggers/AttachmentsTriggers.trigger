trigger AttachmentsTriggers on Attachment (before delete, after insert, after undelete) {
		AttachmentsSummary totalAttachments = new AttachmentsSummary();

		if (Trigger.isBefore && Trigger.isDelete) {
				totalAttachments.Recalculate(Trigger.Old, false);
		} else if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)) {
	      totalAttachments.Recalculate(Trigger.New);
		}
}