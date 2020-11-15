using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SpawnGrid))]
class SpawnGridEditor : Editor {
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        if (GUILayout.Button("Clear"))
        {
            ((SpawnGrid)target).ClearChildren();
        }

        if (GUILayout.Button("Make grid"))
        {
            ((SpawnGrid)target).MakeGrid();
        }
    }
}