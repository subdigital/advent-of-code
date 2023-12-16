use itertools::Itertools;
use itertools::rev;

pub fn process(input: &str) -> String {
    let ext_values = input.lines()
        .map(|line| {
            line.split_whitespace().filter_map(|x| x.parse::<i32>().ok())
        })
        .map(|row| extrapolate_diff(row.collect()));

    format!("{}", ext_values.sum::<i32>())
}

fn extrapolate_diff(nums: Vec<i32>) -> i32 {
    let mut diffs = vec![nums];
    let mut last_diff = diffs.iter().last().unwrap();

    while !last_diff.iter().all(|x| x == &0) {
        println!("{:^30}", last_diff.iter().map(i32::to_string).join(" "));
        diffs.push(differences(last_diff));
        last_diff = diffs.last().unwrap();
    }

    let mut extrapolated = 0;
    for d in rev(diffs) {
        extrapolated += d.last().unwrap();
    }
    extrapolated
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

        assert_eq!(answer, "114".to_string());
    }

    #[rstest]
    #[case(vec![0, 3, 6, 9, 12, 15], 18)]
    #[case(vec![1, 3, 6, 10, 15, 21], 28)]
    #[case(vec![10, 13, 16, 21, 30, 45], 68)]
    fn test_extrapolated_diff(
        #[case] input: Vec<i32>,
        #[case] expected: i32
    ) {
        let result = extrapolate_diff(input);
        assert_eq!(result, expected);
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
