﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Private price As String ="0"
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="ExchangeRate"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows the exchange rate of CNY to USD .<br/>
	"$
	
	App.Author="romejiang"
	
	App.CoverIcon=176
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Base:</b>  Base currency code e.g. (cny ...).<br/><br/>
	<b>Symbol:</b>  Target currency code e.g. ( usd ...).<br />
	<b>IconID:</b>  Choose your desired IconID from AWTRIXER.<br />
	<b>Appkey:</b>  Appkey on nowapi .<br />
	<b>Sign:</b>  Sign on nowapi.<br />
	在这里申请免费接口： https://www.nowapi.com/api/finance.rate
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(176)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Base":"CNY","Symbol":"USD","Sign":"","Appkey":"","IconID":176)
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_iconRequest
	App.Icons=Array As Int(App.get("IconID"))
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("http://api.k780.com/?app=finance.rate&scur="&App.Get("Symbol")&"&tcur="&App.Get("Base")&"&appkey="&App.Get("Appkey")&"&sign="&App.Get("Sign"))
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim result As Map = root.Get("result")
					Dim pric As Double  = result.Get("rate")
					price=NumberFormat2(pric,1,4,0,False)
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(price,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(App.get("IconID")),8,8)
End Sub