public class Flower {
    public static Integer wilt(Integer numberOfPetals){
        if(numberOfPetals >= 1){
            numberOfPetals--;
        }
        return numberOfPetals;
    }
}