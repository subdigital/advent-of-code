use std::collections::HashMap;

pub fn process(input: &str) -> String {
    let  calibration_values = input
        .lines()
        .map(|l| {
            println!("{}", l);
            
            let mut line = String::from(l);
            let literals = HashMap::from([
                ("one", "o1e"),
                ("two", "t2o"),
                ("three", "t3e"),
                ("four", "f4r"),
                ("five", "f5e"),
                ("six", "s6x"),
                ("seven", "s7n"),
                ("eight", "e8t"),
                ("nine", "n9e")
            ]);

            for (key, repl) in literals {
                line = line.replace(key, repl);
            }

            line
        })
        .map(|line| {
            let nums: Vec<u8> = line.chars()
                .filter(|c| c.is_numeric())
                .map(|c| c.to_string().parse::<u8>().unwrap())
                .collect();

            let first = nums.first().unwrap().clone();
            let last = nums.last().unwrap().clone();
            format!("{}{}", first, last).parse::<u32>().unwrap()
        });

    let sum: u32 = calibration_values.sum();
    sum.to_string()
}

#[cfg(test)]
mod test {
    use super::*;
    #[test]
    fn test_part2() {
        assert_eq!(process("one3four"), "14".to_string());
        assert_eq!(process("twofive"), "25".to_string());
        assert_eq!(process("threesix"), "36".to_string());
        assert_eq!(process("fourseven"), "47".to_string());
        assert_eq!(process("fiveeight"), "58".to_string());
        assert_eq!(process("nine"), "99".to_string());
        assert_eq!(process("8oneightgp"), "88".to_string());
        assert_eq!(process("pbkprbzvs819threeonekjpk7brkmbqbkgroneightb"), "88".to_string());
    }

    #[test]
    fn test_sample_input() {
        assert_eq!(process("two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen"), "281".to_string());
    }
}
