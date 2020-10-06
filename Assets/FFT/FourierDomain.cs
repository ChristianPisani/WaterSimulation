using UnityEngine;
using Complex = System.Numerics.Complex;
using Math = System.Math;

namespace Assets.FFT {
    public class FourierDomain {
        public readonly float G = 9.81f;

        // k
        public Vector2 GetWaveDirection(int x, int y, int N)
        {
            int L = 1000;
            float n = x - N / 2;
            float m = y - N / 2;

            return new Vector2()
            {
                x = (2.0f * Mathf.PI * n) / L,
                y = (2.0f * Mathf.PI * m) / L
            };
        }

        // h0(k)
        public Complex FourierAmplitudeFirst(float A, Vector2 k, float V, Vector2 w)
        {
            Vector2 random = new Vector2((float)NumberDistributions.GaussianRandom(0, 1), (float)NumberDistributions.GaussianRandom(0, 1));

            return (1.0f / Mathf.Sqrt(2.0f)) * (random.x + (Complex.ImaginaryOne * random.y)) * Mathf.Sqrt(PhilipsSpectrum(A, k, V, w));
        }

        //h(k, t)
        public Complex FourierAmplitude(Complex h0k, Complex h0Negk, float A, Vector2 k, float V, Vector2 w, float depth, float time)
        {
            var firstDispersion = Complex.ImaginaryOne * DispercionRelation(k, depth, time);
            var firstPart = h0k * Complex.Exp(firstDispersion * time);

            var h0NegKConjugate = new Complex(h0Negk.Real, -h0Negk.Imaginary);
            var secondDispersion = -Complex.ImaginaryOne * DispercionRelation(k, depth, time);
            var secondPart = h0NegKConjugate * Complex.Exp(secondDispersion * time);

            return firstPart + secondPart;
        }

        double DispercionRelation(Vector2 k, double Depth, float time)
        {
            double basic = BasicFrequence(time);
            double dispersion = Math.Sqrt(G * k.magnitude * Math.Tanh(k.magnitude * Depth));

            double tilingDispersion = ((int)(dispersion / basic)) * basic;

            return tilingDispersion;
        }

        double BasicFrequence(float time)
        {
            /*             
                T for example, it is necessary that all frequencies be multiples of
                the basic frequence
                ω0 ≡ 2π/T
             */

            return (Math.PI * 2) / time;
        }

        float PhilipsSpectrum(float A, Vector2 k, float V, Vector2 w)
        {
            //Ph(k) = A exp(−1 / (kL)2) / k4 * | kˆ · wˆ |
            // L = V^2 / g;
            // V = wind of speed V
            // w = wind direction
            var L = (V * V) / G;
            var kL = k.magnitude;
            var kSquared = Mathf.Pow(k.magnitude, 2);
            var LSquared = Mathf.Pow(L, 2);

            // The cosine factor | kˆ ·wˆ | 2 in the Phillips spectrum eliminates waves that move perpendicular to the wind direction
            float divPart = Mathf.Exp(-1 / Mathf.Pow(kL * L, 2)) / Mathf.Pow(kL, 4);

            float dot = Vector2.Dot(k.normalized, w.normalized);
            float dotSquared = Mathf.Pow(dot, 2);

            /*
                This model, while relatively simple,
                has poor convergence properties at high values of the wavenumber
                |k|. A simple fix is to suppress waves smaller that a small length
                `  L, and modify the Phillips spectrum by the multiplicative factor
                exp−k2`2
            */
            var l = L / 2000.0f;
            var removedSmallWaves = (float)Math.Exp(-Mathf.Pow(kL, 2) * Mathf.Pow(l, 2));

            return A * divPart * dotSquared * removedSmallWaves;
        }
    }
}
