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

        GUILayout.Label("CPU Textures");
        Texture2D t = AssetPreview.GetAssetPreview(((Tessendorf)target).H0KTexCPU);
        GUILayout.Label(t);
        Texture2D t1 = AssetPreview.GetAssetPreview(((Tessendorf)target).H0NegativeKTexCPU);
        GUILayout.Label(t1);
        Texture2D t2 = AssetPreview.GetAssetPreview(((Tessendorf)target).TimedependentHTexCPU);
        GUILayout.Label(t2);

        GUILayout.Label("GPU Textures");
        Texture2D tex = AssetPreview.GetAssetPreview(((Tessendorf)target).H0KTex);
        GUILayout.Label(tex);
        Texture2D tex1 = AssetPreview.GetAssetPreview(((Tessendorf)target).H0NegativeKTex);
        GUILayout.Label(tex1);
        Texture2D tex2 = AssetPreview.GetAssetPreview(((Tessendorf)target).TimedependentHTex);
        GUILayout.Label(tex2);

        GUILayout.Label("Butterfly texture (GPU)");
        Texture2D butterfly = AssetPreview.GetAssetPreview(((Tessendorf)target).ButterflyTexture);
        GUILayout.Label(butterfly);

        GUILayout.Label("Ping pong textures (GPU)");
        Texture2D pong0 = AssetPreview.GetAssetPreview(((Tessendorf)target).Pong0Texture);
        GUILayout.Label(pong0);
        Texture2D pong1 = AssetPreview.GetAssetPreview(((Tessendorf)target).Pong1Texture);
        GUILayout.Label(pong1);

        GUILayout.Label("Displacement texture (GPU)");
        Texture2D displacement = AssetPreview.GetAssetPreview(((Tessendorf)target).DisplacementTexture);
        GUILayout.Label(displacement);


        GUILayout.Label("Gaussian noise texture");
        Texture2D noiseTex = AssetPreview.GetAssetPreview(((Tessendorf)target).NoiseTexture);
        GUILayout.Label(noiseTex);

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
