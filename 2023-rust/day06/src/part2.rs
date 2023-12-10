use nom::{sequence::{separated_pair, terminated, preceded}, character::complete::{space1, line_ending, self}, multi::separated_list1, IResult};
use nom::bytes::complete::tag;
use indoc::indoc;
use itertools::Itertools;

#[derive(Debug)]
struct Race {
    time: u64,
    dist: u64 
}

impl Race {
    fn hold_times_to_distance(&self) -> Vec<(u64, u64)> {
        (1..self.time).map(|dur|{ 
            (dur, dur * (self.time - dur))
        }).collect()
    }
}

pub fn process(input: &str) -> String {
    let race = parse_races(input).unwrap().1;

    let result = race.hold_times_to_distance()
            .iter()
            .filter(|(_hold, finish)| {
                finish > &race.dist
            })
            .count();

    format!("{}", result)
}

fn parse_races(input: &str) -> IResult<&str, Race> {
    let (input, (times, distances)): (&str, (Vec<_>, Vec<_>)) = 
    separated_pair(
        preceded(
            terminated(tag("Time: "), space1),
            separated_list1(space1, complete::u32)
        ),
        line_ending,
        preceded(
            terminated(tag("Distance: "), space1),
            separated_list1(space1, complete::u32)
        )
    )(input)?;

    let time_str = times.iter().map(|t| format!("{}", t))
        .join("")
        .replace(" ", "");
    let time: u64 = time_str.parse().unwrap();

    let dist_str = distances.iter().map(|d| format!("{}", d))
        .join("")
        .replace(" ", "");
    let dist: u64 = dist_str.parse().unwrap();

    Ok((input, Race { time, dist }))
}


#[test]
fn test_sample_input() {
    let input = indoc!{"
    Time:      7  15   30
    Distance:  9  40  200
    "};

    assert_eq!("288", process(input));
}

#[test]
fn test_parse_race_times() {
    let input = indoc!{"
    Time:      7  15   30
    Distance:  9  40  200
    "};

    let race = parse_races(input).unwrap().1;
    assert_eq!(race.time, 71530);
    assert_eq!(race.dist, 940200);
}
