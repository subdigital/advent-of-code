use std::collections::{HashSet, HashMap};

use nom::{
    bytes::complete::tag,
    character::{
        self,
        complete::{line_ending, multispace1, multispace0},
    },
    combinator::cut,
    sequence::{preceded, delimited, terminated},
    IResult, multi::{separated_list1},
};

pub fn process(input: &str) -> String {
    let cards = parse_cards(input).expect("failed to parse cards").1;


    let mut inventory = HashMap::<u32, u32>::new();
    for card in &cards {
        inventory.insert(card.id, 1);
    }

    let total: u32 = cards.iter().fold(inventory, |mut inv, card| {
        let count = &inv.get(&card.id).unwrap().clone();
        let score: u32 = card.winning_numbers().len().try_into().unwrap();
        println!("Card {} has score {}", card.id, score);
        for i in 1..=score {
            inv.entry(card.id + i).and_modify(|v| *v += *count);
        }
        dbg!(&inv);
        inv
    })
    .values()
    .sum();

    format!("{}", total)
}

#[derive(Debug)]
#[allow(dead_code)]
struct Card {
    id: u32,
    nums: HashSet<u32>,
    winners: HashSet<u32>,
}

#[allow(dead_code)]
impl<'a> Card {
    fn winning_numbers(&self) -> Vec<&u32> {
        self.nums.intersection(&self.winners).collect()
    }

    fn value(&self) -> u32 {
        let count: u32 = self.winning_numbers().len() as u32;
        if count == 0 {
            return 0
        }

        let base: u32 = 2;
        base.pow(count - 1)
    }
}

fn parse_card(input: &str) -> IResult<&str, Card> {
    let (input, id) = preceded(
        terminated(tag("Card"), multispace1),
        character::complete::u32
    )(input)?;
    let (input, _) = delimited(multispace0, tag(":"), multispace1)(input)?;
    let (input, nums) = separated_list1(multispace1, character::complete::u32)(input)?;
    let (input, _) = delimited(multispace1, tag("|"), multispace1)(input)?;
    let (input, winners) = separated_list1(multispace1, character::complete::u32)(input)?;

    Ok((
        input,
        Card {
            id,
            nums: HashSet::from_iter(nums.iter().cloned()),
            winners: HashSet::from_iter(winners.iter().cloned())
        },
    ))
}

fn parse_cards(input: &str) -> IResult<&str, Vec<Card>> {
    separated_list1(line_ending, cut(parse_card))(input)
}

#[cfg(test)]
mod test {
    use rstest::rstest;

    use super::*;

    #[rstest]
    fn test_sample_input() {
        let input: &str = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11";

        let card = parse_card(input).unwrap().1;
        assert_eq!(card.id, 1);
        assert_eq!(card.nums, HashSet::from([41, 48, 83, 86, 17]));
        assert_eq!(card.winners, HashSet::from([83, 86, 6, 31, 17, 9, 48, 53]));

        let cards = parse_cards(input).unwrap().1;
        assert_eq!(cards.len(), 6);

        assert_eq!(process(input), "30");
    }

    #[rstest]
    #[case("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53", 4)]
    #[case("Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19", 2)]
    #[case("Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1", 2)]
    #[case("Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83", 1)]
    #[case("Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36", 0)]
    #[case("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11", 0)]
    fn test_lines(
        #[case] line: &str,
        #[case] answer: usize
    ) {
        let card = parse_card(line).expect("parse card").1;
        assert_eq!(card.winning_numbers().len(), answer);
    }
}
