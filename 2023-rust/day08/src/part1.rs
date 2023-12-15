use std::collections::BTreeMap;

use nom::character::complete::{self, multispace1, alphanumeric1, line_ending};
use nom::multi::{separated_list1, fold_many1};
use nom::sequence::{delimited, separated_pair};
use nom::{IResult, branch::alt, multi::many1};
use nom::bytes::complete::tag;
use nom::Parser;

pub fn process(input: &str) -> String {
    let (_, (dirs, tree)) = parse_input(input).unwrap();
    let mut cur_node = tree.get("AAA").expect("should have root node");
    let mut steps = 0u32;
    for dir in dirs.iter().cycle() {
        match dir {
            Direction::L => cur_node = tree.get(cur_node.left_child).unwrap(),
            Direction::R => cur_node = tree.get(cur_node.right_child).unwrap()
        }
        steps += 1;
        if cur_node.chars == "ZZZ" {
            break;
        }
    }
    format!("{}", steps)
}

#[derive(Debug)]
enum Direction {
    L,
    R
}

#[derive(Debug)]
struct Node<'a> {
    chars: &'a str,
    left_child: &'a str,
    right_child: &'a str
}

fn parse_input(input: &str) -> IResult<&str, (Vec<Direction>, BTreeMap<&str, Node>)> {
    let (input, dirs) = many1(
        alt((
            complete::char('L').map(|_| Direction::L),
            complete::char('R').map(|_| Direction::R),
        ))
    )(input)?;

    let (input, _) = multispace1(input)?;

    let parse_node = separated_pair(
            alphanumeric1,
            tag(" = "),
            delimited(
                tag("("), 
                separated_pair(
                    alphanumeric1,
                    tag(", "),
                    alphanumeric1
                ),
                tag(")")
            )
        ).map(|(root, (left, right))| {
            Node { chars: root, left_child: left, right_child: right }
        });

        let (input, nodes) = fold_many1(separated_list1(line_ending, parse_node), BTreeMap::new, |mut tree, nodes| {
            for node in nodes {
                tree.insert(node.chars, node);
            }
            tree
        })(input)?;

        Ok((input, (dirs, nodes)))
}

#[cfg(test)]
mod test {
    use super::*;
    use rstest::rstest;
    use indoc::indoc;

    #[rstest]
    #[case(indoc!{"
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    "}, 2)]
    #[case(indoc!{"
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    "}, 6)]
    fn test_sample_input(#[case] input: &'static str, #[case] steps: i32) {
        assert_eq!(process(input), format!("{}", steps));
    }
}