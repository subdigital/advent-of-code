use day01::part2::process;

fn main() {
    let input = include_str!("../input.txt");
    let answer = process(input);
    println!("Part2: {}", answer);
}