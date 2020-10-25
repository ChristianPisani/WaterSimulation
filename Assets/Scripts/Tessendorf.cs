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
        public RenderTexture ButterflyTexture;
        public RenderTexture Pong0Texture;
        public RenderTexture Pong1Texture;
        public RenderTexture DisplacementTexture;

        ComputeBuffer BitReversedBuffer;

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

            VisualizeNoiseGpu();
        }

        private void OnDestroy()
        {
            BitReversedBuffer.Release();
        }

        public void CreateVisialization()
        {
            CreateTextures();
            VisualizeNoiseGpu();

            //SaveTexture(ButterflyTexture, "C:/Users/Dobbydoo/Pictures/ButterflyTexture.png");
        }

        public void CreateTextures()
        {
            H0KTex = new RenderTexture(N, N, 1);
            H0NegativeKTex = new RenderTexture(N, N, 1);
            TimedependentHTex = new RenderTexture(N, N, 1);
            ButterflyTexture = new RenderTexture((int)Math.Log(N, 2), N, 1);
            Pong0Texture = new RenderTexture(N, N, 1);
            Pong1Texture = new RenderTexture(N, N, 1);
            DisplacementTexture = new RenderTexture(N, N, 1);

            H0KTex.enableRandomWrite = true;
            H0NegativeKTex.enableRandomWrite = true;
            TimedependentHTex.enableRandomWrite = true;
            ButterflyTexture.enableRandomWrite = true;
            Pong0Texture.enableRandomWrite = true;
            Pong1Texture.enableRandomWrite = true;
            DisplacementTexture.enableRandomWrite = true;

            H0KTex.Create();
            H0NegativeKTex.Create();
            TimedependentHTex.Create();
            ButterflyTexture.Create();
            Pong0Texture.Create();
            Pong1Texture.Create();
            DisplacementTexture.Create();
        }

        public void VisualizeNoiseGpu()
        {
            if (NoiseTexture == null) return;

            int kernel = FFTComputeShader.FindKernel("Setup");
            int displacementKernel = FFTComputeShader.FindKernel("GenerateDisplacementTexture");
            int butterflyKernel = FFTComputeShader.FindKernel("GenerateButterflyTexture");

            FFTComputeShader.SetTexture(kernel, "H0KTexture", H0KTex);
            FFTComputeShader.SetTexture(kernel, "HTKTexture", TimedependentHTex);
            FFTComputeShader.SetTexture(kernel, "H0NegKTexture", H0NegativeKTex);
            FFTComputeShader.SetTexture(kernel, "ButterflyTexture", ButterflyTexture);
            FFTComputeShader.SetTexture(kernel, "Pong0Texture", Pong0Texture);
            FFTComputeShader.SetTexture(kernel, "Pong1Texture", Pong1Texture);
            FFTComputeShader.SetTexture(kernel, "DisplacementTexture", DisplacementTexture);
            FFTComputeShader.SetTexture(kernel, "NoiseTexture", NoiseTexture);
            FFTComputeShader.SetFloat("_Time", Time.time + 1);
            FFTComputeShader.SetFloat("_Amplitude", Amplitude);
            FFTComputeShader.SetFloat("_WindForce", WindForce);
            FFTComputeShader.SetVector("_WindDirection", WindDirection);
            FFTComputeShader.SetFloat("_Depth", Depth);
            FFTComputeShader.SetInt("_Resolution", N);

            FFTComputeShader.Dispatch(kernel, N / 8, N / 8, 1);

            var bitReversedArray = new int[N];
            for (int j = 0; j < N; j++)
            {
                bitReversedArray[j] = NumberDistributions.BitReverse(j, N);
            }
            BitReversedBuffer = new ComputeBuffer(N, sizeof(int));
            BitReversedBuffer.SetData(bitReversedArray);
            FFTComputeShader.SetBuffer(butterflyKernel, "BitReversed", BitReversedBuffer);

            FFTComputeShader.SetTexture(butterflyKernel, "ButterflyTexture", ButterflyTexture);
            FFTComputeShader.SetTexture(butterflyKernel, "Pong0Texture", Pong0Texture);
            FFTComputeShader.SetTexture(butterflyKernel, "Pong1Texture", Pong1Texture);
            FFTComputeShader.Dispatch(butterflyKernel, N / 8, N / 8, 1);

            FFTComputeShader.SetTexture(displacementKernel, "ButterflyTexture", ButterflyTexture);
            FFTComputeShader.SetTexture(displacementKernel, "Pong0Texture", Pong0Texture);
            FFTComputeShader.SetTexture(displacementKernel, "Pong1Texture", Pong1Texture);
            FFTComputeShader.SetTexture(displacementKernel, "DisplacementTexture", DisplacementTexture);
            FFTComputeShader.Dispatch(displacementKernel, N / 8, N / 8, 1);
            
            BitReversedBuffer.Release();
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

        public void SaveTexture(RenderTexture rt, string path)
        {
            byte[] bytes = toTexture2D(rt).EncodeToPNG();
            System.IO.File.WriteAllBytes(path, bytes);
        }
        Texture2D toTexture2D(RenderTexture rTex)
        {
            Texture2D tex = new Texture2D(rTex.width, rTex.height, TextureFormat.RGB24, false);
            RenderTexture.active = rTex;
            tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
            tex.Apply();
            return tex;
        }
    }
}
