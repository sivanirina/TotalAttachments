global class AttachmentsSummarySchedule implements Schedulable {
    global void execute(SchedulableContext  ctx) {
        AttachmentsSummary totalAttachments = new AttachmentsSummary();
		    totalAttachments.Recalculate();
    }
}
