use nom::{sequence::{separated_pair, terminated, preceded}, character::complete::{space1, line_ending, self}, multi::separated_list1, IResult};
use nom::bytes::complete::tag;
use indoc::indoc;

#[derive(Debug)]
struct Race {
    time: u32,
    dist: u32 
}

impl Race {
    fn hold_times_to_distance(&self) -> Vec<(u32, u32)> {
        (1..self.time).map(|dur|{ 
            (dur, dur * (self.time - dur))
        }).collect()
    }
}

pub fn process(input: &str) -> String {
    let races = parse_races(input).unwrap().1;

    let result = races.iter().map(|r| {
        dbg!(r.hold_times_to_distance())
            .iter()
            .filter(|(_hold, finish)| {
                finish > &r.dist
            })
            .count()
    })
    .fold(1, |r, count| count * r );

    format!("{}", result)
}

fn parse_races(input: &str) -> IResult<&str, Vec<Race>> {
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

    Ok((
        input,
        times.iter().zip(distances)
        .map(|(time,dist)| Race { time: time.clone(), dist: dist.clone() })
        .collect()
    ))
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

    let races = parse_races(input).unwrap().1;
    assert_eq!(races.iter().map(|r| r.time).collect::<Vec<_>>(), vec![7, 15, 30]);
}

#[test]
fn test_parse_race_dist() {
    let input = indoc!{"
    Time:      7  15   30
    Distance:  9  40  200
    "};

    let races = parse_races(input).unwrap().1;
    assert_eq!(races.iter().map(|r| r.dist).collect::<Vec<_>>(), vec![9, 40, 200]);
}