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

        public Texture2D H0KTexCPU;
        public Texture2D H0NegativeKTexCPU;
        public Texture2D TimedependentHTexCPU;

        public RenderTexture H0KTex;
        public RenderTexture H0NegativeKTex;
        public RenderTexture TimedependentHTex;

        public Texture2D NoiseTexture;

        private FourierDomain _fftFunctions = new FourierDomain();

        public ComputeShader FFTComputeShader;

        public void VisualizeNoiseCpu()
        {
            H0KTexCPU = new Texture2D(N, N);
            H0NegativeKTexCPU = new Texture2D(N, N);
            TimedependentHTexCPU = new Texture2D(N, N);

            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    var waveDirection = _fftFunctions.GetWaveDirection(x, y, N);

                    var h0k = _fftFunctions.FourierAmplitudeFirst(Amplitude, waveDirection, WindForce, WindDirection);
                    var h0NegK = _fftFunctions.FourierAmplitudeFirst(Amplitude, -waveDirection, WindForce, WindDirection);
                    var hkt = _fftFunctions.FourierAmplitude(h0k, h0NegK, Amplitude, waveDirection, WindForce, WindDirection, Depth, Time.time);

                    H0KTexCPU.SetPixel(x, y, new Color((float)h0k.Real, (float)h0k.Imaginary, 0, 1));
                    H0NegativeKTexCPU.SetPixel(x, y, new Color((float)h0NegK.Real, (float)h0NegK.Imaginary, 0, 1));

                    TimedependentHTexCPU.SetPixel(x, y, new Color((float)hkt.Real, (float)hkt.Imaginary, 0, 1));
                }
            }
            H0KTexCPU.Apply();
            H0NegativeKTexCPU.Apply();
            TimedependentHTexCPU.Apply();
        }

        public void Start()
        {
            VisualizeNoiseGpu();
        }

        public void Update()
        {
            if (H0KTex == null || H0NegativeKTex == null) return;

            var kernel = FFTComputeShader.FindKernel("GenerateTimeDependentTexture");

            FFTComputeShader.SetTexture(kernel, "H0KTexture", H0KTex);
            FFTComputeShader.SetTexture(kernel, "H0NegKTexture", H0NegativeKTex);
            FFTComputeShader.SetTexture(kernel, "HTKTexture", TimedependentHTex);
            FFTComputeShader.SetTexture(kernel, "NoiseTexture", NoiseTexture);
            FFTComputeShader.SetFloat("_Time", Time.time);
            FFTComputeShader.SetFloat("_Amplitude", Amplitude);
            FFTComputeShader.SetFloat("_WindForce", WindForce);
            FFTComputeShader.SetVector("_WindDirection", WindDirection);
            FFTComputeShader.SetFloat("_Depth", Depth);
            FFTComputeShader.SetInt("_Resolution", N);

            FFTComputeShader.Dispatch(kernel, N / 8, N / 8, 1);
        }

        public void VisualizeNoiseGpu()
        {
            if (NoiseTexture == null) return;

            H0KTex = new RenderTexture(N, N, 1);
            H0NegativeKTex = new RenderTexture(N, N, 1);
            TimedependentHTex = new RenderTexture(N, N, 1);

            H0KTex.enableRandomWrite = true;
            H0NegativeKTex.enableRandomWrite = true;            
            TimedependentHTex.enableRandomWrite = true;

            H0KTex.Create();
            H0NegativeKTex.Create();
            TimedependentHTex.Create();

            int kernel = FFTComputeShader.FindKernel("Setup");

            FFTComputeShader.SetTexture(kernel, "H0KTexture", H0KTex);
            FFTComputeShader.SetTexture(kernel, "HTKTexture", TimedependentHTex);
            FFTComputeShader.SetTexture(kernel, "H0NegKTexture", H0NegativeKTex);
            FFTComputeShader.SetTexture(kernel, "NoiseTexture", NoiseTexture);
            FFTComputeShader.SetFloat("_Time", Time.time);
            FFTComputeShader.SetFloat("_Amplitude", Amplitude);
            FFTComputeShader.SetFloat("_WindForce", WindForce);
            FFTComputeShader.SetVector("_WindDirection", WindDirection);
            FFTComputeShader.SetFloat("_Depth", Depth);
            FFTComputeShader.SetInt("_Resolution", N);

            FFTComputeShader.Dispatch(kernel, N / 8, N / 8, 1);
        }

        public void CreateGaussianNoiseTexture()
        {
            NoiseTexture = new Texture2D(N, N);

            float mean = 0;
            float stdDev = 1;

            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    NoiseTexture.SetPixel(x, y,
                        new Color(
                            (float)NumberDistributions.GaussianRandom(mean, stdDev),
                            (float)NumberDistributions.GaussianRandom(mean, stdDev),
                            (float)NumberDistributions.GaussianRandom(mean, stdDev),
                            (float)NumberDistributions.GaussianRandom(mean, stdDev)
                        ));
                }
            }
            NoiseTexture.Apply();
        }
    }
}
