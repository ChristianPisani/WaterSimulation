using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class SpawnGrid : MonoBehaviour {
    public GameObject Tile;
    public int Width = 10;
    public int Length = 10;
    public float Spacing = 1;

    public void MakeGrid()
    {
        for (int x = 0; x < Width; x++)
        {
            for (int z = 0; z < Length; z++)
            {
                Tile.transform.position = transform.position + new Vector3(x * Spacing, 0, z * Spacing);
                Instantiate(Tile, transform);
            }
        }
    }

    public void ClearChildren()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.delayCall += () => {
            foreach (Transform child in transform)
            {
                DestroyImmediate(child.gameObject);
            }
        };
#endif
    }
}
