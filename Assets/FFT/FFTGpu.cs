using Assets.ImageExtensions;
using System;
using UnityEngine;

namespace Assets.FFT {
    class FFTGpu {
        [Header("Texture properties")]
        public int N;

        public ComputeShader FourierCompute;

        public bool Reload;

        public bool DrawReal;
        public bool Shift;

        internal RenderTexture Input;
        internal RenderTexture Pong0Texture;
        internal RenderTexture Pong1Texture;

        ComputeBuffer BitReversedBuffer;

        public bool TransformInverse { get; private set; }

        int horizontal;
        int vertical;
        int initalize;
        int bitReverseX;
        int bitReverseY;
        int readFft;
        int shift;

        public FFTGpu(RenderTexture input, ComputeShader fftComputeShader, int size)
        {
            Input = input;
            FourierCompute = fftComputeShader;

            N = size;

            Initialize();
        }

        public void Initialize()
        {            
            if (!Mathf.IsPowerOfTwo(N))
            {
               // throw new Exception("Texture must be a power of two");
            }

            int logN = (int)Mathf.Log(N, 2);

            BitReversedBuffer = new ComputeBuffer(N, sizeof(int));
            BitReversedBuffer.SetData(NumberDistributions.GetBitReversedArrayOfSize(N));

            Pong0Texture = Pong0Texture.Initialize(new Vector2(N, N));
            Pong1Texture = Pong1Texture.Initialize(new Vector2(N, N));

            FindKernels();
            SetShaderVariables();
        }

        public RenderTexture AnalyseImage()
        {
            FourierCompute.Dispatch(initalize, N / 8, N / 8, 1);

            FourierCompute.Dispatch(bitReverseX, N, 1, 1);
            FourierCompute.Dispatch(horizontal, N, 1, 1);
            FourierCompute.Dispatch(bitReverseY, N, 1, 1);
            FourierCompute.Dispatch(vertical, N, 1, 1);

            if (Shift)
            {
                FourierCompute.Dispatch(shift, N / 2, N, 1);
            }
            if (DrawReal)
            {
                FourierCompute.Dispatch(readFft, N / 8, N / 8, 1);
            }

            return Pong0Texture;
        }

        public void SetDirection(int dir)
        {
            TransformInverse = dir == -1 ? true : false;
            FourierCompute.SetInt("_Dir", dir);
        }

        private void OnDestroy()
        {
            BitReversedBuffer.Release();
        }

        private void FindKernels()
        {
            horizontal = FourierCompute.FindKernel("HorizontalButterflyPass");
            vertical = FourierCompute.FindKernel("VerticalButterflyPass");
            initalize = FourierCompute.FindKernel("InitializeTexture");
            bitReverseX = FourierCompute.FindKernel("BitReverseTextureX");
            bitReverseY = FourierCompute.FindKernel("BitReverseTextureY");
            readFft = FourierCompute.FindKernel("ReadFFT");
            shift = FourierCompute.FindKernel("ShiftTexture");
        }

        private void SetShaderVariables()
        {
            FourierCompute.SetInt("N", N);

            FourierCompute.SetTexture(initalize, "_InputTexture", Input);
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
        }
    }
}
