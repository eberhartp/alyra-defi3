pragma solidity 0.5.12;

/// @title Contrat du jeu Crypto Poems
/// @author Pacôme Eberhart et Raphael Pinto
/// @notice Contrat de base du jeu
/// @dev Contrat basé sur l'ERC721 avec trois fonctions en plus pour les poemes
contract Poemes {
    struct Poeme {
        uint256 indice;
    }

    mapping(uint256 => address) public poemeVersProprietaire;
    mapping(uint256 => bool) private poemeExiste;
    mapping(address => uint256) public proprietaireNombrePoemes;
    mapping(address => uint256[]) public proprietairePoemesId;
    mapping(address => mapping(address => bool)) public transferApproval;
    mapping(uint256 => address) public tokenApproval;
    uint256 private nombreTotalPoemes;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice renvoi le nombre total de poemes
    /// @dev comme le ERC721
    /// @return nombre de poemes en uint256
    function totalSupply() external view returns(uint256) {
        return nombreTotalPoemes;
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice renvoi le nombre de poemes possédés par un joueur
    /// @dev comme le ERC721
    /// @param _proprietaire adresse du joueur
    /// @return nombre de poemes du joueur en uint256
    function balanceOf(address _proprietaire) external view returns(uint256) {
        return proprietaireNombrePoemes[_proprietaire];
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice indique qui est le propriétaire d'un poeme
    /// @dev comme le ERC721
    /// @param _indicePoeme identifiant du poeme
    /// @return adresse du joueur en possession du poeme
    function ownerOf(uint _indicePoeme) external view returns(address) {
        return poemeVersProprietaire[_indicePoeme];
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice transfert la propriété d'un poeme d'un jouer à un autre
    /// @dev comme le ERC721
    /// @param _from adresse du propriétaire, _to addresse du destinataire, _tokenId identifiant du poeme
    /// @return renvoi un événement Transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
        require(_from != address(0), 'Address from is null');
        require(_to != address(0), 'Address to is null');
        require(poemeExiste[_tokenId], 'Poem does not exist');
        require(poemeVersProprietaire[_tokenId] == _from, 'From address is not owner of poem');
        require(msg.sender == _from || transferApproval[_from][msg.sender] || tokenApproval[_tokenId] == msg.sender, 'Unapproved');
        tokenApproval[_tokenId] = address(0);
        proprietaireNombrePoemes[_from]--;
        proprietaireNombrePoemes[_to]++;
        poemeVersProprietaire[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice autorise une adresse à éffectuer un transfert de propriété d'un poeme
    /// @dev comme le ERC721
    /// @param _to adresse qui sera autorisée, _tokenId identifiant du poeme
    /// @return un évenement Approval
    function approve(address _to, uint256 _tokenId) external {
        require(_to != address(0), 'Address to is null');
        require(poemeExiste[_tokenId], 'Poem does not exist');
        require(poemeVersProprietaire[_tokenId] == msg.sender, 'Not owner of poem');
        tokenApproval[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice renvoi l'adresse autorisée à éffectuer un transfert de propriété d'un poeme
    /// @dev comme le ERC721
    /// @param _tokenId identifiant du poeme
    /// @return l'addresse autorisée
    function getApproved(uint256 _tokenId) external view returns(address) {
        require(poemeExiste[_tokenId], 'Poem does not exist');
        return tokenApproval[_tokenId];
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice définit l'autorisation d'une adresse à transférer la propriété de tous les poèmes d'un joueur
    /// @dev comme le ERC721
    /// @param operator adresse qui seras autorisée, approved booléen true ou false
    /// @return l'évenement ApprovalForAll
    function setApprovalForAll(address operator, bool approved) external {
        require(operator != address(0), 'Operator address is null');
        transferApproval[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice indique si une adresse est autorisée à transférer la propriété de tous les poemes d'un joueur
    /// @dev comme le ERC721
    /// @param owner adresse du propriétaire, operator adresse autorisée
    /// @return un booléen true ou false
    function isApprovedForAll(address owner, address operator) external view returns(bool){
        require(owner != address(0), 'Owner adress is null');
        require(operator != address(0), 'Operator adress is null');
        return transferApproval[owner][operator];
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice renvoi un nombre aléatoire
    /// @dev méthode simpliste
    /// @return un uint256
    function random() internal view returns(uint256) {
        return uint256(blockhash(block.number - 1));
        // return 0;
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice créer un nouveau poeme
    /// @dev génere un nouvel identifiant de poeme et vérifie qu'il n'existe pas déjà
    /// @return l'identifiant du nouveau poeme en uint256
    function generatePoem() external payable returns(uint256) {
        require(msg.value >= 0.1 ether, 'Not enough funds');
        // 0x3FFFFFFFFFF = 42 bits à 1
        // 42 bits = 14 vers * 3 bits / vers
        // 3 bits => 8 possibilités
        uint256 tokenId = random() & 0x3FFFFFFFFFF;
        require(poemeExiste[tokenId] == false, 'Poem already exists');
        nombreTotalPoemes++;
        proprietaireNombrePoemes[msg.sender]++;
        poemeExiste[tokenId] = true;
        poemeVersProprietaire[tokenId] = msg.sender;
        proprietairePoemesId[msg.sender].push(tokenId);
        return tokenId;
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice indique si un poeme existe déjà
    /// @dev renvoi la valeur contenu dans le mapping poemeExiste
    /// @param poemId identifiant du poeme testé
    /// @return un booléen true ou false
    function poemExists(uint256 poemId) external view returns(bool){
        return poemeExiste[poemId];
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice affiche dans la console les vers du poeme spécifié
    /// @dev pour les tests
    /// @param poemId identifiant du poeme, verseNumber nombre de vers du poeme
    /// @return un tableau contenant les 14 vers
    function getVerse(uint256 poemId, uint256 verseNumber) external pure returns(string memory) {
        string[14][10] memory verses = [
            ["Le roi de la pampa retourne sa chemise","pour la mettre à sécher aux cornes des taureaux","le cornédbîf  en boîte empeste la remise","et fermentent de même et les cuirs et les peaux","Je me souviens encor de cette heure exeuquise ","les gauchos dans la plaine agitaient leurs drapeaux","nous avions aussi froid que nus sur la banquise","lorsque pour nous distraire y plantions nos tréteaux","Du pôle à Rosario fait une belle trotte","aventures on eut qui s\'y pique s\'y frotte","lorsqu\' on boit du maté l\'on devient argentin","L\'Amérique du Sud séduit les équivoques ","exaltent l\'espagnol les oreilles baroques","si la cloche se tait et son terlintintin"],
            ["Le cheval Parthénon s\'énerve sur sa frise","depuis que le lord Elgin négligea ses naseaux","le Turc de ce temps-là pataugeait dans sa crise","il chantait tout de même oui mais il chantait faux","Le cheval Parthénon frissonnait sous la bise","du climat londonien où s\'ébattent les beaux","il grelottait le pauvre au bords de la Tamise","quand les grêlons fin mars mitraillent les bateaux","La Grèce de Platon à coup sûr  n\'est point sotte","on comptait les esprits acérés à la hotte","lorsque Socrate mort passait pour un lutin","Sa sculpture est illustre et dans le fond des coques ","on transporte et le marbre et débris et défroques","si l\'Europe le veut l\'Europe ou son destin "],
            ["Le vieux marin breton de tabac prit sa prise","pour du fin  fond du nez exciter les arceaux","sur l\'antique bahut il choisit sa cerise","il n\'avait droit qu\'à une et le jour des Rameaux","Souvenez-vous amis de ces îles de Frise","où venaient par milliers s\'échouer les harenceaux","nous regrettions un peu ce tas de marchandise","lorsqu\'on voyait au loin flamber les arbrisseaux","On sèche le poisson dorade ou molve lotte","on sale le requin on fume à l\'échalotte","lorsqu\'on revient au port en essuyant un grain","Enfin on vend le tout homards et salicoques","on s\'excuse il n\'y a ni baleines ni phoques","le mammifère est roi nous sommes son cousin"],
            ["C\'était à cinq o\'clock qu\'il sortait la marquise","pour consommer un thé puis des petits gâteaux","le chauffeur indigène attendait dans la brise","elle soufflait bien fort par dessus les côteaux","On était bien surpris par cette plaine grise","quand se carbonisait la fureur des châteaux","un audacieux baron empoche toute accise","lorsque vient le pompier avec ses grandes eaux","Du Gange au Malabar le lord anglais zozotte","comme à Chandernagor le manant sent la crotte","le colonel s\'èponge un blason dans la main","Ne fallait pas si loin agiter ses breloques","les Indes ont assez sans ça de pendeloques","l\'écu de vair ou d\'or ne dure qu\'un matin"],
            ["Du jeune avantageux la nymphe était éprise","snob un peu sur les bords des bords fondamentaux","une toge il portait qui n\'était pas de mise","des narcisses on cueille ou bien on est des veaux","Quand on prend des photos de cette tour de Pise","d\'où Galilée jadis jeta ses petits pots","d\'une étrusque inscription la pierre était incise","les Grecs et les Romains en vain cherchent leurs mots","L\'esprit souffle et resouffle au-dessus de la botte","le touriste à Florence ignoble charibotte","l\'autocar écrabouille un peu d\'esprit latin","Les rapports transalpins sont-ils biunivoques?","les banquiers d\'Avignon changent-ils les baïoques?","le Beaune et le Chianti sont-ils le même vin?"],
            ["Il se penche il voudrait attraper sa valise","que convoitait c\'est sûr une horde d\'escrocs","il se penche et alors à sa grande surprise","il ne trouve aussi sec qu\'un sac de vieux fayots","Il déplore il déplore une telle mainmise","qui se plaît à flouer de pauvres provinciaux ","aller à la grand  ville est bien une entreprise","elle effraie le Berry comme les Morvandiaux","Devant la boue urbaine on retrousse sa cotte","on gifle le marmot qui plonge sa menotte","lorsqu\'il voit la gadoue il cherche le purin","On regrette à la fin les agrestes bicoques","on mettait sans façon ses plus infectes loques","mais on n\'aurait pas vu le métropolitain"],
            ["Quand l\'un avecque  l\'autre aussitôt sympathise","se faire il pourrait bien que ce soit des jumeaux","la découverte alors voilà qui traumatise","on espère toujours être de vrais normaux","Et pourtant c\'était lui le frère de feintise","qui clochard devenant jetait ses oripeaux","un frère même bas est la part indécise","que les parents féconds offrent aux purs berceaux","Le généalogiste observe leur bouillotte","gratter le parchemin deviendra sa marotte","il voudra retrouver le germe adultérin","Frère je te comprends si parfois tu débloques","frère je t\'absoudrai si tu m\'emberlucoques","la gémellité vraie accuse son destin"],
            ["Lorsqu\'un jour exalté l\'aède prosaïse","pour déplaire au profane aussi bien qu\'aux idiots","la critique lucide aperçoit ce qu\'il vise","il donne à la tribu des cris aux sens nouveaux","L\'un et l\'autre a raison non la foule insoumise","le vulgaire s\'entête à vouloir des vers beaux","l\'un et l\'autre ont raison non la foule imprécise","à tous n\'est pas donné d\'aimer les chocs verbaux","Le poète inspiré n\'est point un polyglotte","une langue suffit pour emplir sa cagnotte","même s\'il prend son sel au celte c\'est son bien","Barde que tu me plais toujours tu soliloques","tu me stupéfies plus que tous les ventriloques","le métromane à force incarne le devin"],
            ["Le marbre pour l\'acide est une friandise","d\'aucuns par dessus tout prisent les escargots","sur la place un forain de feu se gargarise","qui sait si le requin boulotte les turbots","Du voisin le Papou suçotte l\'apophyse","que n\'a pas dévoré la horde des mulots?","le gourmet en salade avale la  cytise","l\'enfant pur aux yeux bleus aime les berlingots?","Le loup est amateur de coq et de cocotte","le chat fait un festin de têtes de linotte","le chemin vicinal se nourrit de crottin","On a bu du pinard à toutes les époques","grignoter des bretzels distrait bien des colloques","mais rien ne vaut grillé le morceau de boudin"],
            ["Lorsque tout est fini lorsque l\'on agonise","lorsque le marbrier astique nos tombeaux","des êtres indécis vous parlent sans franchise","et tout vient signifier la fin des haricots","On vous fait devenir une orde marchandise","on prépare la route aux pensers sépulcraux","de la mort on vous greffe une orde bâtardise","la mite a grignoté tissus os et rideaux","Le brave a beau crier ah cré nom saperlotte","le lâche peut arguer de sa mine pâlotte","les croque-morts sont là pour se mettre au turbin","Cela considérant ô lecteur tu suffoques","comptant tes abattis  lecteur tu te disloques","toute chose pourtant doit avoir une fin"]
        ];
        uint256 verseIndex = (poemId >> (3 * verseNumber)) & 0x7;
        return verses[verseIndex][verseNumber];
    }

    // string[10][14] private vers = [["Le roi de la pampa retourne sa chemise","pour la mettre à sécher aux cornes des taureaux","le cornédbîf  en boîte empeste la remise","et fermentent de même et les cuirs et les peaux","Je me souviens encor de cette heure exeuquise ","les gauchos dans la plaine agitaient leurs drapeaux","nous avions aussi froid que nus sur la banquise","lorsque pour nous distraire y plantions nos tréteaux","Du pôle à Rosario fait une belle trotte","aventures on eut qui s\'y pique s\'y frotte","lorsqu\' on boit du maté l\'on devient argentin","L\'Amérique du Sud séduit les équivoques ","exaltent l\'espagnol les oreilles baroques","si la cloche se tait et son terlintintin"],
    // ["Le cheval Parthénon s\'énerve sur sa frise","depuis que le lord Elgin négligea ses naseaux","le Turc de ce temps-là pataugeait dans sa crise","il chantait tout de même oui mais il chantait faux","Le cheval Parthénon frissonnait sous la bise","du climat londonien où s\'ébattent les beaux","il grelottait le pauvre au bords de la Tamise","quand les grêlons fin mars mitraillent les bateaux","La Grèce de Platon à coup sûr  n\'est point sotte","on comptait les esprits acérés à la hotte","lorsque Socrate mort passait pour un lutin","Sa sculpture est illustre et dans le fond des coques ","on transporte et le marbre et débris et défroques","si l\'Europe le veut l\'Europe ou son destin "],
    // ["Le vieux marin breton de tabac prit sa prise","pour du fin  fond du nez exciter les arceaux","sur l\'antique bahut il choisit sa cerise","il n\'avait droit qu\'à une et le jour des Rameaux","Souvenez-vous amis de ces îles de Frise","où venaient par milliers s\'échouer les harenceaux","nous regrettions un peu ce tas de marchandise","lorsqu\'on voyait au loin flamber les arbrisseaux","On sèche le poisson dorade ou molve lotte","on sale le requin on fume à l\'échalotte","lorsqu\'on revient au port en essuyant un grain","Enfin on vend le tout homards et salicoques","on s\'excuse il n\'y a ni baleines ni phoques","le mammifère est roi nous sommes son cousin"],
    // ["C\'était à cinq o\'clock qu\'il sortait la marquise","pour consommer un thé puis des petits gâteaux","le chauffeur indigène attendait dans la brise","elle soufflait bien fort par dessus les côteaux","On était bien surpris par cette plaine grise","quand se carbonisait la fureur des châteaux","un audacieux baron empoche toute accise","lorsque vient le pompier avec ses grandes eaux","Du Gange au Malabar le lord anglais zozotte","comme à Chandernagor le manant sent la crotte","le colonel s\'èponge un blason dans la main","Ne fallait pas si loin agiter ses breloques","les Indes ont assez sans ça de pendeloques","l\'écu de vair ou d\'or ne dure qu\'un matin"],
    // ["Du jeune avantageux la nymphe était éprise","snob un peu sur les bords des bords fondamentaux","une toge il portait qui n\'était pas de mise","des narcisses on cueille ou bien on est des veaux","Quand on prend des photos de cette tour de Pise","d\'où Galilée jadis jeta ses petits pots","d\'une étrusque inscription la pierre était incise","les Grecs et les Romains en vain cherchent leurs mots","L\'esprit souffle et resouffle au-dessus de la botte","le touriste à Florence ignoble charibotte","l\'autocar écrabouille un peu d\'esprit latin","Les rapports transalpins sont-ils biunivoques?","les banquiers d\'Avignon changent-ils les baïoques?","le Beaune et le Chianti sont-ils le même vin?"],
    // ["Il se penche il voudrait attraper sa valise","que convoitait c\'est sûr une horde d\'escrocs","il se penche et alors à sa grande surprise","il ne trouve aussi sec qu\'un sac de vieux fayots","Il déplore il déplore une telle mainmise","qui se plaît à flouer de pauvres provinciaux ","aller à la grand  ville est bien une entreprise","elle effraie le Berry comme les Morvandiaux","Devant la boue urbaine on retrousse sa cotte","on gifle le marmot qui plonge sa menotte","lorsqu\'il voit la gadoue il cherche le purin","On regrette à la fin les agrestes bicoques","on mettait sans façon ses plus infectes loques","mais on n\'aurait pas vu le métropolitain"],
    // ["Quand l\'un avecque  l\'autre aussitôt sympathise","se faire il pourrait bien que ce soit des jumeaux","la découverte alors voilà qui traumatise","on espère toujours être de vrais normaux","Et pourtant c\'était lui le frère de feintise","qui clochard devenant jetait ses oripeaux","un frère même bas est la part indécise","que les parents féconds offrent aux purs berceaux","Le généalogiste observe leur bouillotte","gratter le parchemin deviendra sa marotte","il voudra retrouver le germe adultérin","Frère je te comprends si parfois tu débloques","frère je t\'absoudrai si tu m\'emberlucoques","la gémellité vraie accuse son destin"],
    // ["Lorsqu\'un jour exalté l\'aède prosaïse","pour déplaire au profane aussi bien qu\'aux idiots","la critique lucide aperçoit ce qu\'il vise","il donne à la tribu des cris aux sens nouveaux","L\'un et l\'autre a raison non la foule insoumise","le vulgaire s\'entête à vouloir des vers beaux","l\'un et l\'autre ont raison non la foule imprécise","à tous n\'est pas donné d\'aimer les chocs verbaux","Le poète inspiré n\'est point un polyglotte","une langue suffit pour emplir sa cagnotte","même s\'il prend son sel au celte c\'est son bien","Barde que tu me plais toujours tu soliloques","tu me stupéfies plus que tous les ventriloques","le métromane à force incarne le devin"],
    // ["Le marbre pour l\'acide est une friandise","d\'aucuns par dessus tout prisent les escargots","sur la place un forain de feu se gargarise","qui sait si le requin boulotte les turbots","Du voisin le Papou suçotte l\'apophyse","que n\'a pas dévoré la horde des mulots?","le gourmet en salade avale la  cytise","l\'enfant pur aux yeux bleus aime les berlingots?","Le loup est amateur de coq et de cocotte","le chat fait un festin de têtes de linotte","le chemin vicinal se nourrit de crottin","On a bu du pinard à toutes les époques","grignoter des bretzels distrait bien des colloques","mais rien ne vaut grillé le morceau de boudin"],
    // ["Lorsque tout est fini lorsque l\'on agonise","lorsque le marbrier astique nos tombeaux","des êtres indécis vous parlent sans franchise","et tout vient signifier la fin des haricots","On vous fait devenir une orde marchandise","on prépare la route aux pensers sépulcraux","de la mort on vous greffe une orde bâtardise","la mite a grignoté tissus os et rideaux","Le brave a beau crier ah cré nom saperlotte","le lâche peut arguer de sa mine pâlotte","les croque-morts sont là pour se mettre au turbin","Cela considérant ô lecteur tu suffoques","comptant tes abattis  lecteur tu te disloques","toute chose pourtant doit avoir une fin"]];
}