using System;
using UnityEngine;
using Random = UnityEngine.Random;
using Complex = System.Numerics.Complex;
using Assets.FFT;

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
        
        private FourierDomain _fftFunctions = new FourierDomain();
        
        public void VisualizeNoise()
        {
            H0KTex = new Texture2D(N, N);
            H0NegativeKTex = new Texture2D(N, N);
            TimedependentHTex = new Texture2D(N, N);
            
            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    var waveDirection = _fftFunctions.GetWaveDirection(x, y, N);

                    var h0k = _fftFunctions.FourierAmplitudeFirst(Amplitude, waveDirection, WindForce, WindDirection);
                    var h0NegK = _fftFunctions.FourierAmplitudeFirst(Amplitude, -waveDirection, WindForce, WindDirection);
                    var hkt = _fftFunctions.FourierAmplitude(h0k, h0NegK, Amplitude, waveDirection, WindForce, WindDirection, Depth, Time.time);

                    H0KTex.SetPixel(x, y, new Color((float)h0k.Real, (float)h0k.Imaginary, 0, 1));
                    H0NegativeKTex.SetPixel(x, y, new Color((float)h0NegK.Real, (float)h0NegK.Imaginary, 0, 1));

                    TimedependentHTex.SetPixel(x, y, new Color((float)hkt.Real, (float)hkt.Imaginary, 0, 1));
                }
            }
            H0KTex.Apply();
            H0NegativeKTex.Apply();
            TimedependentHTex.Apply();
        }  
    }
}
