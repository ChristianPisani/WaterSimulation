using Assets.ImageExtensions;
using Assets.Scripts;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(WaterBehaviour))]
class WaterEditor : Editor {
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        var t = (WaterBehaviour)target;

        int texSize = 250;
        
        t.H0KTex.DrawTextureField("h0k", texSize);
        t.H0NegativeKTex.DrawTextureField("h0(-k)", texSize);
        t.TimedependentHTex.DrawTextureField("hkt", texSize);
        t.NormalSpectrum.DrawTextureField("Normal spectrum", texSize);        

        if (t.FFT != null && t.FFT.Pong0Texture != null)
        {
            t.FFT.Pong0Texture.DrawTextureField("Displacement texture", texSize);
        }
        if (t.NormalFFT != null && t.NormalFFT.Pong0Texture != null)
        {
            t.NormalFFT.Pong0Texture.DrawTextureField("Normal", texSize);
        }
        if (t.ChoppyFFT != null && t.ChoppyFFT.Pong0Texture != null)
        {
            t.ChoppyFFT.Pong0Texture.DrawTextureField("Choppy", texSize);
        }

        if (GUILayout.Button("Initialize"))
        {
            ((WaterBehaviour)target).Start();
        }        
    }
}
