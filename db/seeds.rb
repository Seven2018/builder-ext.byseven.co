puts 'Cleaning database...'
ClientCompany.destroy_all
ClientContact.destroy_all
Comment.destroy_all
Content.destroy_all
ContentModule.destroy_all
Intelligence.destroy_all
# IntelligenceContent.destroy_all
Project.destroy_all
ProjectOwnership.destroy_all
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

puts "Generating Users..."

User.create(name: "Yahya", email: "yahya@2080.co", password: "tititoto", access_level: "admin", linkedin: "https://www.linkedin.com/in/yahya-fallah/?originalSubdomain=fr", picture: "https://avatars1.githubusercontent.com/u/45921830?s=460&v=4", description: "Co-founder")
User.create(name: "Brice", email: "brice@2080.co", password: "tititoto", access_level: "admin", linkedin: "https://www.linkedin.com/in/brice-chapuis-b8744b181/?originalSubdomain=fr", picture: "https://avatars1.githubusercontent.com/u/45003333?s=460&v=4", description: "CTO")
User.create(name: "Project Manager", email: "user@2080.co", password: "tititoto", access_level: "project_manager", linkedin: "", picture: "https://i.pinimg.com/originals/d1/58/cc/d158ccef5dc0cadde05bdd0b7521a34d.jpg", description: "Project Manager")
User.create(name: "Sevener", email: "sevener@2080.co", password: "tititoto", access_level: "sevener", linkedin: "", picture: "https://bloody-disgusting.com/wp-content/uploads/2017/05/Screen-Shot-2017-05-01-at-11.17.09-AM.jpg", description: "Sevener Lambda")

puts "Done!"
