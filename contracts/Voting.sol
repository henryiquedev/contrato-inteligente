// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // Estrutura para representar um candidato
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // Mapeamento para armazenar os candidatos registrados
    mapping(uint256 => Candidate) public candidates;

    // Mapeamento para armazenar se uma carteira já votou
    mapping(address => bool) public hasVoted;

    // Variável para armazenar o número total de candidatos
    uint256 public candidatesCount;

    // Endereço do administrador do contrato
    address public admin;

    // Evento para registrar o voto de um eleitor
    event Voted(uint256 indexed candidateId);

    // Evento para registrar o registro de um novo candidato
    event CandidateRegistered(uint256 indexed candidateId, string name);

    // Evento para registrar o log de auditoria
    event AuditLog(uint256 indexed actionId, string action);

    // Variável para armazenar o registro de auditoria
    mapping(uint256 => string) public auditLog;
    uint256 public auditLogCount;

    // Modificador para verificar se o endereço do remetente é o administrador
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Construtor que define o administrador do contrato
    constructor() {
        admin = msg.sender;
    }

    // Função para registrar um novo candidato
    function addCandidate(string memory _name) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateRegistered(candidatesCount, _name);
    }

    // Função para os eleitores votarem em um candidato
    function vote(uint256 _candidateId) public {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        require(!hasVoted[msg.sender], "You have already voted");

        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;

        emit Voted(_candidateId);
    }

    // Função para contar os votos e declarar o vencedor
    function getWinner() public view returns (string memory) {
        uint256 winningVoteCount = 0;
        uint256 winningCandidateId;

        for (uint256 i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return candidates[winningCandidateId].name;
    }


    // Função para permitir a auditabilidade do contrato
    // Ou seja, função para retornar o log de auditoria com base no ID da ação
function getAuditLog(uint256 _actionId) public view returns (string memory) {
    require(_actionId > 0 && _actionId <= auditLogCount, "Invalid action ID");
    return auditLog[_actionId];
}

}

