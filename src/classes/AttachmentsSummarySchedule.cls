global class AttachmentsSummarySchedule implements Schedulable {
	global void execute(SchedulableContext  ctx) {        
        AttachmentsSummary rollupSummary = new AttachmentsSummary();
		rollupSummary.Recalculate();		
	}   
}