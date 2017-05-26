import java.util.Random;
 
/**
 * Represents the different types of food.
 */
public static enum FoodType {
  DEFAULT(1), DECAPITATOR(2), FAST(3),
  SLOW(3), EXPLODER(5), SLIMER(5),
  REVERSE(5), STAR(12);
  
  private int spawnRate;
  
  /**
   * Constructs a {@code FoodType} object;
   *
   * @param spawnRate     the rate at which the food spawns
   */
  private FoodType(int spawnRate) {
    this.spawnRate = spawnRate;
  }
  
  /**
   * Uses a RNG to determine if the food will spawn.
   *
   * @return true if it will spawn, false otherwise
   */
  public boolean willSpawn() {
    Random rand = new Random();
    return rand.nextInt(this.spawnRate) < 1;
  }
}