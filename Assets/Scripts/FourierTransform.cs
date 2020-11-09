using Assets.FFT;
using Assets.ImageExtensions;
using UnityEngine;

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
        public RenderTexture ButterflyTexture;
        internal RenderTexture Pong0Texture;
        internal RenderTexture Pong1Texture;

        public ComputeShader FourierCompute;

        ComputeBuffer BitReversedBuffer;

        public bool Reload;

        public float ForwardStrength;
        public float InverseStrength;
        public bool DrawReal;
        public bool ShiftFirstPass;
        public bool ShiftSecondPass;

        public bool TransformInverse;

        public Tessendorf tessendorf;

        public void Start()
        {
            tessendorf = GetComponent<Tessendorf>();
        }

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

        public void CreateButterflyTexture()
        {
            //int butterflyKernel = FourierCompute.FindKernel("Butterfly");
            int horizontal = FourierCompute.FindKernel("HorizontalButterflyPass");
            int vertical = FourierCompute.FindKernel("VerticalButterflyPass");
            int initalize = FourierCompute.FindKernel("InitializeTexture");
            int bitReverseX = FourierCompute.FindKernel("BitReverseTextureX");
            int bitReverseY = FourierCompute.FindKernel("BitReverseTextureY");

            int readFft = FourierCompute.FindKernel("ReadFFT");
            int shift = FourierCompute.FindKernel("ShiftTexture");


            int logN = (int)Mathf.Log(N, 2);
            BitReversedBuffer = new ComputeBuffer(N, sizeof(int));
            BitReversedBuffer.SetData(NumberDistributions.GetBitReversedArrayOfSize(N));

            Pong0Texture = Pong0Texture.Initialize(new Vector2(N, N));
            Pong1Texture = Pong1Texture.Initialize(new Vector2(N, N));
            WaveTexture = WaveTexture.Initialize(new Vector2(N, N));
            ButterflyTexture = ButterflyTexture.Initialize(new Vector2(logN, N));

            int dir = TransformInverse ? -1 : 1;

            FourierCompute.SetInt("N", N);
            FourierCompute.SetInt("_Dir", dir);

            FourierCompute.SetTexture(initalize, "_InputTexture", tessendorf.TimedependentHTex);
            FourierCompute.SetTexture(initalize, "_Pong0Texture", Pong0Texture);
            FourierCompute.SetTexture(initalize, "_Pong1Texture", Pong1Texture);
            
            FourierCompute.SetTexture(bitReverseX, "_Pong0Texture", Pong0Texture);
            FourierCompute.SetTexture(bitReverseX, "_Pong1Texture", Pong1Texture);
            FourierCompute.SetBuffer(bitReverseX, "_BitReversed", BitReversedBuffer);

            FourierCompute.SetTexture(bitReverseY, "_Pong0Texture", Pong0Texture);
            FourierCompute.SetTexture(bitReverseY, "_Pong1Texture", Pong1Texture);
            FourierCompute.SetBuffer(bitReverseY, "_BitReversed", BitReversedBuffer);

            FourierCompute.SetTexture(shift, "_Pong0Texture", Pong0Texture);
            FourierCompute.SetTexture(readFft, "_Pong0Texture", Pong0Texture);

            FourierCompute.SetTexture(horizontal, "_Pong0Texture", Pong0Texture);
            FourierCompute.SetTexture(horizontal, "_Pong1Texture", Pong1Texture);

            FourierCompute.SetTexture(vertical, "_Pong0Texture", Pong0Texture);
            FourierCompute.SetTexture(vertical, "_Pong1Texture", Pong1Texture);
            
            FourierCompute.Dispatch(initalize, N / 8, N / 8, 1);

            FourierCompute.Dispatch(bitReverseX, N, 1, 1);
            FourierCompute.Dispatch(horizontal, N, 1, 1);
            FourierCompute.Dispatch(bitReverseY, N, 1, 1);
            FourierCompute.Dispatch(vertical, N, 1, 1);


            //FourierCompute.Dispatch(shift, N / 2, N, 1);


            FourierCompute.SetInt("_Dir", -dir);

            /*FourierCompute.Dispatch(bitReverseX, N, 1, 1);
            FourierCompute.Dispatch(horizontal, N, 1, 1);
            FourierCompute.Dispatch(bitReverseY, N, 1, 1);
            FourierCompute.Dispatch(vertical, N, 1, 1);*/

            //Pong0Texture.Save("C:/Users/Dobbydoo/Pictures/Pong0.png");

            if (ShiftFirstPass)
            {
                FourierCompute.Dispatch(shift, N / 2, N, 1);
            }
            if (DrawReal)
            {
                FourierCompute.Dispatch(readFft, N / 8, N / 8, 1);
            }
        }

        public void CreateFrequencyTexture()
        {
            var logN = (int)Mathf.Log(N);
            WaveTexture = WaveTexture.Initialize(new Vector2(N, N));
            FrequencyTexture = FrequencyTexture.Initialize(new Vector2(N, N));
            ButterflyTexture = ButterflyTexture.Initialize(new Vector2(Mathf.Log(N, 2), N));

            BitReversedBuffer = new ComputeBuffer(N, sizeof(int));
            BitReversedBuffer.SetData(NumberDistributions.GetBitReversedArrayOfSize(N));

            int horizontal = FourierCompute.FindKernel("HorizontalFFT");
            int vertical = FourierCompute.FindKernel("VerticalFFT");
            int readFft = FourierCompute.FindKernel("ReadFFT");
            int shift = FourierCompute.FindKernel("ShiftTexture");
            int bitReverseX = FourierCompute.FindKernel("BitReverseTextureX");
            int bitReverseY = FourierCompute.FindKernel("BitReverseTextureY");
            int initalize = FourierCompute.FindKernel("InitializeFrequencyTexture");

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

            FourierCompute.SetTexture(initalize, "_InitialTexture", WaveTexture);
            FourierCompute.SetTexture(bitReverseY, "_InitialTexture", WaveTexture);
            FourierCompute.SetTexture(bitReverseX, "_InitialTexture", WaveTexture);
            FourierCompute.SetTexture(horizontal, "_InitialTexture", WaveTexture);
            FourierCompute.SetTexture(vertical, "_InitialTexture", WaveTexture);

            FourierCompute.SetTexture(initalize, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetTexture(horizontal, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetTexture(bitReverseX, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetTexture(bitReverseY, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetTexture(vertical, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetTexture(readFft, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetTexture(shift, "_FrequencyTexture", FrequencyTexture);

            FourierCompute.SetBuffer(bitReverseX, "BitReversed", BitReversedBuffer);
            FourierCompute.SetBuffer(bitReverseY, "BitReversed", BitReversedBuffer);
            FourierCompute.SetBuffer(horizontal, "BitReversed", BitReversedBuffer);
            FourierCompute.SetBuffer(vertical, "BitReversed", BitReversedBuffer);

            FourierCompute.SetInt("_Resolution", N);
            
            FourierCompute.SetFloat("_Time", Time.time + 1);
            





            //int butterflyKernel = FourierCompute.FindKernel("GenerateButterflyTexture");
            //FourierCompute.SetBuffer(butterflyKernel, "_BitReversed", BitReversedBuffer);
            //FourierCompute.SetTexture(butterflyKernel, "ButterflyTexture", ButterflyTexture);
            //FourierCompute.SetTexture(butterflyKernel, "Pong0Texture", FrequencyTexture);
            //FourierCompute.SetTexture(butterflyKernel, "Pong1Texture", FrequencyTexture);

            FourierCompute.Dispatch(initalize, N / 8, N / 8, 1);

            FourierCompute.Dispatch(bitReverseX, N, 1, 1);
            FourierCompute.Dispatch(horizontal, N, 1, 1);
            FourierCompute.Dispatch(bitReverseY, N, 1, 1);
            FourierCompute.Dispatch(vertical, N, 1, 1);


            //FourierCompute.Dispatch(butterflyKernel, N / 8, N / 8, 1);

            FourierCompute.Dispatch(shift, N / 2, N, 1);

            FourierCompute.Dispatch(readFft, N / 8, N / 8, 1);

            FrequencyTexture.Save("C:/Users/Dobbydoo/Pictures/FrequencySpectrum.png");


            BitReversedBuffer.Release();
        }

        public void Update()
        {
            tessendorf.VisualizeNoiseGpu();
            CreateButterflyTexture();
        }

        public void DoFFT2D(int dir)
        {
            Output = new Texture2D(N, N);
            Inverse = new Texture2D(N, N);

            var fft = new FFTObject(N, dir);

            var complexList = fft.Texture2DToComplex(Input);

            var forwardFFT = fft.Analyse2D(complexList);
            
            fft.Dir = -dir;

            var inverseFFT = fft.Analyse2D(forwardFFT);

            if (DrawReal)
            {
                fft.DrawReal(forwardFFT, ref Output, ForwardStrength, ShiftFirstPass);
                fft.DrawReal(inverseFFT, ref Inverse, InverseStrength, ShiftSecondPass);
            } else
            {
                fft.Draw(forwardFFT, ref Output, ForwardStrength, ShiftFirstPass);
                fft.Draw(inverseFFT, ref Inverse, InverseStrength, ShiftSecondPass);
            }

            Output.Save("C:/Users/Dobbydoo/Pictures/FFT.png");
        }        

        public void OnValidate()
        {
            //if (N != Input.width) N = Input.width;

            if (N <= 0) N = 64;
            if (N % 2 != 0) N = 256;
            if (N > 1024) N = 1024;


            //CreateWaveTexture();
            //CreateFrequencyTexture();
        }
    }
}
