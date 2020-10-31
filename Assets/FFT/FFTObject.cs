using System;
using System.Collections.Generic;
using System.Linq;
using Complex = System.Numerics.Complex;
using UnityEngine;

namespace Assets.FFT {
    public class FFTObject {
        private readonly int N;
        public int Dir;

        public FFTObject(int n, int dir)
        {
            N = n;
            Dir = dir;
        }

        public void EdgeFilter(float treshold, ref List<List<Complex>> input)
        {
            input = input.Select(x => x.Select(c => {
                return c.Magnitude / N > treshold ? Complex.Zero : c;
            })
            .ToList())
            .ToList();
        }

        public List<List<Complex>> Analyse2D(List<List<Complex>> input)
        {
            var output = input.Select(c => Analyze(c)).ToList();

            for (int x = 0; x < N; x++)
            {
                var col = new List<Complex>();

                for (int y = 0; y < N; y++)
                {
                    var complex = output[y][x];

                    col.Add(complex);
                }

                col = Analyze(col);

                for (int y = 0; y < N; y++)
                {
                    output[y][x] = col[y];
                }
            }

            return output;
        }

        public void Draw(List<List<Complex>> fft, ref Texture2D outputTexture)
        {
            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    var complex = fft[y][x] * Mathf.Log(N);

                    Vector2 shiftUV = new Vector2(
                        (x + N / 2) % N,
                        (y + N / 2) % N
                    );

                    var complex2 = fft[(int)shiftUV.y][(int)shiftUV.x];

                    var freq = Dir == -1 ? complex.Magnitude : complex2.Magnitude;

                    var constant = Dir == -1 ? 1.0f : 1;
                    var mag = (float)(freq);

                    outputTexture.SetPixel(x, y, new Color(mag, mag, mag, 1));
                }
            }

            outputTexture.Apply();
        }

        public void DrawReal(List<List<Complex>> fft, ref Texture2D outputTexture)
        {
            for (int x = 0; x < N; x++)
            {
                for (int y = 0; y < N; y++)
                {
                    var complex = fft[y][x] / N;

                    outputTexture.SetPixel(x, y, new Color((float)(Math.Abs(complex.Real + 32f) / (64f)), (float)(Math.Abs(complex.Imaginary + 32f) / (64f)), 0, 1));
                }
            }

            outputTexture.Apply();
        }

        public List<Complex> Analyze(List<Complex> X)
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

                Complex wm = Complex.Exp((Complex.ImaginaryOne * -Dir * 2.0f * Mathf.PI) / m);

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

            for (int i = 0; i < bitReversed.Count; i++)
            {
                bitReversed[i] /= (float)N;
            }

            return bitReversed;
        }

        public List<Complex> AnalyzeRadix2(List<Complex> X)
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

            even = AnalyzeRadix2(even);
            odd = AnalyzeRadix2(odd);

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

        public List<List<Complex>> Texture2DToComplex(Texture2D inputTexture)
        {
            var output = new List<List<Complex>>();

            for (int y = 0; y < N; y++)
            {
                var row = new List<Complex>();

                for (int x = 0; x < N; x++)
                {
                    var c = inputTexture.GetPixel(x, y);

                    var complex = new Complex(Dir == -1 ? c.r : c.r, Dir == -1 ? c.g : 0);

                    row.Add(complex);
                }

                output.Add(row);
            }

            return output;
        }
    }
}
