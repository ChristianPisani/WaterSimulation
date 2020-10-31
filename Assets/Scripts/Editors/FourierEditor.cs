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


            DrawTextureField("Input texture", fourier.Input, 512);
            DrawTextureField("1st pass texture CPU", fourier.Output, 512);
            DrawTextureField("2nd pass texture CPU", fourier.Inverse, 512);
            //DrawTextureField("Frequencytexture", fourier.FrequencyTexture, 200);
            //DrawTextureField("Butterfly Texture", fourier.ButterflyTexture, 200);

            if (GUILayout.Button("Forward first"))
            {
                fourier.DoFFT2D(1);
            }

            if (GUILayout.Button("Inverse first"))
            {
                fourier.DoFFT2D(-1);
            }

            GUILayout.EndVertical();
        }

        private static void DrawTextureField(string name, RenderTexture texture, int width)
        {
            if (texture == null) return;

            var style = new GUIStyle(GUI.skin.label);
            style.alignment = TextAnchor.UpperCenter;
            
            style.fixedWidth = width;

            texture.filterMode = FilterMode.Point;

            GUILayout.Label(name, style);
            EditorGUILayout.ObjectField(null, typeof(RenderTexture), false, GUILayout.Width(width), GUILayout.Height(width));
            
            GUI.DrawTexture(GUILayoutUtility.GetLastRect(), texture);            
        }

        private static void DrawTextureField(string name, Texture2D texture, int width)
        {
            if (texture == null) return;

            var style = new GUIStyle(GUI.skin.label);
            style.alignment = TextAnchor.UpperCenter;

            style.fixedWidth = width;

            texture.filterMode = FilterMode.Point;

            GUILayout.Label(name, style);
            EditorGUILayout.ObjectField(null, typeof(Texture2D), false, GUILayout.Width(width), GUILayout.Height(width));

            GUI.DrawTexture(GUILayoutUtility.GetLastRect(), texture, ScaleMode.ScaleAndCrop);
        }
    }
}
