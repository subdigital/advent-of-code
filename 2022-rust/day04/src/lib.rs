use nom::{
    IResult, bytes::complete::tag,
    character::complete::{self, newline}
    , multi::separated_list1
};
use std::ops::{RangeInclusive, RangeBounds};

pub fn process_part1(input: &str) -> String {
    let (_, assignments) = section_assignments(input).unwrap();

    let results = assignments
        .iter()
        .filter(|(range_a, range_b)| {
            (range_a.contains(range_b.start()) && range_a.contains(range_b.end()))
            ||
            (range_b.contains(range_a.start()) && range_b.contains(range_a.end()))
        })
        .count();
    format!("{}", results).to_string()
}

fn sections(input: &str) -> IResult<&str, RangeInclusive<u32>> {
    let (input, start) = complete::u32(input)?;
    let (input, _) = tag("-")(input)?;
    let (input, end) = complete::u32(input)?;
    Ok((input, start..=end))
}

fn line(input: &str) -> IResult<&str, (RangeInclusive<u32>, RangeInclusive<u32>)> {
    let (input, r1) = sections(input)?;
    let (input, _) = tag(",")(input)?;
    let (input, r2) = sections(input)?;
    Ok((input, (r1, r2)))
}

fn section_assignments(
    input: &str
) -> IResult<&str, Vec<(RangeInclusive<u32>, RangeInclusive<u32>)>> {
    let (input, ranges) = separated_list1(newline, line)(input)?;
    Ok((input, ranges))
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part1() {
        let input = "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8";
        println!("{}", input);
        process_part1(input);
    }
}
