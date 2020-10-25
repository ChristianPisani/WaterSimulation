using Assets.FFT;
using UnityEngine;

namespace Assets.Scripts {
    class FourierTransform : MonoBehaviour {
        public Texture2D Input;

        [Header("Wave properties")]
        public float Rotation;
        public float Frequency;
        public Vector2 Strength;

        [Header("Texture properties")]
        public int N;

        internal RenderTexture WaveTexture;
        internal RenderTexture FrequencyTexture;

        public ComputeShader FourierCompute;

        ComputeBuffer BitReversedBuffer;

        public void CreateWaveTexture()
        {
            WaveTexture = InitializeRenderTexture(new Vector2(N, N));
            
            int kernel = FourierCompute.FindKernel("GenerateWaveTexture");

            FourierCompute.SetTexture(kernel, "_WaveTexture", WaveTexture);
            
            FourierCompute.SetFloat("_Time", Time.time + 1);
            FourierCompute.SetFloat("_Rotation", Rotation);
            FourierCompute.SetFloat("_Frequency", Frequency);
            FourierCompute.SetFloat("N", N);
            FourierCompute.SetVector("_Strength", Strength);

            FourierCompute.Dispatch(kernel, N / 8, N / 8, 1);            
        }

        public void CreateFrequencyTexture()
        {
            if (WaveTexture == null) return;

            var logN = (int)Mathf.Log(N);
            FrequencyTexture = InitializeRenderTexture(new Vector2(N, N));

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

            FourierCompute.SetTexture(horizontal, "_WaveTexture", WaveTexture);
            FourierCompute.SetTexture(horizontal, "_Input", Input);
            FourierCompute.SetTexture(horizontal, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetInt("_Resolution", N);
            FourierCompute.SetFloat("_Time", Time.time + 1);

            var inputTex = new Texture2D(N, N);

            for (int x = 1; x <= N; x++)
            {
                for (int y = 1; y <= N; y++)
                {
                    inputTex.SetPixel(x - 1, y - 1, 
                        x % 2 == 0 
                            ? y % 2 == 0 
                                ? new Color((float)(x) / (float)(N), 0, 0, 1) :
                                  new Color(0, 0, (float)y / (float)N, 1)
                            : y % 2 == 0 
                                ? new Color(0, (float)(y) / (float)(N), 0, 1)
                                : new Color(0, 0, 0));
                }
            }
            inputTex.Apply();

            FourierCompute.SetBuffer(bitReverseX, "_BitReversed", BitReversedBuffer);
            FourierCompute.SetTexture(bitReverseX, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetTexture(bitReverseX, "_Input", Input);

            FourierCompute.SetTexture(bitReverseY, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetBuffer(bitReverseY, "_BitReversed", BitReversedBuffer);
            
            FourierCompute.SetTexture(vertical, "_WaveTexture", WaveTexture);
            FourierCompute.SetTexture(vertical, "_FrequencyTexture", FrequencyTexture);
            FourierCompute.SetInt("_Resolution", N);
            FourierCompute.SetFloat("_Time", Time.time + 1);
            FourierCompute.SetBuffer(vertical, "_BitReversed", BitReversedBuffer);
            FourierCompute.SetBuffer(horizontal, "_BitReversed", BitReversedBuffer);
            
            FourierCompute.SetTexture(readFft, "_FrequencyTexture", FrequencyTexture);

            //FourierCompute.Dispatch(bitReverseX, N / 8, N / 8, 1);
            FourierCompute.Dispatch(horizontal, N / 8, N / 8, 1);
            //FourierCompute.Dispatch(bitReverseY, N / 8, N / 8, 1);
            //FourierCompute.Dispatch(vertical, N / 8, N / 8, 1);
            FourierCompute.Dispatch(readFft, N / 8, N / 8, 1);
            

            BitReversedBuffer.Release();
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
