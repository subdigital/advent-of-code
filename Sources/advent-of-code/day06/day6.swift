
enum Day6 {
    static func run() {
        let input = readFile("day6.input")
        
        let fish = input.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)

        let sim = LanternFishSimulator(fish: fish)
        sim.runSimulation(days: 256)

        print("total fish: \(sim.fishCount)")
    }
}

class LanternFishSimulator {
    typealias Age = Int
    typealias FishCount = Int
    private(set) var fishByAge: [Age: FishCount] = [:]

    init(fish: [Int]) {
        self.fishByAge = Dictionary(grouping: fish, by: { $0 })
            .mapValues { $0.count }
    }

    func runSimulation(days: Int) {
        print("Initial State: \(fishString)")
        for day in 1...days {
            var spawnCount = 0
            fishByAge.keys.sorted().forEach { age in
                let fishAtThisAge = fishByAge[age] ?? 0
                fishByAge[age] = 0
                
                if age == 0 {
                    spawnCount = fishAtThisAge
                } else {
                    fishByAge[age - 1, default: 0] += fishAtThisAge
                }
            }
            
            let newParentAge = 6
            let newChildAge = 8
            fishByAge[newParentAge, default: 0] += spawnCount
            fishByAge[newChildAge, default: 0] += spawnCount
            
            print("After day \(day) -> \(fishString)")
        }
    }

    var fishCount: Int {
        fishByAge.values.reduce(0, +)
    }
    
    private var fishString: String {
        fishByAge.keys.sorted().map { age in 
            "\(age): \(fishByAge[age] ?? 0)"
        }.joined(separator: ", ")  + " ==> \(fishCount)"
    }
}

