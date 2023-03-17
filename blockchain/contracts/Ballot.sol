// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

import "./Types.sol";


contract Ballot {
    Types.Candidate[] public candidates;
    mapping(uint256 => Types.Voter) voter;
    mapping(uint256 => Types.Candidate) candidate;
    mapping(uint256 => uint256) internal votesCount;

    address electionChief;
    uint256 private votingStartTime;
    uint256 private votingEndTime;

    constructor(uint256 startTime_, uint256 endTime_) {
        initializeCandidateDatabase_();
        initializeVoterDatabase_();
        votingStartTime = startTime_;
        votingEndTime = endTime_;
        electionChief = msg.sender;
    }

    function getCandidateList(uint256 voterAadharNumber)
        public
        view
        returns (Types.Candidate[] memory)
    {
        Types.Voter storage voter_ = voter[voterAadharNumber];
        uint256 _politicianOfMyConstituencyLength = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                voter_.stateCode == candidates[i].stateCode &&
                voter_.constituencyCode == candidates[i].constituencyCode
            ) _politicianOfMyConstituencyLength++;
        }
        Types.Candidate[] memory cc = new Types.Candidate[](
            _politicianOfMyConstituencyLength
        );

        uint256 _indx = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                voter_.stateCode == candidates[i].stateCode &&
                voter_.constituencyCode == candidates[i].constituencyCode
            ) {
                cc[_indx] = candidates[i];
                _indx++;
            }
        }
        return cc;
    }

    
    function isVoterEligible(uint256 voterAadharNumber)
        public
        view
        returns (bool voterEligible_)
    {
        Types.Voter storage voter_ = voter[voterAadharNumber];
        if (voter_.age >= 18 && voter_.isAlive) voterEligible_ = true;
    }

    
    function didCurrentVoterVoted(uint256 voterAadharNumber)
        public
        view
        returns (bool userVoted_, Types.Candidate memory candidate_)
    {
        userVoted_ = (voter[voterAadharNumber].votedTo != 0);
        if (userVoted_)
            candidate_ = candidate[voter[voterAadharNumber].votedTo];
    }

    
    function vote(
        uint256 nominationNumber,
        uint256 voterAadharNumber,
        uint256 currentTime_
    )
        public
        votingLinesAreOpen(currentTime_)
        isEligibleVote(voterAadharNumber, nominationNumber)
    {
        // updating the current voter values
        voter[voterAadharNumber].votedTo = nominationNumber;

        // updates the votes the politician
        uint256 voteCount_ = votesCount[nominationNumber];
        votesCount[nominationNumber] = voteCount_ + 1;
    }

  
    function getVotingEndTime() public view returns (uint256 endTime_) {
        endTime_ = votingEndTime;
    }

    
    function updateVotingStartTime(uint256 startTime_, uint256 currentTime_)
        public
        isElectionChief
    {
        require(votingStartTime > currentTime_);
        votingStartTime = startTime_;
    }

    function extendVotingTime(uint256 endTime_, uint256 currentTime_)
        public
        isElectionChief
    {
        require(votingStartTime < currentTime_);
        require(votingEndTime > currentTime_);
        votingEndTime = endTime_;
    }

    function getResults(uint256 currentTime_)
        public
        view
        returns (Types.Results[] memory)
    {
        require(votingEndTime < currentTime_);
        Types.Results[] memory resultsList_ = new Types.Results[](
            candidates.length
        );
        for (uint256 i = 0; i < candidates.length; i++) {
            resultsList_[i] = Types.Results({
                name: candidates[i].name,
                partyShortcut: candidates[i].partyShortcut,
                partyFlag: candidates[i].partyFlag,
                nominationNumber: candidates[i].nominationNumber,
                stateCode: candidates[i].stateCode,
                constituencyCode: candidates[i].constituencyCode,
                voteCount: votesCount[candidates[i].nominationNumber]
            });
        }
        return resultsList_;
    }

    modifier votingLinesAreOpen(uint256 currentTime_) {
        require(currentTime_ >= votingStartTime);
        require(currentTime_ <= votingEndTime);
        _;
    }

    modifier isEligibleVote(uint256 voterAadhar_, uint256 nominationNumber_) {
        Types.Voter memory voter_ = voter[voterAadhar_];
        Types.Candidate memory politician_ = candidate[nominationNumber_];
        require(voter_.age >= 18);
        require(voter_.isAlive);
        require(voter_.votedTo == 0);
        require(
            (politician_.stateCode == voter_.stateCode &&
                politician_.constituencyCode == voter_.constituencyCode)
        );
        _;
    }

    modifier isElectionChief() {
        require(msg.sender == electionChief);
        _;
    }

    function initializeCandidateDatabase_() internal {
        Types.Candidate[] memory candidates_ = new Types.Candidate[](14);

        // Andhra Pradesh
        candidates_[0] = Types.Candidate({
            name: "Chandra Babu Naidu",
            partyShortcut: "TDP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/tdp_qh1rkj.png",
            nominationNumber: uint256(727477314982),
            stateCode: uint8(10),
            constituencyCode: uint8(1)
        });
        candidates_[1] = Types.Candidate({
            name: "Jagan Mohan Reddy",
            partyShortcut: "YSRCP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/ysrcp_sas311.png",
            nominationNumber: uint256(835343722350),
            stateCode: uint8(10),
            constituencyCode: uint8(1)
        });
        candidates_[2] = Types.Candidate({
            name: "G V Anjaneyulu",
            partyShortcut: "TDP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/tdp_qh1rkj.png",
            nominationNumber: uint256(969039304119),
            stateCode: uint8(10),
            constituencyCode: uint8(2)
        });
        candidates_[3] = Types.Candidate({
            name: "Anil Kumar Yadav",
            partyShortcut: "YSRCP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/ysrcp_sas311.png",
            nominationNumber: uint256(429300763874),
            stateCode: uint8(10),
            constituencyCode: uint8(2)
        });

        // Bihar
        candidates_[4] = Types.Candidate({
            name: "Narendra Modi",
            partyShortcut: "BJP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/bjp_nk4snw.png",
            nominationNumber: uint256(895363124093),
            stateCode: uint8(11),
            constituencyCode: uint8(1)
        });
        candidates_[5] = Types.Candidate({
            name: "Rahul Gandhi",
            partyShortcut: "INC",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/inc_s1oqn5.png",
            nominationNumber: uint256(879824052764),
            stateCode: uint8(11),
            constituencyCode: uint8(1)
        });
        candidates_[6] = Types.Candidate({
            name: "Tejaswi Yadav",
            partyShortcut: "RJD",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/1200px-RJD_Flag.svg_arrrvt.png",
            nominationNumber: uint256(994080299774),
            stateCode: uint8(11),
            constituencyCode: uint8(1)
        });
        candidates_[7] = Types.Candidate({
            name: "Arvind Kejriwal",
            partyShortcut: "AAP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/aap_ujguyl.png",
            nominationNumber: uint256(807033055701),
            stateCode: uint8(11),
            constituencyCode: uint8(1)
        });
        candidates_[8] = Types.Candidate({
            name: "Jyoti Basu",
            partyShortcut: "CPIM",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/1024px-Cpim_party_symbol.svg_mu1gpp.png",
            nominationNumber: uint256(615325500020),
            stateCode: uint8(11),
            constituencyCode: uint8(1)
        });
        candidates_[9] = Types.Candidate({
            name: "Amit Shah",
            partyShortcut: "BJP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/bjp_nk4snw.png",
            nominationNumber: uint256(611996864962),
            stateCode: uint8(11),
            constituencyCode: uint8(2)
        });
        candidates_[10] = Types.Candidate({
            name: "Priyanka Gandhi",
            partyShortcut: "INC",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/inc_s1oqn5.png",
            nominationNumber: uint256(866627241136),
            stateCode: uint8(11),
            constituencyCode: uint8(2)
        });
        candidates_[11] = Types.Candidate({
            name: "Lalu Yadav",
            partyShortcut: "RJD",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/1200px-RJD_Flag.svg_arrrvt.png",
            nominationNumber: uint256(765724506305),
            stateCode: uint8(11),
            constituencyCode: uint8(2)
        });
        candidates_[12] = Types.Candidate({
            name: "Manish Sisodia",
            partyShortcut: "AAP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/aap_ujguyl.png",
            nominationNumber: uint256(897855877716),
            stateCode: uint8(11),
            constituencyCode: uint8(2)
        });
        candidates_[13] = Types.Candidate({
            name: "Prakash Karat",
            partyShortcut: "CPIM",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/1024px-Cpim_party_symbol.svg_mu1gpp.png",
            nominationNumber: uint256(463774295590),
            stateCode: uint8(11),
            constituencyCode: uint8(2)
        });

        for (uint256 i = 0; i < candidates_.length; i++) {
            candidate[candidates_[i].nominationNumber] = candidates_[i];
            candidates.push(candidates_[i]);
        }
    }

    function initializeVoterDatabase_() internal {
        // Andhra Pradesh
        voter[uint256(482253918244)] = Types.Voter({
            name: "Suresh",
            aadharNumber: uint256(482253918244),
            age: uint8(21),
            stateCode: uint8(10),
            constituencyCode: uint8(1),
            isAlive: true,
            votedTo: uint256(0)
        });
        voter[uint256(532122269467)] = Types.Voter({
            name: "Ramesh",
            aadharNumber: uint256(532122269467),
            age: uint8(37),
            stateCode: uint8(10),
            constituencyCode: uint8(1),
            isAlive: false,
            votedTo: uint256(0)
        });
        voter[uint256(468065932286)] = Types.Voter({
            name: "Mahesh",
            aadharNumber: uint256(468065932286),
            age: uint8(26),
            stateCode: uint8(10),
            constituencyCode: uint8(1),
            isAlive: true,
            votedTo: uint256(0)
        });
        // voter[uint256(809961147437)] = Types.Voter({
        //     name: "Krishna",
        //     aadharNumber: uint256(809961147437),
        //     age: uint8(19),
        //     stateCode: uint8(10),
        //     constituencyCode: uint8(2),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(908623597782)] = Types.Voter({
        //     name: "Narendra",
        //     aadharNumber: uint256(908623597782),
        //     age: uint8(36),
        //     stateCode: uint8(10),
        //     constituencyCode: uint8(2),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(760344621247)] = Types.Voter({
        //     name: "Raghu",
        //     aadharNumber: uint256(760344621247),
        //     age: uint8(42),
        //     stateCode: uint8(10),
        //     constituencyCode: uint8(2),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // // Bihar
        voter[uint256(908704156902)] = Types.Voter({
            name: "Pushkar Kumar",
            aadharNumber: uint256(908704156902),
            age: uint8(25),
            stateCode: uint8(11),
            constituencyCode: uint8(1),
            isAlive: true,
            votedTo: uint256(0)
        });
        // voter[uint256(778925466180)] = Types.Voter({
        //     name: "Kunal Kumar",
        //     aadharNumber: uint256(778925466180),
        //     age: uint8(37),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(1),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(393071790055)] = Types.Voter({
        //     name: "Kumar Sanket",
        //     aadharNumber: uint256(393071790055),
        //     age: uint8(29),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(2),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(983881786161)] = Types.Voter({
        //     name: "Pratik",
        //     aadharNumber: uint256(983881786161),
        //     age: uint8(40),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(2),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(756623869645)] = Types.Voter({
        //     name: "Aausi",
        //     aadharNumber: uint256(756623869645),
        //     age: uint8(85),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(1),
        //     isAlive: false,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(588109459505)] = Types.Voter({
        //     name: "Pratiba",
        //     aadharNumber: uint256(588109459505),
        //     age: uint8(68),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(2),
        //     isAlive: false,
        //     votedTo: uint256(0)
        // });
        // // West Bengal
        // voter[uint256(967746320661)] = Types.Voter({
        //     name: "Ruchika",
        //     aadharNumber: uint256(967746320661),
        //     age: uint8(26),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(1),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(727938171119)] = Types.Voter({
        //     name: "Rambabu",
        //     aadharNumber: uint256(727938171119),
        //     age: uint8(17),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(1),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(609015917688)] = Types.Voter({
        //     name: "Matajii",
        //     aadharNumber: uint256(609015917688),
        //     age: uint8(98),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(1),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(620107691388)] = Types.Voter({
        //     name: "Mamata",
        //     aadharNumber: uint256(620107691388),
        //     age: uint8(63),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(2),
        //     isAlive: false,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(403561319377)] = Types.Voter({
        //     name: "Ravi Varma",
        //     aadharNumber: uint256(403561319377),
        //     age: uint8(42),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(2),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
        // voter[uint256(837970229674)] = Types.Voter({
        //     name: "Rahul",
        //     aadharNumber: uint256(837970229674),
        //     age: uint8(56),
        //     stateCode: uint8(11),
        //     constituencyCode: uint8(2),
        //     isAlive: true,
        //     votedTo: uint256(0)
        // });
    }
}
