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
        
        GUILayout.Label("GPU Textures");
        t.H0KTex.DrawTextureField("h0k", texSize);
        t.H0NegativeKTex.DrawTextureField("h0(-k)", texSize);
        t.TimedependentHTex.DrawTextureField("hkt", texSize);        
        
        GUILayout.Label("Displacement texture (GPU)");
        t.DisplacementTexture.DrawTextureField("Displacement texture", texSize);        
                
        if (GUILayout.Button("Initialize"))
        {
            ((WaterBehaviour)target).Start();
        }        
    }
}
