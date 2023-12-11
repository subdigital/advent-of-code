use core::fmt;
use std::{collections::HashMap, cmp, fmt::{Formatter, Write}};
use itertools::Itertools;

#[derive(Debug, PartialEq, Eq)]
struct HandBid {
    hand: Hand,
    bid: u32
}

impl PartialOrd for HandBid {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(&other))
    }
}

impl Ord for HandBid {
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        let type_a = self.hand.best_hand_type();
        let type_b = other.hand.best_hand_type();
        if type_a == type_b {
            // card comparison
            self.hand.cards.iter().map(|c| c.rank).cmp(
                other.hand.cards.iter().map(|c| c.rank)
            )
        } else {
            type_a.cmp(&type_b)
        }
    }
}

pub fn process(input: &str) -> String {
    let hands_and_bids = parse_hands_and_bids(input);

    let sum: u32 = hands_and_bids
        .iter()
        .sorted()
        .enumerate()
        .inspect(|(index, hand_bid)| {
            println!("Rank {} - {} ({:?}) (bid: {}, value: {})",
             index+1,
             hand_bid.hand,
             hand_bid.hand.best_hand_type(),
             hand_bid.bid,
             hand_bid.bid * (index + 1) as u32
            );
        })
        .map(|(index, hand_bid)|  ((index as u32) + 1) * hand_bid.bid)
        .sum();
    format!("{sum}")
}

fn parse_hands_and_bids(input: &str) -> Vec<HandBid> {
    input.lines().map(|line| {
        line.split_once(" ")
            .map(|(l,r)| {
                HandBid {
                    hand: parse_hand(l),
                    bid: r.parse::<u32>().expect("bid should be a num")
                }
            })
            .unwrap()
    })
    .collect()
}

#[allow(dead_code)]
#[derive(Debug, PartialEq, Eq)]
struct Hand {
    cards: Vec<Card>
}

#[allow(dead_code)]
#[derive(Debug, PartialEq, Eq, Copy, Clone)]
struct Card {
    val: char,
    rank: u32
}

impl Card {
    fn is_wild(&self) -> bool {
        self.val == 'J'
    }
}

#[allow(dead_code)]
#[derive(Debug, Eq, PartialEq, PartialOrd, Ord)]
enum HandType {
    HighCard = 1,
    Pair = 2,
    TwoPair = 3,
    ThreeKind = 4,
    FullHouse = 5,
    FourKind = 6,
    FiveKind = 7
}

fn detect_kind(count: u32) -> Box<dyn Fn(Vec<Card>) -> (Vec<Card>, bool)> {
    Box::new(move |cards: Vec<Card>| {
        let mut counts: HashMap<char, u32> = HashMap::new();
        let wild_count = cards.iter().filter(|c| c.is_wild()).count() as u32;
        // println!("Detecting kind({}) from cards: {:?} ({} wilds)", count, cards.iter().map(|c| c.val).join(""), wild_count);
        for card in cards.clone().into_iter() {
            counts.entry(card.val).and_modify(|c| *c += 1).or_insert(1);
            if counts.get(&card.val).unwrap() + wild_count >= count {
                let remaining = &cards
                    .into_iter()
                    .filter(|c| &c.val != &card.val && &c.val != &'J')
                    .collect::<Vec<Card>>();
                return (
                    remaining.clone(),
                    true
                )
            }
        }

        (cards, false)
    })
}

fn compose(
    d1: Box<dyn Fn(Vec<Card>) -> (Vec<Card>, bool)>,
    d2: Box<dyn Fn(Vec<Card>) -> (Vec<Card>, bool)>
) -> Box<dyn Fn(Vec<Card>) -> (Vec<Card>, bool)> {
    Box::new(move |cards: Vec<Card>| {
        let (remaining, found) = d1.as_ref()(cards.clone());
        if found {
            d2.as_ref()(remaining)
        } else {
            (cards, false)
        }
    })
}

fn detect_two_pair() -> Box<dyn Fn(Vec<Card>) -> (Vec<Card>, bool)> {
    compose(
        detect_kind(2),
        detect_kind(2)
    )
}

fn detect_full_house() -> Box<dyn Fn(Vec<Card>) -> (Vec<Card>, bool)> {
    compose(
        detect_kind(3),
        detect_kind(2)
    )
}

#[allow(dead_code)]
impl Hand {
    fn best_hand_type(&self) -> HandType {
        let detectors = [
            (detect_kind(5), HandType::FiveKind),
            (detect_kind(4), HandType::FourKind),
            (detect_full_house(), HandType::FullHouse),
            (detect_kind(3), HandType::ThreeKind),
            (detect_two_pair(), HandType::TwoPair),
            (detect_kind(2), HandType::Pair)
        ];

        let cards = self.cards.clone();
        detectors.into_iter()
            .find(|(d, _)| d((&cards).to_owned()).1)
            .map(|(_, ty)| ty)
            .unwrap_or(HandType::HighCard)
    }
}

impl fmt::Display for Card {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        f.write_char(self.val)
    }
}

impl fmt::Display for Hand {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        for card in &self.cards {
            card.fmt(f)?;
        }
        Ok(())
    }
}

#[allow(dead_code)]
fn parse_card(c: char) -> Option<Card> {
    match c {
        '2'..='9' => Some(Card { val: c, rank: c.to_string().parse().unwrap() }),
        'A' => Some(Card { val: c, rank: 14 }),
        'K' => Some(Card { val: c, rank: 13 }),
        'Q' => Some(Card { val: c, rank: 12 }),
        'J' => Some(Card { val: c, rank: 1 }),
        'T' => Some(Card { val: c, rank: 10 }),
        _ => None
    }
}

#[allow(dead_code)]
fn parse_hand(input: &str) -> Hand {
    let cards = input.chars().filter_map(|c| parse_card(c)).collect::<Vec<_>>();
    Hand { cards }
}

#[cfg(test)]
mod tests {
    use std::cmp::Ordering;

    use indoc::indoc;
    use super::*;

    #[test]
    fn test_sample_input() {
        let input = indoc!{"
        32T3K 765
        T55J5 684
        KK677 28
        KTJJT 220
        QQQJA 483
        "};

        let answer = process(input);
        assert_eq!(answer, "5905".to_string());
    }

    #[test]
    fn test_parse_hand() {
        let hand = parse_hand("32T3K");
        assert_eq!(hand.cards, [
            Card { val: '3', rank: 3 },
            Card { val: '2', rank: 2 },
            Card { val: 'T', rank: 10 },
            Card { val: '3', rank: 3 },
            Card { val: 'K', rank: 13 }
        ]);
    }

    #[test]
    fn test_detect_pair() {
        let cards = "35382".chars().filter_map(parse_card).collect::<Vec<_>>();
        let expected_remaining = vec![
                Card { val: '5', rank: 5 },
                Card { val: '8', rank: 8 },
                Card { val: '2', rank: 2 },
            ];
        assert_eq!(
            detect_kind(2)(cards),
            (expected_remaining, true)
        );
    }

    #[test]
    fn test_detect_two_pair() {
        let cards = "35352".chars().filter_map(parse_card).collect::<Vec<_>>();
        let expected_remaining = vec![Card { val: '2', rank: 2 }];
        assert_eq!(detect_two_pair()(cards), (expected_remaining, true));
    }

    #[test]
    fn test_three_kind_with_jokers() {
        let cards = "3523J".chars().filter_map(parse_card).collect::<Vec<_>>();
        let expected_remaining = vec![
            Card { val: '5', rank: 5 },
            Card { val: '2', rank: 2 },
            ];
        assert_eq!(detect_kind(3)(cards), (expected_remaining, true));
    }

    #[test]
    fn test_three_kind() {
        let cards = "35332".chars().filter_map(parse_card).collect::<Vec<_>>();
        let expected_remaining = vec![
            Card { val: '5', rank: 5 },
            Card { val: '2', rank: 2 }
        ];
        assert_eq!(detect_kind(3)(cards), (expected_remaining, true));
    }

    #[test]
    fn test_four_kind() {
        let cards = "35333".chars().filter_map(parse_card).collect::<Vec<_>>();
        let expected_remaining = vec![
            Card { val: '5', rank: 5 }
        ];
        assert_eq!(detect_kind(4)(cards), (expected_remaining, true));
    }

    #[test]
    fn test_full_house() {
        let cards = "35533".chars().filter_map(parse_card).collect::<Vec<_>>();
        let expected_remaining: Vec<Card> = vec![];
        assert_eq!(detect_full_house()(cards), (expected_remaining, true));
    }

    #[test]
    fn test_all_jokers() {
        let cards = "JJJJJ".chars().filter_map(parse_card).collect::<Vec<_>>();
        let hand = Hand { cards };
        assert_eq!(hand.best_hand_type(), HandType::FiveKind);
    }

    #[test]
    fn test_all_jokers_loses_to_all_aces() {
        let cards_j = "JJJJJ".chars().filter_map(parse_card).collect::<Vec<_>>();
        let cards_a = "AAAAA".chars().filter_map(parse_card).collect::<Vec<_>>();
        let hand_j = HandBid { hand: Hand { cards: cards_j }, bid: 100 };
        let hand_a = HandBid { hand: Hand { cards: cards_a }, bid: 100 };

        assert!(hand_a > hand_j);
    }
}
