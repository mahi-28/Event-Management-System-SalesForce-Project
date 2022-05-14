public class Fitness {
    public static Decimal calculateBMI(Integer weight,Decimal height) {
        if(weight <=0 || height<=0) {
            return -1;
        } else {
        Decimal BMI = (weight/(height*height));
        return BMI;
        }
    }
    public static Decimal calculatePace(Decimal Dist,Integer Min) {
        if(Dist <0 || Min<=0) {
            return -1;
        }
        Decimal km = (Dist/Min);
        return km*60;
    }

}