c
#include <sourcemod>
#include <cstrike>

int dmg[MAXPLAYERS+1] = {0,...};
int tmpdmg[MAXPLAYERS+1] = {0,...};

public Plugin myinfo = 
{
    name = "Total Damage In Tab",
    author = "Quake1011",
    description = "Total damage instead tab scores",
    version = "1.1",
    url = "https://github.com/Quake1011/"
}


public void OnPluginStart()
{
    HookEvent("player_hurt", PlayerHurt, EventHookMode_Post);
    HookEvent("round_start", RoundStart, EventHookMode_Post);
    CreateTimer(1.0, TimerRepeat, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
    AutoExecConfig(true, "tabdmg");
}

public void OnMapStart()
{
    for(int i = 0; i <= MaxClients; i++)
    {
        dmg[i] = 0;
    }
}

public Action TimerRepeat(Handle hTimer)
{
    for (int i = 1; i <= MaxClients; i++)
    {    
        if(IsClientInGame(i)) CS_SetClientContributionScore(i, dmg[i]);
    }
}

public void RoundStart(Event hEvent, const char[] sEvent, bool bdb)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        dmg[i] += tmpdmg[i];
        tmpdmg[i] = 0;
        if(IsClientInGame(i)) CS_SetClientContributionScore(i, dmg[i]);
    }
}

public void PlayerHurt(Event hEvent, const char[] sEvent, bool bdb)
{ 
    int attacker = GetClientOfUserId(hEvent.GetInt("attacker"));
    if(attacker && !IsFakeClient(attacker))
    {
        if(!GameRules_GetProp("m_bWarmupPeriod")) tmpdmg[attacker] += hEvent.GetInt("dmg_health") + hEvent.GetInt("dmg_armor");
    }
}
