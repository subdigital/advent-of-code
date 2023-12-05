use std::ops::Range;
use itertools::{self, Itertools};

pub fn process(input: &str) -> String {
    let grid_width = input.lines().next().unwrap().len();
    let grid_height = input.len() / grid_width;

    let input_one_line = input.replace("\n", "");
    let nums = parse_numbers(&input_one_line);
    let symbols = parse_symbols(&input_one_line, '*');

    let gear_ratios = symbols
        .iter()
        .map(|symbol| 
            extract_part_numbers(symbol.clone(), &nums, grid_width, grid_height)
        )
        .filter_map(|adj_parts| {
            if adj_parts.len() == 2 {
                // this is a gear
                Some(adj_parts.iter().fold(1, |a, b| a * b))
            } else {
                None
            }
        })
        .collect::<Vec<_>>();

    dbg!(&gear_ratios);

    let sum: u32 = gear_ratios.iter().sum();

    format!("{}", sum)
}

fn index_to_coords(index: usize, grid_width: usize) -> (usize, usize) {
    let y = index / grid_width;
    let x = index % grid_width;
    (x, y)
}

fn coords_to_index(x: usize, y: usize, grid_width: usize) -> usize {
    y * grid_width + x
}

fn pos_neighbors(pos: usize, grid_width: usize, grid_height: usize) -> Vec<usize> {
    let mut result = vec![];
    let (x, y) = index_to_coords(pos, grid_width);
    // above
    if y > 0 {
        result.push(coords_to_index(x, y-1, grid_width));
        if x > 0 {
            result.push(coords_to_index(x-1, y-1, grid_width));
        }
        if x < grid_width - 1 {
            result.push(coords_to_index(x+1, y-1, grid_width));
        }
    }

    // below
    if y < grid_height {
        result.push(coords_to_index(x, y+1, grid_width));
        if x > 0 {
            result.push(coords_to_index(x-1, y+1, grid_width));
        }
        if x < grid_width - 1 {
            result.push(coords_to_index(x+1, y+1, grid_width));
        }
    }

    // left (already included corners)
    if x > 0 {
        result.push(coords_to_index(x-1, y, grid_width))
    }
    if x < grid_width - 1 {
        // right
        result.push(coords_to_index(x+1, y, grid_width))
    }

    result.sort();
    result
}

fn extract_part_numbers(symbol: usize, nums: &[(u32, Range<usize>)], grid_width: usize, grid_height: usize) -> Vec<u32> {
    pos_neighbors(symbol, grid_width, grid_height)
        .into_iter()
        .flat_map(|pos| {
            nums
                .iter()
                .filter_map(move |(n, range)| {
                    if range.contains(&pos) {
                        Some(n.clone())
                    } else {
                        None
                    }
                })
        })
        .unique()
        .collect()
}

fn parse_numbers(input: &str) -> Vec<(u32, Range<usize>)> {
    let mut result: Vec<(u32, Range<usize>)> = vec![];

    let mut current_num_str = String::new();
    let mut num_start: usize = 0;
    for (index, ch) in input.char_indices() {
        if ch.is_numeric() {
            if current_num_str.is_empty() {
                num_start = index;
            }
            current_num_str.push(ch);
        } else {
            if !current_num_str.is_empty() {
                let num: u32 = current_num_str.parse().expect("should be a number");
                let range = num_start..index;
                result.push((num, range));
                current_num_str = String::new();
            }
        }
    }

    result
}

fn parse_symbols(input: &str, symbol: char) -> Vec<usize> {
    input.char_indices()
        .filter_map(|(index, ch)| {
            if ch == symbol {
                Some(index)
            } else {
                None
            }
        })
        .collect()
}

#[cfg(test)]
mod test {
    use super::*;
    #[test]
    fn test_sample_input() {
        let input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

        let result = process(input);
        assert_eq!(dbg!(result), "467835");
    }

    #[test]
    fn test_extract_part_nums() {
        let input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

        let nums = parse_numbers(&input.replace("\n", ""));
        assert_eq!(extract_part_numbers(13, &nums, 10, 10), vec![467, 35]);
        assert_eq!(extract_part_numbers(14, &nums, 10, 10), vec![114, 35]);
    }

    #[test]
    fn test_parse_symbols() {
        let input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

        let symbols = parse_symbols(&input.replace("\n", ""), '*');
        assert_eq!(symbols, vec![13, 43, 85]);
    }

    #[test]
    fn test_pos_neighbors() {
        // ...%
        // ....
        let gw = 10;
        let gh = 5;
        assert_eq!(pos_neighbors(0, gw, gh), vec![1, 10, 11]);
        assert_eq!(pos_neighbors(1, gw, gh), vec![0, 2, 10, 11, 12]);
        assert_eq!(pos_neighbors(9, gw, gh), vec![8, 18, 19]);
        assert_eq!(pos_neighbors(11, gw, gh), vec![0, 1, 2, 10, 12, 20, 21, 22]);

        assert_eq!(pos_neighbors(13, 9, 10), vec![3, 4, 5, 12, 14, 21, 22, 23]);
    }
}