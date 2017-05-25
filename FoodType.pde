/**
 * Represents the different types of food.
 */
 
 import java.util.Random;
 
public enum FoodType {
  DEFAULT(1), DECAPITATOR(5), SLIMER(10), EXPLODER(15), STAR(20);
  
  private int spawnRate;
  
  private FoodType(int spawnRate) {
    this.spawnRate = spawnRate;
  }
  
  public boolean willSpawn() {
    Random rand = new Random();
    return rand.nextInt(this.spawnRate) < 1;
  }
}