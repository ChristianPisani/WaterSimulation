using Assets.ImageExtensions;
using Assets.Scripts;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(ShaderTextureBlit))]
class ShaderEditor : Editor {
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        Texture2D myTexture = AssetPreview.GetAssetPreview(((ShaderTextureBlit)target).tex);
        GUILayout.Label(myTexture);

        if (GUILayout.Button("Run"))
        {
            ((ShaderTextureBlit)target).DispatchShader();
        }
    }
}

[CustomEditor(typeof(Tessendorf))]
class TessendorfEditor : Editor {
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        var t = (Tessendorf)target;

        int texSize = 250;

        GUILayout.Label("CPU Textures");
        Texture2D tex = AssetPreview.GetAssetPreview((t).H0KTexCPU);
        t.H0KTexCPU.DrawTextureField("h0k", texSize);
        t.H0NegativeKTexCPU.DrawTextureField("h0(-k)", texSize);
        t.TimedependentHTexCPU.DrawTextureField("h0k t", texSize);
        
        GUILayout.Label("GPU Textures");
        t.H0KTex.DrawTextureField("h0k", texSize);
        t.H0NegativeKTex.DrawTextureField("h0(-k)", texSize);
        t.TimedependentHTex.DrawTextureField("h0 kt", texSize);
        
        GUILayout.Label("Butterfly texture (GPU)");
        t.ButterflyTexture.DrawTextureField("Butterfly", texSize);
        
        GUILayout.Label("Ping pong textures (GPU)");
        t.Pong0Texture.DrawTextureField("Ping pong 0", texSize);
        t.Pong1Texture.DrawTextureField("Ping pon 1", texSize);
        
        GUILayout.Label("Displacement texture (GPU)");
        t.DisplacementTexture.DrawTextureField("Displacement texture", texSize);        

        t.NoiseTexture.DrawTextureField("Gaussian noise texture", texSize);        

        if (GUILayout.Button("Visalize noise CPU"))
        {
            ((Tessendorf)target).VisualizeNoiseCpu();
        }

        if (GUILayout.Button("Visalize noise GPU"))
        {
            ((Tessendorf)target).CreateVisialization();
        }

        if (GUILayout.Button("Setup noisetexture"))
        {
            ((Tessendorf)target).CreateGaussianNoiseTexture();
        }
    }
}
