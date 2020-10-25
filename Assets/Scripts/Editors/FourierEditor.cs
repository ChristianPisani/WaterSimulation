using UnityEditor;
using UnityEngine;

namespace Assets.Scripts.Editors {
    [CustomEditor(typeof(FourierTransform))]
    class FourierEditor : Editor {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();

            var fourier = target as FourierTransform;

            DrawTextureField("Input texture", fourier.Input, 200);
            DrawTextureField("Frequencytexture", fourier.FrequencyTexture, 200);

            if (GUILayout.Button("Run"))
            {
                fourier.CreateWaveTexture();
            }
        }

        private static void DrawTextureField(string name, RenderTexture texture, int width)
        {
            GUILayout.BeginVertical();
            var style = new GUIStyle(GUI.skin.label);
            style.alignment = TextAnchor.UpperCenter;
            
            style.fixedWidth = width;

            texture.filterMode = FilterMode.Point;

            GUILayout.Label(name, style);
            EditorGUILayout.ObjectField(null, typeof(RenderTexture), false, GUILayout.Width(width), GUILayout.Height(width));

            GUI.DrawTexture(GUILayoutUtility.GetLastRect(), texture);

            GUILayout.EndVertical();
        }

        private static void DrawTextureField(string name, Texture2D texture, int width)
        {
            GUILayout.BeginVertical();
            var style = new GUIStyle(GUI.skin.label);
            style.alignment = TextAnchor.UpperCenter;

            style.fixedWidth = width;

            texture.filterMode = FilterMode.Point;

            GUILayout.Label(name, style);
            EditorGUILayout.ObjectField(null, typeof(Texture2D), false, GUILayout.Width(width), GUILayout.Height(width));

            GUI.DrawTexture(GUILayoutUtility.GetLastRect(), texture, ScaleMode.ScaleAndCrop);

            GUILayout.EndVertical();
        }

        private static Texture2D ToTexture2D(RenderTexture rTex)
        {
            Texture2D tex = new Texture2D(rTex.width, rTex.height, TextureFormat.RGB24, false);
            RenderTexture.active = rTex;
            tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
            tex.Apply();
            return tex;
        }
    }
}
