puts 'Cleaning database...'
ClientCompany.destroy_all
ClientContact.destroy_all
Comment.destroy_all
Content.destroy_all
ContentModule.destroy_all
Intelligence.destroy_all
IntelligenceContent.destroy_all
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

puts "Generating Users..."

User.create(name: "Yahya", email: "yahya@2080.co", password: "tititoto", access_level: "admin", linkedin: "https://www.linkedin.com/in/yahya-fallah/?originalSubdomain=fr", picture: "https://avatars1.githubusercontent.com/u/45921830?s=460&v=4", description: "Co-founder")
User.create(name: "Brice", email: "brice@2080.co", password: "tititoto", access_level: "admin", linkedin: "https://www.linkedin.com/in/brice-chapuis-b8744b181/?originalSubdomain=fr", picture: "https://avatars1.githubusercontent.com/u/45003333?s=460&v=4", description: "CTO")
User.create(name: "Project Manager", email: "user@2080.co", password: "tititoto", access_level: "project_manager", linkedin: "", picture: "https://i.pinimg.com/originals/d1/58/cc/d158ccef5dc0cadde05bdd0b7521a34d.jpg", description: "Project Manager")
User.create(name: "Sevener", email: "sevener@2080.co", password: "tititoto", access_level: "sevener", linkedin: "", picture: "https://bloody-disgusting.com/wp-content/uploads/2017/05/Screen-Shot-2017-05-01-at-11.17.09-AM.jpg", description: "Sevener Lambda")

puts "Done!"
