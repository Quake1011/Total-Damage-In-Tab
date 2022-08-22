#include <sourcemod>
#include <cstrike>

#define SaveScores // 0 everyhurt | 1 every round

int dmg[MAXPLAYERS+1];

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
}

public void RoundStart(Event hEvent, const char[] sEvent, bool bdb)
{
    for (int i = 1; i <= MaxClients; i++)
        if(IsClientInGame(i) && IsPlayerAlive(i)) CS_SetClientContributionScore(i, dmg[i]);
}

public void PlayerHurt(Event hEvent, const char[] sEvent, bool bdb)
{ 
    int attacker = GetClientOfUserId(hEvent.GetInt("attacker"));
    if(attacker && !IsFakeClient(attacker))
    {
        dmg[attacker] += hEvent.GetInt("dmg_health") + hEvent.GetInt("dmg_armor");
        if(SaveScores == 0) CS_SetClientContributionScore(attacker, dmg[attacker]);
    }
}

public void OnMapEnd()
{
    for(int i = 0; i <= MaxClients; i++)
        dmg[i] = 0;
}
