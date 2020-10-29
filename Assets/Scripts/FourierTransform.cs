using Assets.FFT;
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


            SaveTexture(FrequencyTexture, "C:/Users/Dobbydoo/Pictures/FrequencySpectrum.png");


            BitReversedBuffer.Release();
        }

        public void DoFFT2D()
        {
            Output = new Texture2D(N, N);
            Inverse = new Texture2D(N, N);

            var complexList = Texture2DToComplex(Input);

            var forwardFFT = Fft2D(complexList, 1);
            var inverseFFT = Fft2D(forwardFFT, -1);

            Draw2DFFTPretty(forwardFFT, ref Output, false);
            Draw2DFFTPretty(inverseFFT, ref Inverse, true);
        }

        public List<List<Complex>> Texture2DToComplex(Texture2D inputTexture)
        {
            var output = new List<List<Complex>>();

            for (int y = 0; y < N; y++)
            {
                var row = new List<Complex>();

                for (int x = 0; x < N; x++)
                {
                    var c = inputTexture.GetPixel(x, y);

                    var complex = new Complex(c.r, 0);

                    row.Add(complex);
                }
                
                output.Add(row);
            }

            return output;
        }

        public List<List<Complex>> Fft2D(List<List<Complex>> input, int dir)
        {
            Output = new Texture2D(N, N);

            var output = input.Select(c => FFT(c, dir)).ToList();

            for (int x = 0; x < N; x++)
            {
                var col = new List<Complex>();

                for (int y = 0; y < N; y++)
                {                    
                    var complex = output[y][x];

                    col.Add(complex);
                }

                col = FFT(col, dir);

                for(int y = 0; y < N; y++)
                {                    
                    output[y][x] = col[y];
                }                
            }

            return output;
        }

        public void Draw2DFFTPretty(List<List<Complex>> fft, ref Texture2D outputTexture, bool inverse)
        {
            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    var complex = fft[y][x] / (float)N;

                    Vector2 shiftUV = new Vector2(
                        (x + N / 2) % N,
                        (y + N / 2) % N
                    );

                    var complex2 = fft[(int)shiftUV.y][(int)shiftUV.x] / (float)N;

                    var freq = inverse ? complex.Magnitude : complex2.Magnitude;

                    var constant = inverse ? 1.0f / N : 1;
                    var mag = constant * (float)freq;
                    
                    outputTexture.SetPixel(x, y, new Color(mag, mag, mag, 1));
                }
            }

            outputTexture.Apply();
        }

        public List<Complex> FFT(List<Complex> X, int dir)
        {
            int n = X.Count;

            List<Complex> bitReversed = new List<Complex>();

            for (int i = 0; i < n; i++)
            {
                bitReversed.Add(X[NumberDistributions.BitReverse(i, n)]);
            }

            for (int s = 1; s <= Mathf.Log(n, 2); s++)
            {
                int m = (int)Mathf.Pow(2, s);

                Complex wm = Complex.Exp((Complex.ImaginaryOne * dir * 2.0f * Mathf.PI) / m);

                for (int k = 0; k <= n - 1; k += m)
                {
                    Complex w = Complex.One;

                    for (int j = 0; j <= (m / 2) - 1; j++)
                    {
                        var t = w * bitReversed[k + j + (m / 2)];
                        var u = bitReversed[k + j];
                        bitReversed[k + j] = u + t;
                        bitReversed[k + j + (m / 2)] = u - t;
                        w = w * wm;
                    }
                }
            }

            return bitReversed;
        }

        public List<Complex> Radix2FFT(List<Complex> X)
        {
            int n = X.Count;

            if (n == 1)
            {
                return X;
            }

            var even = new List<Complex>();
            var odd = new List<Complex>();

            for (int i = 0; i < n - 1; i += 2)
            {
                even.Add(X[i]);
                odd.Add(X[i + 1]);
            }

            even = Radix2FFT(even);
            odd = Radix2FFT(odd);

            var left = new List<Complex>();
            var right = new List<Complex>();

            for (int i = 0; i < n / 2; i++)
            {
                var complex = (Complex.ImaginaryOne * -2.0 * Math.PI * i) / (float)n;
                //var exp = new Complex(Math.Cos(complex.Real), Math.Sin(complex.Imaginary));
                var exp = Complex.Exp(complex);

                left.Add(even[i] + exp * odd[i]);
                right.Add(even[i] - exp * odd[i]);
            }

            left.AddRange(right);

            return left;
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
