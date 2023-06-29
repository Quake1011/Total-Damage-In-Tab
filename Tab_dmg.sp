#include <cstrike>
#include <sdktools>

int dmg[MAXPLAYERS+1], tmpdmg[MAXPLAYERS+1];

public Plugin myinfo = 
{
	name = "Total Damage In Tab",
	author = "Quake1011",
	description = "Total damage instead tab scores",
	version = "1.3",
	url = "https://github.com/Quake1011/"
}

public void OnPluginStart()
{
	HookEvent("player_hurt", PlayerHurt, EventHookMode_Post);
	HookEvent("round_start", RoundStart, EventHookMode_Post);
	CreateTimer(1.0, TimerRepeat, TIMER_REPEAT);
}

public void OnMapStart()
{
	for(int i = 1; i <= MaxClients; i++)
		dmg[i] = 0;
}

public Action TimerRepeat(Handle hTimer)
{
	for(int i = 1; i <= MaxClients; i++)
		if(IsClientInGame(i)) 
			CS_SetClientContributionScore(i, dmg[i]);
			
	return Plugin_Continue;
}

public void RoundStart(Event hEvent, const char[] sEvent, bool bdb)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		dmg[i] += tmpdmg[i];
		tmpdmg[i] = 0;
		if(IsClientInGame(i)) 
			CS_SetClientContributionScore(i, dmg[i]);
	}
}

public void PlayerHurt(Event hEvent, const char[] sEvent, bool bdb)
{ 
	int attacker = GetClientOfUserId(hEvent.GetInt("attacker"));
	if(0 < attacker <= MaxClients && !IsFakeClient(attacker))
		if(!GameRules_GetProp("m_bWarmupPeriod")) 
			tmpdmg[attacker] += hEvent.GetInt("dmg_health");
}
