# Unity-VertexTextureFetchAnimation
This is a sample to run the vertex texture animation in Unity.  
Unity内で頂点テクスチャアニメーションを実行するサンプルです。
  
![Sample](https://github.com/apras/Unity-VertexTextureFetchAnimation/blob/master/Sample_VTF.gif)  
<https://pbs.twimg.com/tweet_video/CFg0QDWVIAI93-Y.mp4>
  
# Description
- It will work with DX11.
- DX11環境で動作します。
- The vertex animation texture, use a floating point texture such as OpenEXR.
- 頂点アニメーションテクスチャには、OpenEXR等の浮動小数点テクスチャを使用します。
  
#### Assets/Scenes/Sample.unity
- Sample scene
- サンプルシーン
  
#### Assets/Scripts/VTFAnimation.cs
- Vertex texture animation script
- 頂点テクスチャアニメーションスクリプト
  
#### Assets/Model/VTF.ms
- From "3ds Max" is maxscript that outputs the vertex animation texture.
- "3ds Max"から頂点アニメーションテクスチャを出力するmaxscriptです。
  
# Issues
- "Vertex/Fragment shader" to use can not be used and does not refer to the SV_VertexID.
- 頂点/フラグメントシェーダーを使用しSV_VertexIDを参照しないと使用できません。
- "Surface Shaders" you can not use the shader written in.
- サーフェースシェーダーで記述されたシェーダが使用できません。
- Existing shader can not be used.
- 既存のシェーダーが使用できません。
