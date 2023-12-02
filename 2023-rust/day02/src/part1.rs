pub fn process(input: &str) -> String {
    let max_r = 12;
    let max_g = 13;
    let max_b = 14;
    let result: u32 = input.lines()
        .map(parse_game)
        .filter(|game| {
            game.runs.iter().all(|run| {
                run.red <= max_r && run.green <= max_g && run.blue <= max_b
            })
        })
        .map(|g| g.id)
        .sum();

    format!("{}", result)
}

struct Game {
    id: u32,
    runs: Vec<GameRun>
}

struct GameRun {
    blue: u32,
    red: u32,
    green: u32
}

fn parse_game(line: &str) -> Game {
    let (game_str, runs_str) = line.split_once(": ").unwrap();
    let id: u32 = game_str.split_once(" ").unwrap().1.parse().unwrap();
    Game { id, runs: parse_runs(runs_str) }
}

fn parse_runs(line: &str) -> Vec<GameRun> {
    line.split("; ")
        .map(parse_run)
        .collect()
}

fn parse_run(input: &str) -> GameRun {
    let mut red: u32 = 0;
    let mut green: u32 = 0;
    let mut blue: u32 = 0;
    for color_str in input.split(", ") {
        let (count_str, color) = color_str.split_once(" ").unwrap();
        let count = count_str.parse().unwrap();
        match color {
            "red" => red = count,
            "blue" => blue = count,
            "green" => green = count,
            _ => {}
        };
    }
    GameRun { blue, red, green }
}

mod test {
    use super::*;

    #[test]
    fn test_sample_input() {
        let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";
        println!("{}", input);

        assert_eq!(process(input), "8");
    }
}