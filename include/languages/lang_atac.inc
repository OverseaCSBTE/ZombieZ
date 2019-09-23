new check_lang_set[3]
new lang[33]


/* MESSAGE LANGUAGES */

new mg1a[3][] = {"TEAM ATTACK WARNING IMMUNE", "AVERTISSEMENT D'ATTAQUE D'EQUIPE IMMUNISE", "MANNSCHAFT-ANGRIFF WARNING IMMUN"}
new mg1b[3][] = {"Damage Inflicted", "Dommage Inflige", "Beschadigung Zugefugt"}
new mg2a[3][] = {"is slayed for attacking a teammate within", "est foudroye pour attaquer un compagnon d'equipe en dedans", "ist slayed fur ein teammate innen in Angriff nehmen"}
new mg2b[3][] = {"secs of a new round", "sec d'un nouveau rond", "sek eines neuen Umlaufes"}
new mg3[3][] = {"TEAM ATTACK WARNING", "AVERTISSEMENT D'ATTAQUE D'EQUIPE", "MANNSCHAFT-ANGRIFF WARNING"}
new mg4[3][] = {"has neutralized the time bomber", "a neutralise le bombardier de temps", "hat das timebomber neutralisiert"}
new mg5[3][] = {"Sorry, you can't punish admins", "Desole, vous ne pouvez pas punir des admins", "Traurig, konnen Sie nicht admins bestrafen"}
new mg6a[3][] = {"You have been banned for", "Vous avez ete interdits pour", "Sie sind fur verboten worden"}
new mg6b[3][] = {"mins for Team Kill Violations", "minutes pour des violations de mise a mort d'equipe", "Minuten fur Mannschaft-Totung-Verletzungen"}
new mg7a[3][] = {"TEAM KILL VIOLATION", "VIOLATION DE MISE À MORT D'EQUIPE", "MANNSCHAFT-TOTUNG-VERLETZUNG"}
new mg7b[3][] = {"for", "pour", "fur"}
new mg7c[3][] = {"Banning for", "Interdire pour", "Verbieten fur"}
new mg7d[3][] = {"mins", "minutes", "minuten"}
new mg8[3][] = {"You have been banned permanently for Team Kill Violations", "Vous avez ete interdits de maniere permanente pour des violations de mise a mort d'equipe", "Sie sind dauerhaft fur Mannschaft-Totung-Verletzungen verboten worden"}
new mg9[3][] = {"Banning permanently", "Interdire de maniere permanente", "Dauerhaft verbieten"}
new mg10[3][] = {"You have been kicked for Team Kill Violations", "Vous avez ete donnes un coup de pied pour des violations de mise a mort d'equipe", "Sie sind fur Mannschaft-Totung-Verletzungen getreten worden"}
new mg11[3][] = {"Kicking", "Coups de pied", "Treten"}
new mg12a[3][] = {"On", "Marche", "Auf"}
new mg12b[3][] = {"you will be banned for", "vous serez interdits pour", "Sie werden fur verboten"}
new mg13[3][] = {"you will be banned permanently", "vous serez interdits de maniere permanente", "Sie werden dauerhaft verboten"}
new mg14[3][] = {"you will be kicked", "vous serez donnes un coup de pied", "Sie werden getreten"}
new mg15[3][] = {"has been turned back into a human", "a ete tourne de nouveau dans un humain", "ist zuruck in einen Menschen gedreht worden"}
new mg16[3][] = {"has served his jail sentence", "a servi sa peine", "hat seinen Gefangnissatz gedient"}
new mg17[3][] = {"has forgiven", "a pardonne", "hat verziehen"} 
new mg18[3][] = {"is a ticking Time Bomb for", "est une bombe a retardement le coutil pour", "eine ist das Ticken Zeitbombe fur"} 
new mg19a[3][] = {"is being Slapped", "est gifle", "wird geschlagen"}
new mg19b[3][] = {"times for", "periodes pour", "zeiten fur"} 
new mg20[3][] = {"is blind for", "est aveugle pour", "ist fur blind"}
new mg21[3][] = {"is Slapped to 1 hp for", "est gifle a 1 hp pour", "wird zu 1 hp fur geschlagen"}
new mg22[3][] = {"is a human Rocket for", "est une fusee humaine pour", "ist eine menschliche Rakete fur"} 
new mg23[3][] = {"will die next round for", "mourra le prochain rond pour", "stirbt folgenden Umlauf fur"}
new mg24[3][] = {"is being Repeatedly Dropped for", "est a plusieurs reprises laisse tomber pour", "wird wiederholt fur gefallen"}
new mg25a[3][] = {"is in Jail for", "est en Prison pour", "ist im Gefangnis fur"}
new mg25b[3][] = {"secs for", "sec pour", "sek fur"}
new mg26[3][] = {"is set on Fire for", "est place sur le Feu pour", "wird auf Feuer fur eingestellt"}
new mg27[3][] = {"is turned into a Chicken for", "est transforme en Poulet pour", "wird zu ein Huhn fur gemacht"}
new mg28[3][] = {"is Buried for", "est enterre pour", "wird fur begraben"}
new mg29[3][] = {"is Glowing Pink for", "rougeoie rose pour", "gluht fur rosafarben"}
new mg30[3][] = {"will explode in", "eclatera dedans", "explodiert innen"}
new mg31a[3][] = {"OH! NO!", "L'OH! NON!", "OH-! NEIN!"}
new mg31b[3][] = {"has caught", "a attrape", "hat sich verfangen"}
new mg31c[3][] = {"on fire", "sur le Feu", "auf Feuer"}
new mg32a[3][] = {"Team Kills", "Mises a mort D'Equipe", "Mannschaft-Totungen"}
new mg32b[3][] = {"Team Attacks", "Attaques D'Equipe", "Mannschaft-Angriffe"}
new mg33[3][] = {"Live Status is now enabled", "Le statut de phase est maintenant permis", "Phasenstatus wird jetzt ermoglicht"}
new mg34[3][] = {"Live Status is now disabled (always off, use", "Le statut de phase est maintenant neutralise (toujours arret, utilisation", "Phasenstatus wird jetzt gesperrt (immer weg, Gebrauch"}


/* MENU LANGUAGES */

new bk[3][] = {"Back", "Revenir", "Ruckseite"}
new mo[3][] = {"More", "Plus", "Mehr"}
new mo1[3][] = {"Forgive him", "Pardonnez-le", "Verzeihen Sie ihm"} 
new mo2a[3][] = {"Slap him", "Giflez-le", "Schlagen Sie ihn"} 
new mo2b[3][] = {"times", "periodes", "zeiten"} 
new mo3a[3][] = {"Slap him to", "Giflez-l'a", "Schlagen Sie ihn zu"} 
new mo3b[3][] = {"health", "sante", "gesundheit"} 
new mo4[3][] = {"Slay him next round", "Massacrez-le prochain rond", "Slay ihn folgender Umlauf"} 
new mo5a[3][] = {"Put him in Jail for", "Mis lui dans la prison pour", "Gesetzt ihm in Gefangnis fur"} 
new mo5b[3][] = {"seconds", "secondes", "sekunden"} 
new mo6[3][] = {"Turn him into a Chicken", "Transformez-l'en poulet", "Machen Sie ihn zu ein Huhn"} 
new mo7[3][] = {"Bury him", "Enterrez-le", "Begraben Sie ihn"} 
new mo8[3][] = {"Make him Glow Pink", "Faites-lui le rose de lueur", "Bilden Sie ihn GluhenPink"}
new mo11[3][] = {"Make him a ticking Time Bomb", "Faites-lui une bombe a retardement de coutil", "Bilden Sie ihn eine tickende Zeitbombe"}
new mo12[3][] = {"Make him Blind", "Rendez-l'aveugle", "Bilden Sie ihn Blind"}
new mo13[3][] = {"Make him a Rocket", "Faites-lui une fusee", "Bilden Sie ihn eine Rakete"}
new mo14[3][] = {"Drop him Repeatedly", "Laissez- tomberl'a plusieurs reprises", "Lassen Sie ihn wiederholt fallen"}
new mo15[3][] = {"Set him on fire", "Placez-le sur le feu", "Stellen Sie ihn auf Feuer ein"}
new mo22a[3][] = {"Ban him for", "Interdisez-le pour", "Verbieten Sie ihn fur"}
new mo22b[3][] = {"minutes", "minutes", "minuten"}
new mo22c[3][] = {"Ban him permanently", "Interdisez-le de maniere permanente", "Verbieten Sie ihn dauerhaft"}
new mo22d[3][] = {"Kick him", "Donnez- un coup de piedle", "Treten Sie ihn"}
new cpf[3][] = {"Choose Punishment for", "Choisissez la punition pour", "Wahlen Sie Bestrafung fur"}