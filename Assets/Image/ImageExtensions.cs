using UnityEditor;
using UnityEngine;

namespace Assets.ImageExtensions {
    public static class ImageExtensions {
        public static void Save(this RenderTexture rt, string path)
        {
            byte[] bytes = rt.ToTexture2D().EncodeToPNG();
            System.IO.File.WriteAllBytes(path, bytes);
        }

        public static void Save(this Texture2D t, string path)
        {
            byte[] bytes = t.EncodeToPNG();
            System.IO.File.WriteAllBytes(path, bytes);
        }

        public static Texture2D ToTexture2D(this RenderTexture rTex)
        {
            Texture2D tex = new Texture2D(rTex.width, rTex.height, TextureFormat.RGB24, false);
            RenderTexture.active = rTex;
            tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
            tex.Apply();
            return tex;
        }

        public static void DrawTextureField(this RenderTexture texture, string name, int width)
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

        public static void DrawTextureField(this Texture2D texture, string name, int width)
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


        public static RenderTexture Initialize(this RenderTexture tex, Vector2 size)
        {
            var texture = new RenderTexture((int)size.x, (int)size.y, 1);
            texture.enableRandomWrite = true;
            texture.format = RenderTextureFormat.DefaultHDR;
            texture.antiAliasing = 1000;
            texture.filterMode = FilterMode.Trilinear;
            texture.useDynamicScale = true;
            texture.Create();

            return texture;
        }

        public static RenderTexture Initialize(this RenderTexture tex, int width, int height = 0)
        {
            if (height == 0) height = width;
            
            return Initialize(tex, new Vector2(width, height));
        }
    }
}
