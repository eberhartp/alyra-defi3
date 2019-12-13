# alyra-defi3

Crypto Poems, un jeu de cryptoactifs basé sur les "Cent mille milliards de poèmes" de Raymond Queneau, publié en 1961

## Comment démarrer

Procédure à suivre pour installer une copie du jeu sur votre machine et lancer les tests.

### Prérequis

Vous devez disposer des applications suivantes sur votre machine:  
Node v10.13.3  
Git v2.17.1  
Truffle v5.1.2  
Ganache CLI v6.7.0  

Une fois Node installé, vous pourrez obtenir Git et Truffle en tapant les commandes suivantes dans uen console:
```
npm install git
npm install truffle
npm install ganache-cli
```

### Installation

Dans un nouveau dossier, faites un clone du repository git sur votre machine:

```
git clone https://github.com/eberhartp/alyra-defi3.git
```

## Executer les tests

Les tests se lancent en deux étapes:
1. Lancer une blockchain ethereum locale à l'aide de Ganache CLI en spécifiant le port et le réseau comme ci-dessous:

```
ganache-cli p-7545 -i 5777
```

2. Excuter la commande "truffle test" dans le répertoire test du dossier cloné.

```
truffle test
```

### Détails des tests

L'application se compose de deux smarts contracts developpés en Solidity, Poemes.sol et AchatVente.sol .
Toutes les fonctionnalités des deux smarts contracts sont testées.

Les fonctions disponibles dans le contrat Poemes.sol sont celles issues d'un ERC721 classique (totalSuply(), balanceOf(), approve(), etc.).
Une fonction permet d'afficher un poeme dans la console.

Les fonctions disponibles dans le contrat AchatVente.sol permettent de mettre en vente et d'acheter un poeme.	


## Deploiement

Les contrats ne sont pas déployés sur le mainnet.


## Versions

Crypto Poems de test non publié au 16/12/2019, v1.0.0 à venir.
L'ensemble du code est disponible ici: https://github.com/eberhartp/alyra-defi3

## Authors

* **Pacôme Eberhart** - https://github.com/eberhartp/

* **Raphael Pinto** - https://github.com/raphaelpg/

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
