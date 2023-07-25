@isTest
private class AnimalLocatorTest 
{
  @isTest static void testPostCallout() {
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
    // This causes a fake response to be sent
    // from the class that implements HttpCalloutMock. 
    String expectedValue = AnimalsCallouts.getAnimalcalloutbyId(1);
        System.debug('expectedValue=' + expectedValue);
    //System.assertNotEquals(0, expectedValue.length());    
  }
}