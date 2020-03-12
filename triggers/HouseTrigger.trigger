trigger HouseTrigger on House__c(after insert) {
	if (Trigger.isAfter && Trigger.isInsert) {
		House.assignExternalId(Trigger.new);
	} 
}