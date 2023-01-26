// global class ProgramEnrollmentSendEmail implements Schedulable  {

//     private list<hed_Program_Enrollment_c> list1;
//     global ProgramEnrollmentSendEmail(List<hed_Program_Enrollment_c> list2) {
//             this.list1=list2;
//     }
      
//     global void execute(SchedulableContext sc) {
//         ProgramEnrollmentTriggerHelper.sendNewProgramEmail(list1);
//     }
  
// }

@isTest 
private class TestClass {
    public static String cronStr = '0 0 10 20 1 ? 2023';
    @isTest static void test() {
        List<Contact> conList = new List<Contact>();
        for (Integer i=0; i<5; i++) {
            Contact con = new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i+1,
                Email = 'test@testing.com'
            );
            conList.add(con);
        }
        test.startTest();
        INSERT conList;
        ProgramEnrollmentSendMail myclass = new ProgramEnrollmentSendMail(conList);
        System.schedule('Test class for Schedulable Class', cronStr, myclass);
        test.stopTest();
    }
}