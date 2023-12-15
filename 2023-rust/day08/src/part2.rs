use std::collections::BTreeMap;
use std::fmt::Display;

use nom::character::complete::{self, multispace1, alphanumeric1, line_ending};
use nom::multi::{separated_list1, fold_many1};
use nom::sequence::{delimited, separated_pair};
use nom::{IResult, branch::alt, multi::many1};
use nom::bytes::complete::tag;
use nom::{Parser, InputIter};

use num::integer::lcm;

pub fn process(input: &str) -> String {
    let (_, (dirs, tree)) = parse_input(input).unwrap();

    let root_nodes = tree.iter().filter_map(|(key,val)|
        if key.ends_with('A') {
            Some(val)
        } else {
            None
        }
    );

    // dbg!(&root_nodes);

    let mut all_steps: Vec<u64> = vec![];
    for starting_node in root_nodes {
        let mut steps = 0u64;
        let mut cur_node = starting_node;
        for dir in dirs.iter().cycle() {
            // println!("Looking at node: {}", cur_node);
            // println!("Going {:?}", dir);
            match dir {
                Direction::L => cur_node = tree.get(cur_node.left_child).unwrap(),
                Direction::R => cur_node = tree.get(cur_node.right_child).unwrap()
            }
            steps += 1;
            if cur_node.chars.iter_elements().last() == Some('Z') {
                // println!("{} found a Z in {} steps", starting_node.chars, steps);
                all_steps.push(steps);
                break;
            }
        }
    }
    let result = all_steps.into_iter().fold(1, lcm);
    format!("{}", result)
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

impl<'a> Display for Node<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_fmt(format_args!("{} -> ({}, {})", self.chars, self.left_child, self.right_child))
    }
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
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    "}, 6)]
    fn test_sample_input(#[case] input: &'static str, #[case] steps: i32) {
        assert_eq!(process(input), format!("{}", steps));
    }
}
