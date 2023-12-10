use std::{ops::Range, collections::HashMap};
use nom::{character::complete::{space1, self, line_ending}, multi::{separated_list1, fold_many1, many1}, sequence::{preceded, terminated, tuple, pair}, bytes::complete::{tag, take_until}, IResult, combinator::eof, branch::alt};
use rayon::prelude::*;

pub fn process(input: &str) -> String {
    let (seeds, source_maps) = 
    tuple((
        terminated(
            parse_seeds,
            line_ending
        ),
        fold_many1(
            terminated(parse_source_map, alt((line_ending, eof))),
            HashMap::new,
            |mut maps, source_map| {
                maps.insert(source_map.name, source_map);
                maps
            })
    ))(input).unwrap().1;

    let map_names = vec!["seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light", "light-to-temperature", "temperature-to-humidity", "humidity-to-location"];
    let seeds = seeds.into_par_iter().map(|seed_range| seed_range.0..(seed_range.0 + seed_range.1));

    let maps = map_names
        .iter()
        .map(|name| source_maps.get(name).expect("missing a map"));
    let soil_num = seeds.flat_map(|s| s.into_iter()).map(|s| {
        maps.clone().fold(s.clone(), |index, source_map| {
            source_map.get(&index)
        })
    }).min().unwrap();

    format!("{}", soil_num)
}

#[derive(Debug)]
struct RangePair {
    source: Range<u64>,
    dest: Range<u64>
}

type Seed = u64;

#[allow(dead_code)]
#[derive(Debug)]
struct SourceMap<'a> {
    name: &'a str,
    ranges: Vec<RangePair>
}

impl<'a> SourceMap<'a> {
    fn get(&self, index: &u64) -> u64 {
        self.ranges.iter()
            .find(|r| r.source.contains(index))
            .map(|range_pair| {
                let offset = index - range_pair.source.start;
                range_pair.dest.start + offset
            })
            .unwrap_or(*index)
    }
}

fn parse_seeds(input: &str) -> IResult<&str, Vec<(Seed, Seed)>> {
    terminated(
        preceded(
            terminated(tag("seeds:"), space1), 
            separated_list1(space1, 
                pair(
                    terminated(complete::u64, space1),
                    complete::u64
                )
            )
        )
    , line_ending)(input)
}

fn parse_ranges(input: &str) -> IResult<&str, (Range<u64>, Range<u64>)> {
    let (input, (r1_start, r2_start, count)) = tuple((
        terminated(complete::u64, space1),
        terminated(complete::u64, space1),
        terminated(complete::u64, alt((line_ending, eof)))
    ))(input)?;
    Ok((input, (
        r1_start..(r1_start+count),
        r2_start..(r2_start+count)
    )))
}

fn parse_source_map(input: &str) -> IResult<&str, SourceMap> {
    let (input, name) = terminated(
        take_until(" "),
        terminated(tag(" map:"), line_ending)
    )(input)?;
    let (input, ranges) = many1(parse_ranges)(input)?;

    Ok((input, SourceMap {
        name,
        ranges: ranges.into_iter()
            .map(|r| RangePair { source: r.1, dest: r.0 })
            .collect()
    }))
}

#[cfg(test)]
mod test {
    use indoc::indoc;
    use nom::combinator::all_consuming;
    use super::*;

    #[test]
    fn test_parse_seeds() {
        let input = indoc! {"
        seeds: 79 14 55 13

        "};
        // let input = "seeds: 79 14 55 13\n";
        let seeds = all_consuming(
            terminated(
                parse_seeds,
                line_ending
            )
        )(input).unwrap().1;
        assert_eq!(seeds, vec![(79, 14), (55, 13)]);
    }

    #[test]
    fn test_parse_source_map() {
        let input = indoc! {"
        seed-to-soil map:
        50 98 2
        52 50 48
        "};

        let source_map = parse_source_map(input).unwrap().1;
        // dbg!(&source_map);
        assert_eq!(source_map.name, "seed-to-soil");
        assert_eq!(source_map.get(&98), 50);
        assert_eq!(source_map.get(&99), 51);
        assert_eq!(source_map.get(&50), 52);
        assert_eq!(source_map.get(&97), 99);
    }

    #[test]
    fn test_parse_ranges() {
        let input = "52 50 48\n";
        let (r1, r2) = parse_ranges(input).unwrap().1;
        assert_eq!(r1, 52..100);
        assert_eq!(r2, 50..98);
    }

    #[test]
    fn test_sample_input() {
        let input = indoc! {"
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48
        
        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15
        
        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4
        
        water-to-light map:
        88 18 7
        18 25 70
        
        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13
        
        temperature-to-humidity map:
        0 69 1
        1 0 69
        
        humidity-to-location map:
        60 56 37
        56 93 4
        "};

        let result = process(input);
        assert_eq!(result, "35".to_string());
    }

}