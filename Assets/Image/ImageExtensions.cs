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
    }
}
