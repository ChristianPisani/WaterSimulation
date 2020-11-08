using Assets.ImageExtensions;
using UnityEditor;
using UnityEngine;

namespace Assets.Scripts.Editors {
    [CustomEditor(typeof(FourierTransform))]
    class FourierEditor : Editor {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();

            var fourier = target as FourierTransform;

            GUILayout.BeginVertical();


            fourier.Input.DrawTextureField("Input texture", 200);
            //fourier.Output.DrawTextureField("1st pass texture CPU", 200);
            //DrawTextureField("2nd pass texture CPU", fourier.Inverse, 200);
            //fourier.FrequencyTexture.DrawTextureField("Frequencytexture", 200);
            //fourier.WaveTexture.DrawTextureField("WaveTexture", 200);
            //fourier.ButterflyTexture.DrawTextureField("Butterfly Texture", 200);
            fourier.Pong0Texture.DrawTextureField("Ping pong 0", 200);
            fourier.Pong1Texture.DrawTextureField("Ping pong 1", 200);

            if (GUILayout.Button("Forward first"))
            {
                fourier.DoFFT2D(1);
            }

            if (GUILayout.Button("Inverse first"))
            {
                fourier.DoFFT2D(-1);
            }

            if (GUILayout.Button("Butterfly"))
            {
                fourier.CreateButterflyTexture();
            }

            GUILayout.EndVertical();
        }       
    }
}
