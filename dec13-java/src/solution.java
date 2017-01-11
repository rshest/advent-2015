import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.List;

public class solution {

  interface IPermutationVisitor {
    public void operation(int[] permutation);
  }

  //  enumerates all the permutations of the arr, calling the visitor on each
  public static void permutations(int arr[], int pos, IPermutationVisitor visitor) {
    final int n = arr.length;
    if (pos == n - 1) {
      visitor.operation(arr);
    } else {
      for (int i = pos; i < n; i++) {
        int cur = arr[pos];
        for (int j = pos + 1; j < n; j++) {
          arr[j - 1] = arr[j];
        }
        arr[n - 1] = cur;
        permutations(arr, pos + 1, visitor);
      }
    }
  }

  static class DinnerTable {
    static final int DESCR_NUM_WORDS = 11;

    public String[] names;
    public int[][] happinessWeights;

    public void parse(List<String> descriptionLines)
      throws IllegalArgumentException
    {
      names = descriptionLines.stream()
          .map(s -> s.split(" ")[0])
          .distinct()
          .toArray(String[]::new);
      Arrays.sort(names);

      int numPersons = names.length;
      happinessWeights = new int[numPersons][numPersons];

      for (String line: descriptionLines) {
        String[] parts = line.split(" ");
        if (parts.length != DESCR_NUM_WORDS) {
          throw new IllegalArgumentException("Invalid description line (expected " +
              DESCR_NUM_WORDS + " words): " + String.join(" ", parts));
        }

        String subject = parts[0];
        String object = parts[10].replace(".", "");
        int amount = Integer.parseUnsignedInt(parts[3]);
        if (parts[2].equals("lose")) amount *= -1;

        int subjectIdx = Arrays.binarySearch(names, subject);
        int objectIdx = Arrays.binarySearch(names, object);
        if (!names[objectIdx].equals(object)) {
          throw new IllegalArgumentException("Object person is never an subject: " + object);
        }
        happinessWeights[subjectIdx][objectIdx] = amount;
      }
    }

    public int totalHappiness(int[] arrangement)
        throws IllegalArgumentException
    {
      final int n = names.length;
      if (arrangement.length != n) {
        throw new IllegalArgumentException("Invalid arrangement size: " +
            arrangement.length + ", expected " + n);
      }
      int res = 0;
      for (int i = 0; i < n; i++) {
        int a = arrangement[i];
        int b = arrangement[(i + 1)%n];
        res += happinessWeights[a][b];
        res += happinessWeights[b][a];
      }
      return res;
    }

    public int[] bestArrangement() {
      final int n = names.length;
      int[] arr = new int[n];
      for (int i = 0; i < n; i++) arr[i] = i;

      class Visitor implements IPermutationVisitor {
        public int bestScore = 0;
        public int[] bestArr = null;

        @Override
        public void operation(int[] permutation) {
          int score = totalHappiness(permutation);
          if (bestArr == null || score > bestScore) {
            bestScore = score;
            bestArr = permutation.clone();
          }
        }
      }

      Visitor visitor = new Visitor();
      permutations(arr, 0, visitor);
      return visitor.bestArr;
    }

    public void addParticipant(String name, int score) {
      final int n = names.length;
      names = Arrays.copyOf(names, n + 1);
      names[n] = name;
      int[][] newWeights = new int[n + 1][];
      for (int i = 0; i < n; i++) {
        happinessWeights[i] = Arrays.copyOf(happinessWeights[i], n + 1);
      }
      happinessWeights = Arrays.copyOf(happinessWeights, n + 1);
      happinessWeights[n] = new int[n + 1];
    }
  }


  public static void main(String[] args) throws IOException {
    String fname = "input.txt";
    if (args.length > 0) fname = args[0];

    List<String> lines = Files.readAllLines(Paths.get(fname));

    DinnerTable table = new DinnerTable();
    table.parse(lines);

    int[] bestArr1 = table.bestArrangement();
    int totalHappiness1 = table.totalHappiness(bestArr1);
    System.out.println(String.format("Optimal happiness 1: %1$d.", totalHappiness1));

    table.addParticipant("You", 0);
    int[] bestArr2 = table.bestArrangement();
    int totalHappiness2 = table.totalHappiness(bestArr2);
    System.out.println(String.format("Optimal happiness 2: %1$d.", totalHappiness2));
  }
}
