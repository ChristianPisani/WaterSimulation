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

        Texture2D tex = AssetPreview.GetAssetPreview(((Tessendorf)target).H0KTex);
        GUILayout.Label(tex);
        Texture2D tex1 = AssetPreview.GetAssetPreview(((Tessendorf)target).H0NegativeKTex);
        GUILayout.Label(tex1);
        Texture2D tex2 = AssetPreview.GetAssetPreview(((Tessendorf)target).TimedependentHTex);
        GUILayout.Label(tex2);

        if (GUILayout.Button("Visalize noise"))
        {
            ((Tessendorf)target).VisualizeNoise();
        }
    }
}
