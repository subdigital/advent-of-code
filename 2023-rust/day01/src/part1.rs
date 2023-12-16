pub fn process(input: &str) -> String {
    let calibration_values = input
        .lines()
        .map(|l| {
            let nums = l.chars()
                .filter(|c| c.is_numeric())
                .map(|c| c.to_string().parse::<u8>().unwrap())
                .collect::<Vec<u8>>();
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
    fn test_part1() {

        let input = "1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet";
        assert_eq!(process(input), "142".to_string());
    }
}
