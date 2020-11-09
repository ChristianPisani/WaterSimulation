using Assets.FFT;
using Assets.ImageExtensions;
using UnityEngine;

namespace Assets.Scripts {
    class WaterBehaviour : MonoBehaviour {
        public float Amplitude = 1;
        public Vector2 WindDirection = new Vector2(1, 1);
        public float WindForce = 40;
        public float Depth = 10;
        public int N = 256;

        public ComputeShader WaterShader;

        internal RenderTexture H0KTex;
        internal RenderTexture H0NegativeKTex;
        internal RenderTexture TimedependentHTex;
        internal RenderTexture DisplacementTexture;
        internal Texture2D NoiseTexture;

        private int setupKernel;
        private int timeDependentTextureKernel;
        private int displacementKernel;

        public void Start()
        {
            Initialize();
        }

        public void Initialize()
        {
            CreateGaussianNoiseTexture();
            CreateTextures();
            SetShaderVariables();
            CreateWaterHeightField();

            if (InValidState()) return;

            WaterShader.Dispatch(setupKernel, N / 8, N / 8, 1);
        }

        public void Update()
        {
            if (InValidState()) return;

            CreateWaterHeightField();
        }

        public void CreateWaterHeightField()
        {
            if (InValidState()) return;

            WaterShader.Dispatch(timeDependentTextureKernel, N / 8, N / 8, 1);
        }

        private bool InValidState()
        {
            return H0KTex == null || H0NegativeKTex == null || WaterShader == null || NoiseTexture == null;
        }

        private void CreateTextures()
        {
            H0KTex = H0KTex.Initialize(new Vector2(N, N));
            H0NegativeKTex = H0NegativeKTex.Initialize(new Vector2(N, N));
            TimedependentHTex = TimedependentHTex.Initialize(new Vector2(N, N));
            DisplacementTexture = DisplacementTexture.Initialize(new Vector2(N, N));
        }

        private void FindKernels()
        {
            setupKernel = WaterShader.FindKernel("Setup");
            displacementKernel = WaterShader.FindKernel("GenerateTimeDependentTexture");
            timeDependentTextureKernel = WaterShader.FindKernel("GenerateTimeDependentTexture");
        }

        private void SetShaderVariables()
        {
            WaterShader.SetFloat("_Time", Time.time);
            WaterShader.SetFloat("_Amplitude", Amplitude);
            WaterShader.SetFloat("_WindForce", WindForce);
            WaterShader.SetVector("_WindDirection", WindDirection);
            WaterShader.SetFloat("_Depth", Depth);
            WaterShader.SetInt("_Resolution", N);

            WaterShader.SetTexture(setupKernel, "H0KTexture", H0KTex);
            WaterShader.SetTexture(setupKernel, "HTKTexture", TimedependentHTex);
            WaterShader.SetTexture(setupKernel, "H0NegKTexture", H0NegativeKTex);
            WaterShader.SetTexture(setupKernel, "DisplacementTexture", DisplacementTexture);
            WaterShader.SetTexture(setupKernel, "NoiseTexture", NoiseTexture);

            WaterShader.SetTexture(timeDependentTextureKernel, "H0KTexture", H0KTex);
            WaterShader.SetTexture(timeDependentTextureKernel, "HTKTexture", TimedependentHTex);
            WaterShader.SetTexture(timeDependentTextureKernel, "H0NegKTexture", H0NegativeKTex);
            WaterShader.SetTexture(timeDependentTextureKernel, "DisplacementTexture", DisplacementTexture);
            WaterShader.SetTexture(timeDependentTextureKernel, "NoiseTexture", NoiseTexture);

            WaterShader.SetTexture(displacementKernel, "DisplacementTexture", DisplacementTexture);
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
