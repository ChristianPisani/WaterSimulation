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
    }
}
