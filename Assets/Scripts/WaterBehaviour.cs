using Assets.FFT;
using Assets.ImageExtensions;
using UnityEngine;

namespace Assets.Scripts {
    class WaterBehaviour : MonoBehaviour {
        public float Amplitude = 1;
        public float NormalStrength;
        public float DisplacementStrength;
        public float TimeScale = 1;
        public Vector2 WindDirection = new Vector2(1, 1);
        public float WindForce = 40;
        public float Depth = 10;
        public int N = 256;
        public Material WaterMaterial;

        public ComputeShader WaterShader;
        public ComputeShader FFTShader;

        internal RenderTexture H0KTex;
        internal RenderTexture H0NegativeKTex;
        internal RenderTexture TimedependentHTex;
        internal RenderTexture NormalSpectrum;
        internal RenderTexture NormalTex;
        internal RenderTexture DisplacementTexture;
        internal Texture2D NoiseTexture;

        private int setupKernel;
        private int timeDependentTextureKernel;
        
        internal FFTGpu FFT;
        internal FFTGpu NormalFFT;

        public void Start()
        {
            Initialize();
        }

        public void Initialize()
        {
            CreateGaussianNoiseTexture();
            CreateTextures();
            SetShaderVariables();
            GenerateFrequencyDomain();

            if (InValidState()) return;

            WaterShader.Dispatch(setupKernel, N / 8, N / 8, 1);

            FFT = new FFTGpu(TimedependentHTex, Instantiate(FFTShader), N);
            FFT.SetDirection(-1);
            FFT.Shift = true;
            FFT.DrawReal = true;

            NormalFFT = new FFTGpu(NormalSpectrum, Instantiate(FFTShader), N);
            NormalFFT.SetDirection(-1);
            NormalFFT.Shift = true;
            //NormalFFT.DrawReal = true;

            GenerateWaterHeightField();

            WaterMaterial.SetTexture("_HeightMap", FFT.Pong0Texture);
            WaterMaterial.SetTexture("_NormalMap", NormalFFT.Pong0Texture);
        }

        public void Update()
        {
            if (InValidState()) return;

            WaterShader.SetFloat("_Time", (Time.time + 1000) * TimeScale);

            GenerateFrequencyDomain();
            GenerateWaterHeightField();
        }

        public void GenerateFrequencyDomain()
        {
            if (InValidState()) return;

            WaterShader.Dispatch(timeDependentTextureKernel, N / 8, N / 8, 1);
        }

        public void GenerateWaterHeightField()
        {
            FFT.AnalyseImage();
            NormalFFT.AnalyseImage();
        }

        private bool InValidState()
        {
            return H0KTex == null || H0NegativeKTex == null || WaterShader == null || NoiseTexture == null || FFTShader == null;
        }

        private void CreateTextures()
        {
            H0KTex = H0KTex.Initialize(N);
            H0NegativeKTex = H0NegativeKTex.Initialize(N);
            TimedependentHTex = TimedependentHTex.Initialize(N);
            DisplacementTexture = DisplacementTexture.Initialize(N);
            NormalTex = NormalTex.Initialize(N);
            NormalSpectrum = NormalSpectrum.Initialize(N);
        }

        private void FindKernels()
        {
            setupKernel = WaterShader.FindKernel("Setup");
            timeDependentTextureKernel = WaterShader.FindKernel("GenerateTimeDependentTexture");
        }

        private void SetShaderVariables()
        {
            WaterShader.SetFloat("_Time", (Time.time + 1000) * TimeScale);
            WaterShader.SetFloat("_Amplitude", Amplitude);
            WaterShader.SetFloat("_WindForce", WindForce);
            WaterShader.SetVector("_WindDirection", WindDirection);
            WaterShader.SetFloat("_Depth", Depth);
            WaterShader.SetInt("_Resolution", N);
            WaterShader.SetFloat("_NormalStrength", NormalStrength);
            WaterShader.SetFloat("_DisplacementStrength", DisplacementStrength);

            WaterShader.SetTexture(setupKernel, "H0KTexture", H0KTex);
            WaterShader.SetTexture(setupKernel, "HTKTexture", TimedependentHTex);
            WaterShader.SetTexture(setupKernel, "NormalTexture", NormalSpectrum);
            WaterShader.SetTexture(setupKernel, "H0NegKTexture", H0NegativeKTex);
            WaterShader.SetTexture(setupKernel, "NoiseTexture", NoiseTexture);

            WaterShader.SetTexture(timeDependentTextureKernel, "H0KTexture", H0KTex);
            WaterShader.SetTexture(timeDependentTextureKernel, "HTKTexture", TimedependentHTex);
            WaterShader.SetTexture(timeDependentTextureKernel, "NormalTexture", NormalSpectrum);
            WaterShader.SetTexture(timeDependentTextureKernel, "H0NegKTexture", H0NegativeKTex);
            WaterShader.SetTexture(timeDependentTextureKernel, "NoiseTexture", NoiseTexture);
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

        public void OnValidate()
        {
            if(N == 64)
            {
                N = 64;
            }
        }
    }
}
