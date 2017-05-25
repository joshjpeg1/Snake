/**
 * Represents the different types of food.
 */
 
import java.util.Random;
 
public static enum FoodType {
  DEFAULT(1), DECAPITATOR(2), FAST(3),
  SLOW(3), EXPLODER(5), SLIMER(5),
  REVERSE(5), STAR(12);
  
  private int spawnRate;
  
  private FoodType(int spawnRate) {
    this.spawnRate = spawnRate;
  }
  
  public boolean willSpawn() {
    Random rand = new Random();
    return rand.nextInt(this.spawnRate) < 1;
  }
}