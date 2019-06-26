puts 'Cleaning database...'
ClientCompany.destroy_all
ClientContact.destroy_all
Comment.destroy_all
Content.destroy_all
Workshop.destroy_all
Intelligence.destroy_all
# IntelligenceContent.destroy_all
Training.destroy_all
TrainingOwnership.destroy_all
Session.destroy_all
SessionTrainer.destroy_all
Theory.destroy_all
TheoryContent.destroy_all
User.destroy_all

puts "Generating database..."

puts "Generating Intelligences..."

Intelligence.create(name: "Intelligence linguistique", description: "L'intelligence linguistique est définie par Gardner comme la « capacité à utiliser et à comprendre les mots et les nuances de sens ». Elle est appliquée en écriture, en édition et en traduction en particulier. Elle concerne l'entrée (input) des stimuli linguistiques (écouter ou lire), et la production (output) de langage (parler, écrire). L'intelligence linguistique est aussi la capacité à comprendre comment le langage affecte les émotions dans le cas des rhétoriciens, écrivains et poètes, par exemple.
L'intelligence linguistique consiste à utiliser le langage pour comprendre les autres et pour exprimer ce que l'on pense. Elle permet l'utilisation de la langue maternelle, mais aussi d'autres langues.
C'est l'intelligence la plus mise en avant et utilisée à l'école avec l'intelligence logico-mathématique.
On la retrouve chez les écrivains et les poètes, les traducteurs et les interprètes. Tous les individus qui manipulent le langage à l'écrit ou à l'oral utilisent l'intelligence linguistique : orateurs, avocats, poètes, écrivains, mais aussi les personnes qui ont à lire et à parler dans leur domaine respectif pour résoudre des problèmes, créer et comprendre.")
Intelligence.create(name: "Intelligence logico-mathématique", description: "L'intelligence logico-mathématique permet de résoudre des problèmes abstraits de nature logique ou mathématique. C'est la capacité de manipuler les nombres et de résoudre des problèmes logiques. Gardner souligne que « mathematics involves more than logic, such as the capacity to entertain long chains of logical relations expressed in symbolic form » (les mathématiques ne font pas appel seulement à la logique mais également à la capacité de manipuler de longues chaînes de relations logiques exprimées sous des formes symboliques).
Les personnes qui ont une intelligence logico-mathématique développée possèdent la capacité de calculer, de mesurer, de faire preuve de logique et de résoudre des problèmes mathématiques et scientifiques. Elles analysent les causes et les conséquences d'un phénomène ou d'une action. Elles peuvent catégoriser et ordonner les objets.
L'intelligence logico-mathématique est, selon Gardner, particulièrement utile dans les sciences, les affaires ou encore en médecine.")
Intelligence.create(name: "Intelligence spatiale", description: "L’intelligence spatiale est la « capacité de trouver son chemin dans un environnement donné et d'établir des relations entre les objets dans l'espace ». Elle permet de voir la continuité d'une image en rotation dans l'espace, de créer une image mentale. Par exemple, elle permet de bien arranger des objets dans un espace comme des valises dans un coffre de voiture, ou d'établir un plan de route pour aller d'un point à un autre, etc.
Elle est utilisée dans des domaines comme l'architecture, la menuiserie ou l'urbanisme. Elle est utile en mathématiques et dans le jeu d'échecs.")
Intelligence.create(name: "Intelligence intra-personnelle", description: "L'intelligence intra-personnelle permet de se former une représentation de soi précise et fidèle et de l'utiliser efficacement dans la vie. Elle sollicite plus le champ des représentations et des images que celui du langage. Il s'agit de la capacité à décrypter ses propres émotions, à rester ouvert à ses besoins et à ses désirs. C'est l'intelligence de l'introspection, de la psychologie analytique. Elle permet d'anticiper sur ses comportements en fonction de la bonne connaissance de soi. Il est possible, mais pas systématique, qu'une personne ayant une grande intelligence intrapersonnelle, soit qualifiée par son entourage de personne égocentrique.
L'intelligence intrapersonnelle est en rapport avec la sensibilité d'une personne à ses propres potentialités et ses limites, ses propres émotions. C'est la capacité de se comprendre soi-même. Le contrôle de soi en fait également partie.
L'intelligence intrapersonnelle est très sollicitée dans les métiers de conseil, de psychologie et psychiatrie.
")
Intelligence.create(name: "L'intelligence interpersonnelle", description: "L’intelligence interpersonnelle est la capacité de comprendre les autres, de communiquer avec eux1 et d'anticiper l'apparition d'un comportement.
Elle permet à l’individu d’agir et de réagir avec les autres de façon correcte et adaptée. Elle l’amène à constater les différences et nuances de tempérament, de caractère, de motifs d’action entre les personnes. Elle permet l’empathie, la coopération, la tolérance, la manipulation. Elle permet de détecter les intentions de quelqu’un sans qu’elles soient avouées. Cette intelligence permet de résoudre des problèmes liés à nos relations avec les autres ; elle nous permet de comprendre et de générer des solutions valables pour les aider.
Les personnalités charismatiques ont toutes une intelligence interpersonnelle très élevée. L'intelligence interpersonnelle culmine chez les personnes faisant preuve de beaucoup d'empathie, ce qui caractérise les bons enseignants, les bons thérapeutes et les bons leaders.
L'intelligence interpersonnelle est importante dans les professions de politicien, commerçant, enseignant, manager d'équipe et guide spirituel.")
Intelligence.create(name: "Intelligence corporelle-kinesthésique", description: "L’intelligence corporelle-kinesthésique est la capacité d’utiliser le contrôle fin des mouvements du corps dans les activités comme le sport et les danses. Elle permet aussi d'utiliser son corps pour exprimer une idée ou un sentiment ou réaliser une activité physique donnée. Gardner a clarifié dans certaines publications ultérieures à son livre que l'intelligence corporelle-kinesthésique est celle qui se développe à force d'intense pratique et d'expertise.
Elle est particulièrement utilisée par les professions de danseur, d'athlète, de chirurgien et d'artisan.")
Intelligence.create(name: "Intelligence musicale", description: "L’intelligence musicale constitue l’aptitude à percevoir et créer des rythmes et mélodies, de reconnaître des modèles musicaux, de les interpréter et d'en créer. Cette intelligence engage des processus actifs et passifs : jouer d'un instrument, chanter ou composer (actif) mais également apprécier la musique écoutée (passif).
Cette intelligence est développée et nécessaire chez les musiciens et compositeurs.")

puts "Generating Themes..."

Theme.create(name: 'Innovation')
Theme.create(name: 'Négociation')
Theme.create(name: 'Management')
Theme.create(name: 'Développement Personnel')
Theme.create(name: 'Communication')
Theme.create(name: 'Stratégie')

puts "Generating Contents..."

Content.create(title: 'Design Thinking', theme_id: 1, duration: 45, description: "« Quelle que soit la forme pour laquelle on opte il s’agit de penser avec les mains » — David Kelley (fondateur d’IDEO)
Le Design Thinking est une méthode innovante de conduite de projet et de management qui utilise, entre autres, la génération d’idées créatives et le prototypage comme moyens concrets de réalisation de produits et de services.
Développée dans les années 80 à l’Université de Stanford par Rolf Faste, designer américain, cette approche méthodologique offre une vision non pas linéaire de la marche à suivre pour créer un produit ou service, mais est plutôt basée sur un rythme de cycles itératifs, répétés autant de fois que nécessaire jusqu’à l’obtention du résultat optimal souhaité.

Ce qui différencie le Design Thinking d’autres outils d’aide à la créativité, c’est qu’il place l’humain au cœur du processus. Chaque étape est pensée de manière à ce que les besoins des utilisateurs soient clairement identifiés, à ce qu’ils participent largement à chacune d’entre elles et qu’ils bénéficient d’une réponse concrète, juste et adaptée à leur demande.

« Déjà essayé. Déjà échoué. Peu importe. Essaie encore. Échoue encore. Échoue mieux. » — Samuel Beckett")

Content.create(title: 'Les 6 chapeaux de la créativité', theme_id: 1, duration: 45, description: "Quelle est la plus formidable invention de l’humanité ?
Presque instantanément, nous serions tentés de répondre l’ordinateur ou bien internet.
Cependant, les meilleures inventions, depuis l’aube de l’humanité sont celles qui nous permettent de s’affranchir des contraintes imposées par notre corps.
L’échelle par exemple, pour aller d’un point A à un point d’altitude B. La roue et la charrette pour transporter des charges plus importantes plus loin et plus vite.

Prenons maintenant en considération le micro-ordinateur, qui a révolutionné notre quotidien. Sa puissance vient de l’association du software et du hardware, et séparer l’un de l’autre rendrait cet outil parfaitement inutile. De la même manière, c’est l’association de l’intelligence et de la capacité de réflexion qui compose la magie du cerveau humain. Le hardware comme la capacité de réflexion constituent un jeu de compétences pratiques tandis que le software et l’intelligence forment le potentiel.

Notre software est un héritage vieux de 4500 ans et constitue l’héritage d’Aristote, Platon et Socrate.

Edward de Bono avec son modèle des 6 chapeaux permet de mettre en place un outil de réflexion et de maïeutique efficace, un software très simple qui permet de catalyser la créativité et l’engagement d’une équipe.
LA MÉTHODE
Dans le cadre d’une réunion, la méthode consiste à passer par tous les modes de pensée à tour de rôle (ou de les reconnaître et les attribuer aux autres intervenants). On détermine en amont l’ordre d’utilisation des chapeaux selon la problématique à gérer (ex : tous les participants adoptent d’abord le chapeau jaune, puis blanc, puis rouge, etc.) ; et chaque participant doit endosser le mode de pensée lié au chapeau qui est déterminé par la séquence.

Ce système permet d’aboutir à un environnement de discussion cordial et créatif et permet de faciliter la contribution de chacun. Tous les intervenants sont alors sur une même longueur d’onde et les idées des uns provoquent les idées des autres.

La méthode des chapeaux canalise l’énergie créatrice de l’équipe, trop peu sollicitée. Il est alors possible de résoudre les problèmes plus vite et les idées neuves sont protégées de la critique immédiate ce qui permet de les développer d’une manière insoupçonnée. Cette méthode est de fait bien plus productive que l’argumentation critique habituelle.
LES DIFFÉRENTS CHAPEAUX
Chapeau blanc
La neutralité : lorsqu’il porte le chapeau blanc, le penseur énonce des faits purement et simplement. La personne alimente le groupe en chiffres et en informations. C’est l’image de la froideur, c‘est le goût de la simplicité : le minimalisme.

Chapeau rouge
La critique émotionnelle : avec le chapeau rouge, le penseur rapporte ses informations teintées d’émotions, de sentiments, d’intuitions et de pressentiments. Il n’a pas à se justifier auprès des autres chapeaux. C’est le feu, la passion, l’intuition.

Chapeau noir
La critique négative : lorsqu’il porte le chapeau noir, le penseur fait des objections en soulignant les dangers et risques qui attendent la concrétisation de l’idée. C’est l’avocat du diable ! C’est la prudence, le jugement négatif.

Chapeau jaune
La critique positive : lorsqu’il porte le chapeau jaune, le penseur admet ses rêves et ses idées les plus folles. Ses commentaires sont constructifs et tentent de mettre en action les idées suggérées par les autres membres du groupe. C’est le soleil et l’optimisme.

Chapeau vert
La créativité : lorsqu’il porte le chapeau vert, le penseur provoque, recherche des solutions de rechange. Il s’inspire de la pensée latérale, d’une façon différente de considérer un problème. Il sort des sentiers battus et propose des idées neuves. C’est la fertilité des plantes, la semence des idées.

Chapeau bleu
L’organisation : c’est le meneur de jeu, l’animateur de la réunion qui canalise les idées et les échanges entre les autres chapeaux. C’est le bleu du ciel qui englobe tout.")

Content.create(title: 'Conditionnements et conscience', theme_id: 2, duration: 30, description: "La plupart de nos actions se font inconsciemment et sont en réalité des réponses automatiques, stéréotypées et irréfléchies aux stimulations quotidiennes qui nous parviennent par nos sens.
Il est indispensable de nous appuyer dessus étant donné la masse d’information toujours plus importante que nous, humains, avons à gérer au fur et à mesures que nos civilisations avancent et que les technologies se développent

« Le niveau d’une civilisation est donné par la quantité de prestations que les gens réussissent à accomplir inconsciemment. » — Alfred North Whitehead
La grande majorité de nos réactions inconscientes proviennent des conditionnements que nous avons intégrés au cours de notre vie.
Stephen R. Covey s’est rendu mondialement célèbre avec son livre “les 7 habitudes de ceux qui réussissent tout ce qu’ils entreprennent” dans lequel il insiste sur l’idée que ce qui fait la différence entre une personne qui réussit et une personne qui a des difficultés tient essentiellement aux habitudes prises. En management, il est reconnu que ce sont les actions du quotidien, tout ce qu’un manager fait de façon habituelle et non-réfléchie qui fait la différence. Et ces habitudes s’acquièrent par l’expérience, via des “renforcements”, des répétitions. Dans ces conditions, plus une habitude a été renforcée, plus elle est difficile à modifier. En cela, l’obstacle à l’apprentissage est souvent une mauvaise habitude renforcée par des années de pratique et qui empêche l’assimilation d’une nouvelle habitude et pas la capacité à apprendre un nouveau comportement.")

Content.create(title: "Contrôler l'histoire", theme_id: 2, duration: 30, description: "Dans le très célèbre livre de George Orwell, 1984, le pouvoir totalitaire, collectiviste et autoritaire de Big Brother réécrit constamment l’Histoire. Même la plus récente: jusqu’aux chiffres de la production de chocolat de la semaine précédent.
Avoir la capacité d’orienter l’histoire dans une lumière favorable à son idéologie ou son pouvoir est critique dans les guerres d’influences. Et cela a été le cas continuellement dans l’Histoire de l’humanité.

On peut remonter jusqu’à Akhenaton, en Égypte ancienne: vers 1350 avant Jésus Christ qui a essayé de faire de l’Egypte un pays monothéiste. Il a tenté de retirer, mutiler ou détruire tous les noms (dans des cartouches), tous les symboles et toutes les statuts des autres dieux présents dans les temples. Heureusement, la plupart de ses tentatives d’effacer l’Histoire ont échouées et il reste possible de retrouver des traces de ce qui existait avant. Dans le cas d’Akhenaton, ces changements brutaux ont été si mal vécus qu’il a lui-même finalement été renversé et la majorité de ses propres statuts et cartouches ont été détruits, effacés ou retirés.

De la même façon, après la proclamation de la chrétienté comme religion officielle de l’Empire Romain par l’Empereur Constantin, les Chrétiens ont vandalisés, détruits ou marqués d’une croix au front un grand nombre de statuts ou symboles des dieux païens.")

Content.create(title: 'Burning Plateform', theme_id: 3, duration: 25, description: "Voici un petit exercice d’imagination :
Vous vivez et travaillez sur une plateforme pétrolière. Vous vous réveillez au beau milieu de la nuit, un soir d’été, après avoir entendu un bruit sourd. Vous sortez de votre chambre pour vous rendre compte qu’une explosion a eu lieu et que les flammes recouvrent toute la plateforme…
Vous analysez la situation autour de vous, vos sens sont exacerbés et votre capacité à prendre des décisions n’aura jamais été aussi rapide. Un couloir vous apparaît entre les flammes, vous le traversez à toute vitesse manquant de finir asphyxié par l’épaisse fumée noire qui a rapidement envahi les lieux. Vous vous trouvez à présent sur le rebord de la plateforme. Vous vous penchez en avant pour essayer de repérer une échappatoire mais tout ce que vous parvenez à discerner, ce sont les eaux sombres et froides de l’océan.

Alors que les flammes se rapprochaient dangereusement de lui dévorant tout sur leur passage, vous n’avez qu’une poignée de secondes pour réagir. Deux choix s’offrent à vous : vous pouvez rester sur la plateforme et vous abandonner aux flammes qui progressent vers vous. Ou alors, vous pouvez vous lancer dans un plongeon de 30 mètres dans les eaux glaciales. Vous vous tenez sur la « burning platform », et vous devez réaliser un choix.

La mort probable contre la mort inévitable
Cette histoire n’est pas une fiction. En juillet 1988, 166 employés et deux sauveteurs périssent suite à l’explosion d’une plate-forme pétrolière en Écosse. Parmi les 63 survivants figure Andy Mochan, qui a vécu la situation décrite plus haut.
Son choix a été de sauter à l’eau, et bien que notre connaissance rétrospective des événements nous permet de dire qu’il a réalisé le bon choix, ce n’est pas quelque chose d’évident a priori.
Dans des circonstances ordinaires, l’homme n’aurait jamais considéré plonger dans les eaux glaciales. Mais la situation était exceptionnelle — sa plateforme était en feu. Andy Mochan a survécu à la chute et à l’hypothermie. Après avoir été secouru, il note que la « burning platform » a enclenché un changement radical dans son comportement.

La nécessité du changement : l’inertie est votre ennemi
La plate-forme en feu sur laquelle se trouvait Andy Mochan l’a poussé à modifier son comportement et à avancer d’un pas audacieux et brave vers un futur incertain. Suite au témoignage de Mochan, Daryl Connor, consultant spécialisé dans le management de transformation, s’approprie la métaphore de la « burning platform » pour illustrer la nécessité de garantir l’engagement des dirigeants dans les projets de transformation. La « burning platform » décrit également la situation des entreprises qui font face à une compétition disruptive. Aussi, la nécessité de faire des propositions, implémenter, défaire, améliorer, reconstruire est l’essence même de la startup et participe de la notion de design thinking.

De la plate-forme en feu à l’ambition ardente
Si Daryl Connor a popularisé le concept de « burning-platform », celui-ci a néanmoins subit des déformations dans son interprétation et certains peuvent y voir un moyen de générer la peur et la panique. Qu’on ne se méprenne pas, la « burning-platform » est avant tout porteuse d’un message sur l’importance de l’engagement. Le point critique à atteindre pour une entreprise, une équipe ou même un manager, se situe dans le glissement opéré d’une « burning platform » vers une « burning ambition » : créer l’engagement d’un groupe plutôt que la peur et la panique, cela suppose de catalyser les externalités négatives et de les internaliser sous forme d’énergie créatrice et de passion ! Plus facile à dire qu’à faire, mais une personne avertie en vaut deux : vous êtes presque prêts à faire le plongeon !")

Content.create(title: 'Management Situationnel', theme_id: 3, duration: 30, description: "« Tout le monde est un génie. Mais si vous jugez un poisson à ses capacités à grimper aux arbres, il passera sa vie à croire qu’il est stupide. » — Albert Einstein.
Les meilleurs leaders sont ceux qui s’adaptent au niveau de maturité de l’individu ou du groupe qu’ils dirigent. Le style de management doit être adapté non seulement aux personnes/groupes, mais également à la tâche/fonction qui doit être réalisée.
Hersey & Blanchard ont développé vers la fin des années 70, un modèle de leadership situationnel basé sur deux axes : la relation et l’encadrement.

Ils ont identifié 4 styles de management :
Management directif
Pertinent pour un nouvel arrivant dans l’organisation, qui a besoin de recevoir des directives précises de la part de son manager.
Mode de communication adapté : l’email.

Management persuasif
Pertinent pour un collaborateur dont la motivation commence à s’essouffler, mais qui a toujours besoin d’un peu de cadrage dans la réalisation de ses missions.
Mode de communication adapté : l’entretien individuel.

Management participatif
Pertinent pour un collaborateur qui connaît son métier et fait preuve d’autonomie et d’agilité mais qui a besoin de conseils.
Mode de communication adapté : la réunion de suivi.

Management délégatif ou « laisser-faire »
Pertinent pour un collaborateur parfaitement compétent et autonome. Il gère voire crée ses propres missions et a besoin de considération.
Mode de communication adapté : l’email de suivi.")

Content.create(title: "Matrice d'Eisenhower", theme_id: 3, duration: 20, description: "« Ce qui est important est rarement urgent et ce qui est urgent rarement important » — Dwight D. Eisenhower
La matrice a été développée pour aider à donner un ordre de priorité aux tâches à réaliser et apprendre ainsi à travailler de façon plus efficace. Elle est basée sur deux paramètres : l’urgence et l’importance.
Utiliser cette classification permettra simplement d’identifier ce qui est important et/ou urgent, suivant la matrice ci-dessous :")

Content.create(title: 'Mastery', theme_id: 4, duration: 30, description: "N’importe qui peut devenir un génie dans un domaine.
N’importe qui peut devenir un génie.
N’importe qui peut.
N’importe qui.
A condition d’y passer 10 000 heures ?
Oui et non.. Dans la pratique, si l’on prend le chiffre des 10 000 heures, à raison de 5h quotidiennes consacrées à votre apprentissage, comptez 6 bonnes années pour devenir maître de votre sujet. Trop long pour vous ?

Robert Greene vous donne les éléments pour « hacker » la logique même d’apprentissage et atteindre l’excellence !
“Quand on veut vivre parmi les hommes, il faut laisser chacun exister et l’accepter avec l’individualité, quelle qu’elle soit, qui lui a été départie ; il faut se préoccuper uniquement de l’utiliser autant que sa qualité et son organisation le permettent, mais sans espérer la modifier et sans la condamner purement et simplement telle qu’elle est. Voilà la vraie signification de ce dicton: Vivre et laisser vivre.”
Comment ne pas se rendre malheureux pour rien — Schopenhauer

Mastery : Atteindre l’excellence, c’est avant tout l’éloge de la vocation. Dans son ouvrage, Robert Greene vous invite à revenir à l’essentiel : vos passions, celles qui vous animent depuis votre plus tendre enfance, avec un argument bien précis.
Nous distinguerons dans un premier temps deux catégories de personnes.

Ceux qui dans leur vingtaine ne sont pas nécessairement en quête d’une position de pouvoir, d’une assise financière et qui sont motivés par le désir d’expérimenter et d’apprendre chaque jour, sont les futurs grands leaders de notre monde.

A l’inverse, ceux qui se sont très tôt orientés dans l’UNIQUE but de sécuriser une carrière et où leur seule motivation découle du pouvoir et de l’argent finissent par être remplacés, à la fin de leur trentaine, par des gens plus intelligents, plus brillants, plus beaux, plus créatifs. Pourquoi ? Parce que ces personnes-là n’évoluent plus, se désengagent et perdent du terrain sur leur environnement en perpétuel mouvement !

Les personnes issues de la première catégorie voient s’opérer un renversement du monde en leur faveur à leur trentaine : plus épanouies, elles se retrouvent dans une position de pouvoir. Leur volonté d’apprendre les plongent dans un cycle de rendements accélérés — que l’on qualifierait en chimie de processus auto-catalytique — le succès entraîne le succès de manière cyclique, l’esprit s’accélère, la créativité est boostée, comme si elles avaient mis la main sur la pierre philosophale !

Mentor & Apprentissage
Pour Robert Greene, atteindre l’excellence suppose de passer par plusieurs phases la première étant celle de l’observation approfondie.
Il s’agit ici de se poser des questions sur la manière dont le système fonctionne et de ce qui fait la réussite des plus grands.
L’acquisition de savoir-faire, à savoir les 500, 1 000, 10 000 heures de travail nécessaires à la maîtrise d’un sujet. Cette étape nécessite, dans un souci de progression et de motivation, de trouver un mentor capable de vous assister dans votre progression et vous guider en déterminant les points critiques, dont la compréhension est cruciale pour atteindre l’expertise.")

Content.create(title: 'Analyse transactionnelle', theme_id: 4, duration: 30, description: "Le concept de base de l’analyse transactionnelle est celui des 3 états du moi, formés au cours de la petite enfance et qui constituent la structure de toute personnalité : ce sont le Parent, l’Adulte et l’Enfant.
On les représente généralement par 3 cercles superposés. Tous les 3 sont aussi importants l’un que l’autre. Ce qui se passe dans nos rapports interpersonnels et dans nos vies dépend en grande partie de l’état du moi à partir duquel nous agissons, dans telle ou telle situation.
L’état Enfant est celui d’où provient notamment la créativité, le jeu, l’intuition, les pulsions et les sentiments. S’il peut être spontané, intuitif et créateur, l’Enfant peut aussi être capricieux, rebelle ou soumis.

L’état Parent, pour sa part, est responsable, réconfortant et protecteur. Il représente le sens éthique et les normes, ce qui constitue la base du respect de soi et d’autrui. Il est « civilisé », mais peut être critique, dévalorisant et contraignant.

Quant à l’état Adulte, il sert de fonction équilibrante entre le Parent et l’Enfant, sachant quand lâcher du lest à l’un ou à l’autre. Il évalue, réfléchit et fonctionne de manière rationnelle en fonction de la situation du moment. L’état Adulte est un genre d’ordinateur : il n’est ni négatif ni positif.

L’AT est un outil puissant dans le cadre de négociations. En effet, il permet de mieux déterminer :
- Les besoins des parties adverses, définir une zone d’accord possible dans un contexte d’anti-sélection et d’asymétries d’informations.
EXEMPLE
Définir l’état de la partie adverse et adopter la même posture pour créer la confiance, ou bien prendre une position Adulte, équilibrée, face à un état négatif (Parent dévalorisant ou Enfant rebelle).

- Les leviers à actionner pour rétablir l’écoute et recentrer le dialogue dans le cadre de négociations longues.
EXEMPLE
Il convient d’adopter un langage Parent pour canaliser un partenaire de négociation dans un état Enfant spontané et créateur. En revanche, si ce dernier est dans un état Enfant capricieux/rebelle, il sera préférable d’adopter une posture Adulte, à l’équilibre entre le Parent et l’Enfant de manière à restaurer l’entente et l’écoute et à éviter tout jugement de valeur qui peut venir compromettre le dialogue.

- Son état propre, et ainsi mieux cerner ce qui ressort de son discours afin de mieux contrôler les informations que l’on va envoyer de manière explicite, ou implicite.
EXEMPLE
Si l’on a des prédispositions pour l’état Enfant, en prendre conscience permet de ne pas se laisser écraser dans une situation de négociation avec une partie adverse autoritaire.

")

Content.create(title: 'Prise de parole en public', theme_id: 5, duration: 45, description: "Monter sur scène pour prendre la parole en public est un exercice difficile qui demande de la préparation. Les conférences TED (Technology, Entertainment & Design) sont devenues des standards de prise de parole. Il s’agit d’un cycle de conférences crée à Monterey (Californie) en 1984 qui rassemble des esprits brillants dans leur domaine pour partager des idées avec le monde. C’est un événement annuel où les plus grands talents internationaux sont invités à partager leur passion.")

Content.create(title: "Les 5 types d'écoute", theme_id: 5, duration: 45, description: "« L’écoute est notre arme », devise du groupe de négociation du RAID.
La qualité première des négociateurs est l’écoute. Savoir déceler le type d’écoute chez son interlocuteur permet de s’assurer que le message que l’on envoie sera bien reçu. Le type d’écoute que vous utilisez en dit beaucoup sur vous.

Les 5 formes d’écoute les plus fréquentes sont :
1. Écoute impassible
Votre interlocuteur vous regarde fixement et ne laisse transparaître aucune émotion. Vous parlez à une statue. Il ne relance pas la conversation. Vous vous épuisez à maintenir le dialogue.

2. Écoute distraite
Votre interlocuteur fait autre chose. Il est sur son téléphone ou son ordinateur. Il ne vous regarde pas dans les yeux. Il acquiesce de manière automatique.

3. Écoute égocentrique
Votre interlocuteur ne parle que de lui. Vous avez du mal à placer une phrase. Chaque fois que vous prenez la parole est une occasion pour votre interlocuteur de continuer à parler de lui.

4. Écoute agressive
Votre interlocuteur enchaîne les questions comme dans un interrogatoire, vous interrompt, vous met mal-à-l’aise, et adopte une attitude supérieure et méprisante.

5. Écoute active
Votre interlocuteur montre de l’intérêt à ce que vous dites. Il n’hésite pas à reformuler vos propos ou à vous poser des questions.

Et vous, quel type d’écoute utilisez-vous spontanément ?
Vos interlocuteurs ont-ils la même réponse que vous ?
Comment réagir face à ces types d’écoute ?

Le groupe négociation du RAID a choisi comme devise : « L’écoute est notre arme ». L’emblème du Groupe est une représentation d’un vase grec antique présentant Œdipe assis face au Sphinx.")

Content.create(title: "Les 6 lois de la persuasion", theme_id: 1, duration: 30, description: "De 0 à 6 ans, nous découvrons le monde qui nous entoure et nous apprenons à y vivre. Notre cerveau crée des raccourcis pour que nous puissions continuer à apprendre.
EXEMPLE
Plus besoin de se demander ce qu’il se passe quand on appuie sur un interrupteur: notre cerveau a créé un raccourci entre l’interrupteur et le fait que la lumière s’allume si on appuie dessus.

Ces raccourcis sont nécessaires évidemment. Ils sont universels, cependant ils nous fragilisent face à des manipulateurs, des publicitaires ou autres qui les utilisent pour prédire, influencer nos comportements.

Robert Cialdini, psychologue social américain a établi 6 principes fondateurs de la psychologie sociale qui sous-tendent l’influence et la manipulation.
Loi de la réciprocité
On doit rendre d’une manière ou d’une autre ce qui nous a été donné. Sentiment induit : Obligation. Technique : offrir quelque chose avant de demander une faveur en retour.

Loi sur l’engagement
Chacun désire être considéré comme cohérent dans ses paroles, attitudes et actes​. Sentiment induit : Cohérence. Technique : obtenir l’engagement de l’autre pour lui demander une faveur.

Loi de conformité sociale
Nous tendons à suivre le plus grand nombre et à nous conformer au groupe. Expérience de Asch.

Loi sur l’automatisme
Une personne que nous apprécions aura plus d’influence sur nous et nous préférons dire oui à quelqu’un que nous aimons bien. Technique : la réunion Tupperware.

Loi sur l’autorité
Nous nous soumettons naturellement à l’autorité à partir du moment où nous la reconnaissons légitime. Technique : Expérience de Milgram.

Loi sur la rareté
Plus une chose semble rare plus nous désirons la posséder. Technique : Il n’y en aura pas pour tout le monde.")

Content.create(
 title: 'Golden Circles',
 theme_id: 6,
 duration: 30,
 description: "Chaque personne, chaque organisation cherche à motiver les gens à agir pour une raison ou pour une autre.
Cela peut être pour pousser à une décision d’achat, pour rechercher du soutien ou des votes, ou encore pour voir leurs collaborateurs travailler plus dur, plus intelligemment, ou simplement leur faire suivre des règles.

La capacité à motiver les gens n’est pas complexe en elle-même. Elle est généralement liée à des facteurs externes comme une récompense alléchante ou la menace d’une sanction.
Bien qu’ils soient relativement peu nombreux, les leaders et organisations dotés d’une habileté naturelle à inspirer les gens autour d’eux sont d’apparences et de milieux très divers : du secteur public au privé, dans toutes les formes d’industries, en B2C comme en B2B.

Peu importe où ils opèrent, le fait est qu’ils disposent d’une influence disproportionnée sur leur environnement. Plus innovants, ils sont surtout capables de maintenir leur leadership sur le long terme, c’est pourquoi nombre d’entre eux marquent leur milieu de leur empreinte et c’est pourquoi certains marquent même le monde.

")

Content.create(
 title: "Loi de Diffusion de l'innovation",
 theme_id: 6,
 duration: 30,
 description: "Les nouvelles idées, innovations ou produits sont initialement perçus par les gens comme incertains, risqués ou encore inutiles.
Pensez à des exemples comme les téléphones portables, les voitures électriques, les nouvelles marques de vêtements ou Internet. Il a fallu des mois ou des années pour que tous ces produits soient largement utilisés par le plus grand nombre. Pour être durables, ces innovations doivent être adoptées à un moment donné par le grand public. Pour y arriver, vous devez franchir le pas.

Nous réagissons tous différemment en matière d’innovation.
Les gens et les organisations du marché grand public sont plus prudents avec un profil d’aversion au risque plus élevé. Et d’autres sont plus réceptifs aux innovations et s’adaptent rapidement. En tant qu’innovateur et marketeur, vous devez comprendre les profils et adapter votre stratégie de communication. Ensuite, vous traverserez le fossé entre les fast adopters et les slow adopters et rejoindrez le marché grand public.

Il existe cinq catégories d’adoptants : innovators, early adopters, early majority, late majority, laggards. Chaque catégorie est définie par « l’innovation » des adoptants.")

puts "Generating Users..."

User.create(name: "Yahya", email: "yahya.fallah@byseven.co", password: "tititoto", access_level: "super admin", linkedin: "https://www.linkedin.com/in/yahya-fallah/?originalSubdomain=fr", picture: "https://avatars1.githubusercontent.com/u/45921830?s=460&v=4", description: "Co-founder")
User.create(name: "Brice", email: "brice.chapuis@byseven.co", password: "tititoto", access_level: "super admin", linkedin: "https://www.linkedin.com/in/brice-chapuis-b8744b181/?originalSubdomain=fr", picture: "https://avatars1.githubusercontent.com/u/45003333?s=460&v=4", description: "CTO")
User.create(name: "Training Manager", email: "user@2080.co", password: "tititoto", access_level: "training_manager", linkedin: "", picture: "https://i.pinimg.com/originals/d1/58/cc/d158ccef5dc0cadde05bdd0b7521a34d.jpg", description: "Training Manager")
User.create(name: "Sevener", email: "sevener@2080.co", password: "tititoto", access_level: "sevener", linkedin: "", picture: "https://bloody-disgusting.com/wp-content/uploads/2017/05/Screen-Shot-2017-05-01-at-11.17.09-AM.jpg", description: "Sevener Lambda")


puts "Generating Client Companies..."
ClientCompany.create(
 name: "Deliveroo",
 address: "14 rue de la livraison, 75001 Paris",
 logo: "https://i0.wp.com/www.grapheine.com/wp-content/uploads/2016/09/new-logo-deliveroo.gif?fit=1950%2C1200&quality=90&strip=all&ssl=1")
ClientCompany.create(
 name: "IBM",
 address: "224 rue des Américains, 75016 Paris",
 logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/IBM_logo.svg/1200px-IBM_logo.svg.png")
ClientCompany.create(
 name: "Le Wagon",
 address: "16 Villa Gaudelet, 75011 Paris",
 logo: "https://uikit.lewagon.com/assets/logo-0c157df32d93155001ae8d8b1b7740b3082e698b4ad0cc91792e8725deb68d85.png")
ClientCompany.create(
 name: "NASA",
 address: "300 E. Street SW, Suite 5R30, Washington, DC 20546",
 logo: "https://www.nasa.gov/sites/all/themes/custom/nasatwo/images/nasa-logo.svg")
ClientCompany.create(
 name: "McDonald's France",
 address: "1 rue Gustave Eiffel, 78045 Guyancourt Cedex",
 logo: "https://www.mcdonalds.fr/mcdo-mcdofr-front-theme/image/img-logo-head.gif")
ClientCompany.create(
 name: "Twitter France",
 address: "10 rue de la Paix, 75002 Paris",
 logo: "http://www.twitterpourlesnuls.com/img/Twitterl.png")
ClientCompany.create(
 name: "Tesla",
 address: "3 boulevard Malesherbes, 75008 Paris",
 logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Tesla_T_symbol.svg/771px-Tesla_T_symbol.svg.png")
ClientCompany.create(
 name: "PSG",
 address: "24 Rue du Commandant Guilbaud, 75016 Paris",
 logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/8/86/Paris_Saint-Germain_Logo.svg/1024px-Paris_Saint-Germain_Logo.svg.png")
ClientCompany.create(
 name: "Coca-Cola",
 address: "9 Chemin de Bretagne, 92130 Issy-les-Moulineaux",
 logo: "https://www.multigp.com/wp-content/uploads/2018/08/Coca-Cola-Logo.png")
ClientCompany.create(
 name: "Goldman Sachs",
 address: "5 Avenue Kléber, 75016 Paris",
 logo: "https://www.nasuni.com/wp-content/uploads/2017/04/goldman-sachs.png")
ClientCompany.create(
 name: "Société Générale",
 address: "29 Boulevard Haussmann, 75009 Paris",
 logo: "http://www.happyhourescapegame.com/wp-content/uploads/2014/10/soci%C3%A9t%C3%A9-gal.png")
ClientCompany.create(
 name: "M6 Groupe",
 address: "89 Avenue Charles-de-gaulle, 92200 Neuilly-sur-seine",
 logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/2/22/M6_2009.svg/1200px-M6_2009.svg.png")

puts "Done!"
