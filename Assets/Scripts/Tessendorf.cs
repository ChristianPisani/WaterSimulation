using System;
using UnityEngine;
using Random = UnityEngine.Random;
using Complex = System.Numerics.Complex;

namespace Assets.Scripts {
    class Tessendorf : MonoBehaviour {

        public float Amplitude = 1;
        public Vector2 WindDirection = new Vector2(1, 1);
        public float WindForce = 40;
        public float Depth = 10;
        public int N = 256;

        public Texture2D H0KTex;
        public Texture2D H0NegativeKTex;
        public Texture2D TimedependentHTex;

        private readonly float g = 9.81f;

        private Complex h0k;
        private Complex h0NegK;
        
        public void VisualizeNoise()
        {
            H0KTex = new Texture2D(N, N);
            H0NegativeKTex = new Texture2D(N, N);
            TimedependentHTex = new Texture2D(N, N);
            
            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    var waveDirection = GetWaveDirection(x, y);

                    h0k = FourierAmplitudeFirst(Amplitude, waveDirection, WindForce, WindDirection);
                    h0NegK = FourierAmplitudeFirst(Amplitude, -waveDirection, WindForce, WindDirection);

                    H0KTex.SetPixel(x, y, new Color((float)h0k.Real, (float)h0k.Imaginary, 0, 1));
                    H0NegativeKTex.SetPixel(x, y, new Color((float)h0NegK.Real, (float)h0NegK.Imaginary, 0, 1));
                }
            }
            H0KTex.Apply();
            H0NegativeKTex.Apply();
        }

        // k
        Vector2 GetWaveDirection(int x, int y)
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

        public void Update()
        {
            if (h0k == default(Complex) || h0NegK == default(Complex)) return;

            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    var waveDirection = GetWaveDirection(x, y);

                    var hkt = FourierAmplitude(h0k, h0NegK, Amplitude, waveDirection, WindForce, WindDirection, Depth, Time.time);
                    TimedependentHTex.SetPixel(x, y, new Color((float)hkt.Real, (float)hkt.Imaginary, 0, 1));
                    TimedependentHTex.Apply();
                }
            }
        }

        float GaussianRandom(float mean, float stdDev)
        {
            double u1 = 1.0 - Random.value; //uniform(0,1] random doubles
            double u2 = 1.0 - Random.value;
            double randStdNormal = Math.Sqrt(-2.0 * Math.Log(u1)) * Math.Sin(2.0 * Math.PI * u2); //random normal(0,1)
            double randNormal = mean + stdDev * randStdNormal; //random normal(mean,stdDev^2)

            return (float)randNormal;
        }

        // h0(k)
        Complex FourierAmplitudeFirst(float A, Vector2 k, float V, Vector2 w)
        {
            Vector2 random = new Vector3(GaussianRandom(0, 1), GaussianRandom(0, 1));
            return (1.0f / Mathf.Sqrt(2.0f)) * (random.x + (Complex.ImaginaryOne * random.y)) * Mathf.Sqrt(PhilipsSpectrum(A, k, V, w));
        }

        //h(k, t)
        Complex FourierAmplitude(Complex h0k, Complex h0Negk, float A, Vector2 k, float V, Vector2 w, float depth, float time)
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
            return Math.Sqrt(g * k.magnitude);

            double basic = BasicFrequence(time);
            double dispersion = Math.Sqrt(g * k.magnitude * Math.Tanh(k.magnitude * Depth));

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
            var L = (V * V) / g;
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
