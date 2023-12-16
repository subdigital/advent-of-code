use itertools::Itertools;
use itertools::rev;

pub fn process(input: &str) -> String {
    let ext_values = input.lines()
        .map(|line| {
            line.split_whitespace().filter_map(|x| x.parse::<i32>().ok())
        })
        .map(|row| extrapolate_diffs(row.collect()))
        .map(|extrapolated| extrapolated.0);

    format!("{}", ext_values.sum::<i32>())
}

fn extrapolate_diffs(nums: Vec<i32>) -> (i32, i32) {
    let mut diffs = vec![nums];
    let mut last_diff = diffs.iter().last().unwrap();

    while !last_diff.iter().all(|x| x == &0) {
        println!("{:^30}", last_diff.iter().map(i32::to_string).join(" "));
        diffs.push(differences(last_diff));
        last_diff = diffs.last().unwrap();
    }
    println!("{:^30}", last_diff.iter().map(i32::to_string).join(" "));
    rev(diffs)
        .fold((0, 0), |(mut l, mut r), seq| {
            l = seq.first().unwrap() - l;
            r += seq.last().unwrap();
            (l, r)
        })
}

fn differences(nums: &[i32]) -> Vec<i32> {
    let diffs = nums.windows(2).map(|x|
        x[1] - x[0]
    );
    diffs.collect()
}

#[cfg(test)]
mod test {
    use super::*;
    use indoc::indoc;
    use rstest::rstest;

    #[test]
    fn test_sample_input() {
        let input = indoc!{"0 3 6 9 12 15
        1 3 6 10 15 21
        10 13 16 21 30 45
        "};
        let answer = process(input);

        assert_eq!(answer, "2".to_string());
    }

    #[rstest]
    #[case(vec![0, 3, 6, 9, 12, 15], -3)]
    #[case(vec![1, 3, 6, 10, 15, 21], 0)]
    #[case(vec![10, 13, 16, 21, 30, 45], 5)]
    fn test_extrapolated_backwards(
        #[case] input: Vec<i32>,
        #[case] expected: i32
    ) {
        let result = extrapolate_diffs(input);
        assert_eq!(result.0, expected);
    }

    #[rstest]
    #[case(vec![4, 5, 8, 10], vec![1, 3, 2])]
    #[case(vec![4, 7, 10, 13], vec![3, 3, 3])]
    fn test_differences(
        #[case] nums: Vec<i32>,
        #[case] expected: Vec<i32>
    ) {
        let diffs = differences(&nums);
        assert_eq!(diffs, expected);
    }
}
