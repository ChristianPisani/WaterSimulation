using Assets.FFT;
using Assets.ImageExtensions;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Complex = System.Numerics.Complex;

namespace Assets.Scripts {
    class FourierTransform : MonoBehaviour {
        public Texture2D Input;
        public Texture2D Output;
        public Texture2D Inverse;

        [Header("Wave properties")]
        public float Rotation;
        public float Frequency;
        public Vector2 Strength;

        [Header("Texture properties")]
        public int N;

        internal RenderTexture WaveTexture;
        internal RenderTexture FrequencyTexture;

        [Header("Butterfly")]
        internal RenderTexture ButterflyTexture;
        internal RenderTexture Pong0Texture;
        internal RenderTexture Pong1Texture;

        public ComputeShader FourierCompute;

        ComputeBuffer BitReversedBuffer;

        public bool Reload;

        public void CreateWaveTexture()
        {
            /* WaveTexture = InitializeRenderTexture(new Vector2(N, N));

             int kernel = FourierCompute.FindKernel("GenerateWaveTexture");

             FourierCompute.SetTexture(kernel, "_WaveTexture", WaveTexture);

             FourierCompute.SetFloat("_Time", Time.time + 1);
             FourierCompute.SetFloat("_Rotation", Rotation);
             FourierCompute.SetFloat("_Frequency", Frequency);
             FourierCompute.SetFloat("N", N);
             FourierCompute.SetVector("_Strength", Strength);

             FourierCompute.Dispatch(kernel, N / 8, N / 8, 1);        */
        }

        public void CreateFrequencyTexture()
        {
            var logN = (int)Mathf.Log(N);
            FrequencyTexture = InitializeRenderTexture(new Vector2(N, N));
            ButterflyTexture = InitializeRenderTexture(new Vector2(Mathf.Log(N, 2), N));

            var bitReversedArray = new int[N];
            for (int j = 0; j < N; j++)
            {
                bitReversedArray[j] = NumberDistributions.BitReverse(j, N);
            }
            BitReversedBuffer = new ComputeBuffer(N, sizeof(int));
            BitReversedBuffer.SetData(bitReversedArray);

            int horizontal = FourierCompute.FindKernel("HorizontalFFT");
            int vertical = FourierCompute.FindKernel("VerticalFFT");
            int readFft = FourierCompute.FindKernel("ReadFFT");
            int bitReverseX = FourierCompute.FindKernel("BitReverseTextureX");
            int bitReverseY = FourierCompute.FindKernel("BitReverseTextureY");
            int initalize = FourierCompute.FindKernel("InitializeFrequencyTexture");
            int shift = FourierCompute.FindKernel("ShiftTexture");

            var inputTex = new Texture2D(N, N);

            for (int x = 1; x <= N; x++)
            {
                for (int y = 1; y <= N; y++)
                {
                    inputTex.SetPixel(x - 1, y - 1,
                        x % 2 == 0
                            ? y % 2 == 0
                                ? new Color((float)(x) / (float)(N / 2), 0, 0, 1) :
                                  new Color(0, 0, (float)y / (float)(N / 2), 1)
                            : y % 2 == 0
                                ? new Color(0, (float)(y) / (float)(N / 2), 0, 1)
                                : new Color(0, 0, 0));
                }
            }
            inputTex.Apply();


            FourierCompute.SetTexture(initalize, "_Input", Input);
            FourierCompute.SetTexture(initalize, "_FrequencyTexture", FrequencyTexture);

            FourierCompute.SetTexture(horizontal, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetInt("_Resolution", N);
            FourierCompute.SetFloat("_Time", Time.time + 1);

            FourierCompute.SetBuffer(bitReverseX, "BitReversed", BitReversedBuffer);
            FourierCompute.SetTexture(bitReverseX, "_FrequencyTexture", FrequencyTexture);

            FourierCompute.SetTexture(bitReverseY, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetBuffer(bitReverseY, "BitReversed", BitReversedBuffer);

            FourierCompute.SetTexture(vertical, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetInt("_Resolution", N);
            FourierCompute.SetFloat("_Time", Time.time + 1);

            FourierCompute.SetBuffer(horizontal, "BitReversed", BitReversedBuffer);
            FourierCompute.SetBuffer(vertical, "BitReversed", BitReversedBuffer);

            FourierCompute.SetTexture(readFft, "_FrequencyTexture", FrequencyTexture);


            //int butterflyKernel = FourierCompute.FindKernel("GenerateButterflyTexture");
            //FourierCompute.SetBuffer(butterflyKernel, "_BitReversed", BitReversedBuffer);
            //FourierCompute.SetTexture(butterflyKernel, "ButterflyTexture", ButterflyTexture);
            //FourierCompute.SetTexture(butterflyKernel, "Pong0Texture", FrequencyTexture);
            //FourierCompute.SetTexture(butterflyKernel, "Pong1Texture", FrequencyTexture);

            FourierCompute.Dispatch(initalize, N / 8, N / 8, 1);

            FourierCompute.Dispatch(bitReverseX, N, 1, 1);
            FourierCompute.Dispatch(horizontal, N, 1, 1);

            //FourierCompute.Dispatch(butterflyKernel, N / 8, N / 8, 1);

            FourierCompute.Dispatch(readFft, N / 8, N / 8, 1);

            FourierCompute.SetTexture(shift, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.Dispatch(shift, N / 2, N, 1);

            //FourierCompute.Dispatch(bitReverseY, N, 1, 1);
            //FourierCompute.Dispatch(vertical, N, 1, 1);


            FrequencyTexture.Save("C:/Users/Dobbydoo/Pictures/FrequencySpectrum.png");


            BitReversedBuffer.Release();
        }

        public void DoFFT2D(int dir)
        {
            Output = new Texture2D(N, N);
            Inverse = new Texture2D(N, N);

            var fft = new FFTObject(N, 1);

            var complexList = fft.Texture2DToComplex(Input);

            var forwardFFT = fft.Analyse2D(complexList);

            //EdgeDetection(0.25f, ref forwardFFT);

            fft.Draw(forwardFFT, ref Output);
            //Draw2DFFTReal(forwardFFT, ref Output, dir);

            //complexList = Texture2DToComplex(Output, -dir);
            //var inverseFFT = Fft2D(complexList, -dir);

            fft.Dir = -dir;
            var inverseFFT = fft.Analyse2D(forwardFFT);

            //Draw2DFFTPretty(forwardFFT, ref Output, dir);

            fft.Draw(inverseFFT, ref Inverse);

            //Output.Save("C:/Users/Dobbydoo/Pictures/FFT.png");
        }        

        public void OnValidate()
        {
            if (N <= 0) N = 64;
            if (N % 2 != 0) N = 256;
            if (N > 1024) N = 1024;

            CreateWaveTexture();
            CreateFrequencyTexture();
        }

        public RenderTexture InitializeRenderTexture(Vector2 size)
        {
            var texture = new RenderTexture((int)size.x, (int)size.y, 1);
            texture.enableRandomWrite = true;
            texture.Create();

            return texture;
        }
    }
}
