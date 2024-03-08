// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);



Map<String, Schema.DescribeSObjectResult> sObjectDescribes = new Map<String, Schema.DescribeSObjectResult>();
List<Schema.DescribeSObjectResult> describes = Schema.describeSObjects(new List<String>{ 'account' }, SObjectDescribeOptions.DEFERRED);
DescribeSObjectResult describe = describes[0];
System.debug(describe.getLabel());
sObjectDescribes.put('account', describe);

//System.assert(sObjectDescribes.containsKey('Account'));

System.debug(RecordTypes.getDefaultRecordTypeName('Account'));
System.debug(RecordTypes.getDefaultRecordType('Account'));