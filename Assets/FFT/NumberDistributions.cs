using System;
using Random = UnityEngine.Random;

namespace Assets.FFT {
    class NumberDistributions {
        public static double GaussianRandom(float mean, float stdDev)
        {
            var u1 = 1.0 - Random.value;
            var u2 = 1.0 - Random.value;
            var randStdNormal = Math.Sqrt(-2.0 * Math.Log(u1)) * Math.Sin(2.0 * Math.PI * u2);
            var randNormal = mean + stdDev * randStdNormal;

            return randNormal;
        }

        public static int BitReverse(int i, int N)
        {
            int j = i;
            int Sum = 0;
            int W = 1;
            int M = N / 2;
            while (M != 0)
            {
                j = ((i & M) > M - 1) ? 1 : 0;
                Sum += j * W;
                W *= 2;
                M /= 2;
            }
            return Sum;
        }

        public static int[] GetBitReversedArrayOfSize(int N)
        {
            var bitReversedArray = new int[N];
            for (int j = 0; j < N; j++)
            {
                bitReversedArray[j] = NumberDistributions.BitReverse(j, N);
            }

            return bitReversedArray;
        }
    }
}
