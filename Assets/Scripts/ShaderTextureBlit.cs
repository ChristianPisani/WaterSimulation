using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderTextureBlit : MonoBehaviour
{
    public RenderTexture tex;
    public ComputeShader shader;

    public void DispatchShader()
    {
        int kernelHandle = shader.FindKernel("CSMain");
        var output = new RenderTexture(256, 256, 1);
        output.enableRandomWrite = true;
        output.Create();

        shader.SetTexture(kernelHandle, "Result", output);
        shader.Dispatch(kernelHandle, 256 / 8, 256 / 8, 1);

        tex = output;
    }
}
