using UnityEngine;
using UnityEditor;
 
namespace AdultLink
{
public class SphereDissolveEditor_cutout : ShaderGUI
{
	MaterialEditor _materialEditor;
	MaterialProperty[] _properties;

	//MAIN SETTINGS
	private MaterialProperty _Position = null;
	private MaterialProperty _Radius = null;
	private MaterialProperty _Invert = null;

	//BORDER SETTINGS
	private MaterialProperty _Bordercolor = null;
	private MaterialProperty _Borderradius = null;
	private MaterialProperty _Bordernoisescale = null;
	private MaterialProperty _Noisespeed = null;

	//TEXTURE SETTINGS

	private MaterialProperty _Albedo = null;
	private MaterialProperty _Albedo_tint = null;
	private MaterialProperty _Normal = null;
	private MaterialProperty _Emission = null;
	private MaterialProperty _Emission_tint = null;
	private MaterialProperty _Metallic = null;
	private MaterialProperty _Metallic_multiplier = null;
	private MaterialProperty _Smoothness = null;
	private MaterialProperty _Tiling = null;
	private MaterialProperty _Offset = null;


	protected static bool ShowMainSettings = true;
	protected static bool ShowBorderSettings = true;
	protected static bool ShowTextureSettings = true;
 	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
		_properties = properties;
		_materialEditor = materialEditor;
		EditorGUI.BeginChangeCheck();
		DrawGUI();
	}

	void GetProperties() {

		//MAIN SETTINGS
		_Radius = FindProperty("_Radius", _properties);
		_Position = FindProperty("_Position", _properties);
		_Invert = FindProperty("_Invert", _properties);

		//BORDER SETTINGS
		_Bordercolor = FindProperty("_Bordercolor", _properties);
		_Borderradius = FindProperty("_Borderradius", _properties);
		_Bordernoisescale = FindProperty("_Bordernoisescale", _properties);
		_Noisespeed = FindProperty("_Noisespeed", _properties);

		//TEXTURE SETTINGS
		_Albedo = FindProperty("_Albedo", _properties);
		_Albedo_tint = FindProperty("_Albedo_tint", _properties);
		_Normal = FindProperty("_Normal", _properties);
		_Emission = FindProperty("_Emission", _properties);
		_Emission_tint = FindProperty("_Emission_tint", _properties);
		_Metallic = FindProperty("_Metallic", _properties);
		_Metallic_multiplier = FindProperty("_Metallic_multiplier", _properties);
		_Smoothness = FindProperty("_Smoothness", _properties);
		_Tiling = FindProperty("_Tiling", _properties);
		_Offset = FindProperty("_Offset", _properties);
	}

	static Texture2D bannerTexture = null;
    static GUIStyle title = null;
    static GUIStyle linkStyle = null;
    static string repoURL = "https://github.com/adultlink/spheredissolve";

	void DrawBanner()
    {
        if (bannerTexture == null)
            bannerTexture = Resources.Load<Texture2D>("SphereDissolveBanner");

        if (title == null)
        {
            title = new GUIStyle();
            title.fontSize = 20;
            title.alignment = TextAnchor.MiddleCenter;
            title.normal.textColor = new Color(1f, 1f, 1f);
        }
		

        if (linkStyle == null) linkStyle = new GUIStyle();

        if (bannerTexture != null)
        {
            GUILayout.Space(4);
            var rect = GUILayoutUtility.GetRect(0, int.MaxValue, 60, 60);
            EditorGUI.DrawPreviewTexture(rect, bannerTexture, null, ScaleMode.ScaleAndCrop);
            //
            EditorGUI.LabelField(rect, "SphereDissolve (cutout)", title);

            if (GUI.Button(rect, "", linkStyle)) {
                Application.OpenURL(repoURL);
            }
            GUILayout.Space(4);
        }
    }

	void DrawGUI() {
		GetProperties();
		DrawBanner();

		startFoldout();
		ShowMainSettings = EditorGUILayout.Foldout(ShowMainSettings, "General settings");
		if (ShowMainSettings){
			DrawMainSettings();
		}
		endFoldout();

		startFoldout();
		ShowBorderSettings = EditorGUILayout.Foldout(ShowBorderSettings, "Border");
		if (ShowBorderSettings){
			DrawBorderSettings();
		}
		endFoldout();

		startFoldout();
		ShowTextureSettings = EditorGUILayout.Foldout(ShowTextureSettings, "Textures");
		if (ShowTextureSettings){
			DrawTextureSettings();
		}
		endFoldout();
    }

	void DrawMainSettings() {
		//MAIN SETTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Position, _Position.displayName);
		_materialEditor.ShaderProperty(_Radius, _Radius.displayName);
		_materialEditor.ShaderProperty(_Invert, _Invert.displayName);
	}

	void DrawBorderSettings() {
		//BORDER SETTTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Bordercolor, "Color");
		_materialEditor.ShaderProperty(_Borderradius, "Radius");
		_materialEditor.ShaderProperty(_Bordernoisescale, "Noise scale");
		_materialEditor.ShaderProperty(_Noisespeed, "Noise speed");
	}
	
	

	void DrawTextureSettings() {
		//TEXTURE SETTINGS
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.TexturePropertySingleLine(new GUIContent("Albedo"), _Albedo);
		_materialEditor.ShaderProperty(_Albedo_tint, "Albedo tint color");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Normal"), _Normal);
		_materialEditor.TexturePropertySingleLine(new GUIContent("Emission"), _Emission);
		_materialEditor.ShaderProperty(_Emission_tint, "Emission tint color");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Metallic"), _Metallic);
		_materialEditor.ShaderProperty(_Metallic_multiplier, "Metallic");
		_materialEditor.ShaderProperty(_Smoothness, _Smoothness.displayName);
		_materialEditor.ShaderProperty(_Tiling, _Tiling.displayName);
		_materialEditor.ShaderProperty(_Offset, _Offset.displayName);
	}
	
	void startFoldout() {
		EditorGUILayout.BeginVertical(EditorStyles.helpBox);
		EditorGUI.indentLevel++;
	}

	void endFoldout() {
		EditorGUI.indentLevel--;
		EditorGUILayout.EndVertical();
	}

}
}