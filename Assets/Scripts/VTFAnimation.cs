using UnityEngine;
using System.Collections;

public class VTFAnimation : MonoBehaviour
{
	public Texture2D VTFAnimationTexture;
	public int AnimationCurrentFrame = 0;
	public int AnimationStartFrame = 0;
	public int AnimationEndFrame = 30;
	public float AnimationTextureFPS = 30.0f;
	private Shader m_VTFAnimationShader;
	//
	private ComputeBuffer m_debugTmep;
	private Material[] m_materials;

	void Start()
	{
		if(this.VTFAnimationTexture == null)
		{
			Debug.LogError("Not assaign VTFAnimationTexture.");
		}

		this.m_VTFAnimationShader = Shader.Find("Custom/VTFAnimation");
		if(this.m_VTFAnimationShader == null)
		{
			Debug.LogError("Not assaign VTFAnimation Shader.");
		}

		this.m_debugTmep = new ComputeBuffer(1, sizeof(float), ComputeBufferType.Default);
		float[] _r = new float[]{50.0f};
		this.m_debugTmep.SetData(_r);

		MeshFilter _meshFilter = this.GetComponent<MeshFilter>();
		int _vCount = _meshFilter.sharedMesh.vertexCount;

		MeshRenderer _meshRenderer = this.GetComponent<MeshRenderer>();
		if(_meshRenderer != null)
		{
			this.m_materials = new Material[_meshRenderer.sharedMaterials.Length];
			for (int _i = 0; _i < _meshRenderer.sharedMaterials.Length; ++_i)
			{
				Material _mat = new Material(this.m_VTFAnimationShader);
				_mat.SetTexture("_DeformTex", this.VTFAnimationTexture);
				_mat.SetInt("_DeformTexStride", this.VTFAnimationTexture.width);
				_mat.SetInt("_AnimationFrame", this.AnimationCurrentFrame);
				_mat.SetInt("_VertexCount", _vCount);
				_mat.SetBuffer("_Debug", this.m_debugTmep);
				this.m_materials[_i] = _mat;
			}

			_meshRenderer.sharedMaterials = this.m_materials;
		}

		this.StartCoroutine(this.updateTextureAnimationFrame());
	}

	private IEnumerator updateTextureAnimationFrame()
	{
		while(true)
		{
			yield return new WaitForSeconds(1.0f / this.AnimationTextureFPS);

			this.AnimationCurrentFrame += 1;
			if(this.AnimationCurrentFrame > this.AnimationEndFrame)
			{
				this.AnimationCurrentFrame = this.AnimationStartFrame;
			}
		
			foreach(Material _mat in this.m_materials)
			{
				_mat.SetInt("_AnimationFrame", this.AnimationCurrentFrame);
			}
		}
	}
	
	void Update()
	{

	}

	void OnRenderObject()
	{
		//float[] _r = new float[1];
		//this.m_debugTmep.GetData(_r);
		//Debug.Log(_r[0]);

	}

	void OnDisable()
	{
		this.release();
	}
	
	void OnDestroy()
	{
		this.release();
	}
	
	void OnApplicationQuit()
	{
		this.release();
	}

	void OnGUI()
	{
		if(this.VTFAnimationTexture != null)
		{
			//GUI.DrawTexture(new Rect(0, 0, this.VTFAnimationTexture.width, this.VTFAnimationTexture.height), this.VTFAnimationTexture, ScaleMode.ScaleToFit, true);
		}
	}

	private void release()
	{
		if(this.m_debugTmep != null)
		{
			this.m_debugTmep.Release();
			this.m_debugTmep = null;
		}
	}
}

