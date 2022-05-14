@isTest
public class FitenessTest {
    
    @isTest
    public static void calculateBMITest1() {
        //create the instance of the class
        Fitness f1 = new Fitness();
        Decimal result = Fitness.calculateBMI(60,1.2);
        result = result.setScale(2);
        System.assertEquals(41.67, result, 'results are not matching');
        
    }
    @isTest
    public static void calculateBMITest2() {
        //create the instance of the class
        Fitness f1 = new Fitness();
        Decimal result = Fitness.calculateBMI(60,0);
       // result = result.setScale(2);
        System.assertEquals(-1, result, 'invalid input');
        
    }
    
    @isTest
    public static void calculatePaceTest1() {
        Decimal result = Fitness.calculatePace(60,60);
        System.assertEquals(60, result, 'results are not matching');
        
    }
    @isTest
    public static void calculatePaceTest2() {
        Decimal result = Fitness.calculatePace(60,0);
        System.assertEquals(-1, result, 'invalid input');
        
    }

}